import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:insight/services/ai_api_service.dart';

class DownloadProgressScreen extends StatefulWidget {
  const DownloadProgressScreen({super.key});

  @override
  State<DownloadProgressScreen> createState() => _DownloadProgressScreenState();
}

class _DownloadProgressScreenState extends State<DownloadProgressScreen> {
  double _progress = 0.0;
  Timer? _timer;
  String _status = 'Initializing...';
  bool _isComplete = false;
  bool _hasError = false;
  String _errorMessage = '';
  final AiApiService _aiApiService = AiApiService();

  @override
  void initState() {
    super.initState();
    _startPDFDownload();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startPDFDownload() async {
    try {
      // Step 1: Call export API to get download URL (20% progress)
      setState(() {
        _status = 'Generating Dashboard PDF...';
        _progress = 0.2;
      });

      final exportResponse = await _aiApiService.exportDashboardPdf();

      // Check if export was successful
      if (exportResponse['download_url'] == null) {
        throw Exception('No download URL received from export API');
      }

      final downloadUrl = exportResponse['download_url'] as String;

      // Debug: Print the URLs being used
      print('Dashboard Export API response: $exportResponse');
      print('Download URL from API: $downloadUrl');

      // Step 2: Download PDF using the provided URL (40% progress)
      setState(() {
        _status = 'Downloading PDF...';
        _progress = 0.4;
      });

      final bytes = await _aiApiService.downloadPdfFile(downloadUrl);

      // Simulate progressive download with visual feedback
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _progress += 0.05;
          if (_progress >= 0.95) {
            _progress = 1.0;
            _status = 'Download Complete!';
            _isComplete = true;
            _timer?.cancel();

            // Auto-close after 2 seconds
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            });
          }
        });
      });

      // Save the PDF to device storage
      await _savePDFToDevice(bytes);
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _status = 'Download Failed';
      });
      print('Dashboard PDF Download Error: $e');
    }
  }

  Future<void> _savePDFToDevice(List<int> bytes) async {
    try {
      if (Platform.isAndroid) {
        // Use platform channel to save to Downloads folder on Android
        await _saveToDownloadsAndroid(bytes);
      } else if (Platform.isIOS) {
        // For iOS, use the Documents directory
        final directory = await getApplicationDocumentsDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = 'insight_dashboard_report_$timestamp.pdf';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(bytes);

        setState(() {
          _status = 'PDF saved to Documents';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF saved to Documents folder'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _status = 'Download complete (save failed)';
        _hasError = true;
        _errorMessage = 'Could not save to device storage';
      });
    }
  }

  Future<void> _saveToDownloadsAndroid(List<int> bytes) async {
    try {
      const platform = MethodChannel('com.example.insight/downloads');

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'insight_dashboard_report_$timestamp.pdf';

      final result = await platform.invokeMethod('saveToDownloads', {
        'fileName': fileName,
        'bytes': bytes,
      });

      if (result == true) {
        setState(() {
          _status = 'PDF saved to Downloads';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('PDF saved to Downloads folder'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        throw Exception('Failed to save file');
      }
    } catch (e) {
      // Fallback to app directory if platform channel fails
      await _saveToAppDirectory(bytes);
    }
  }

  Future<void> _saveToAppDirectory(List<int> bytes) async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'insight_dashboard_report_$timestamp.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      setState(() {
        _status = 'PDF saved to App Files';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF saved to App Files folder'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 6),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/downloadd.svg',
                    width: 25,
                    height: 25,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF16A3AC),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                _hasError
                    ? 'Download Failed'
                    : (_isComplete ? 'Download Complete!' : _status),
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: _hasError
                      ? Colors.red
                      : (_isComplete ? Colors.green : const Color(0xFF4A4A4A)),
                ),
              ),
              if (_hasError) ...[
                const SizedBox(height: 8.0),
                Text(
                  _errorMessage,
                  style: const TextStyle(fontSize: 14.0, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: LinearProgressIndicator(
                    value: _hasError ? 1.0 : _progress,
                    minHeight: 8.0,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _hasError
                          ? Colors.red
                          : (_isComplete
                                ? Colors.green
                                : const Color(0xFF16A3AC)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                _hasError
                    ? 'Error occurred'
                    : '${(_progress * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: 14.0,
                  color: _hasError ? Colors.red : const Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _timer?.cancel();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFBDBDBD),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text(
                      _isComplete ? 'Done' : (_hasError ? 'Close' : 'Cancel'),
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
