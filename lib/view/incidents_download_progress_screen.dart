import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:insight/l10n/app_localizations.dart';
import 'package:insight/services/ai_api_service.dart';

class IncidentsDownloadProgressScreen extends StatefulWidget {
  final bool includeChartsGraphs;
  final bool includeImages;

  const IncidentsDownloadProgressScreen({
    super.key,
    required this.includeChartsGraphs,
    this.includeImages = true,
  });

  @override
  State<IncidentsDownloadProgressScreen> createState() =>
      _IncidentsDownloadProgressScreenState();
}

class _IncidentsDownloadProgressScreenState
    extends State<IncidentsDownloadProgressScreen> {
  double _progress = 0.0;
  String _status = 'Initializing...';
  bool _isComplete = false;
  bool _hasError = false;
  String _errorMessage = '';
  Timer? _timer;
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
        _status = 'Generating Incidents Report...';
        _progress = 0.2;
      });

      final exportResponse = await _aiApiService.exportIncidentsReportPdf(
        includeChartsGraphs: widget.includeChartsGraphs,
        includeImages: widget.includeImages,
      );

      // Check if export was successful
      if (exportResponse['download_url'] == null) {
        throw Exception('No download URL received from export API');
      }

      final downloadUrl = exportResponse['download_url'] as String;

      // Debug: Print the URLs being used
      print('Incidents Export API response: $exportResponse');
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
      print('PDF Download Error: $e');
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
        final fileName = 'incidents_report_$timestamp.pdf';
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(bytes);

        setState(() {
          _status = 'PDF saved to Documents';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incidents PDF saved to Documents folder'),
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
      final fileName = 'incidents_report_$timestamp.pdf';

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
              content: Text('Incidents PDF saved to Downloads folder'),
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
      final fileName = 'incidents_report_$timestamp.pdf';
      final filePath = '${directory.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(bytes);

      setState(() {
        _status = 'PDF saved to App Files';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incidents PDF saved to App Files folder'),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.exportReport,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _hasError
                      ? Colors.red.withValues(alpha: 0.1)
                      : (_isComplete
                            ? Colors.green.withValues(alpha: 0.1)
                            : const Color(0xFF16A3AC).withValues(alpha: 0.1)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _hasError
                      ? Icons.error_outline
                      : (_isComplete ? Icons.check : Icons.download),
                  size: 40,
                  color: _hasError
                      ? Colors.red
                      : (_isComplete ? Colors.green : const Color(0xFF16A3AC)),
                ),
              ),
              const SizedBox(height: 24.0),

              // Status Text
              Text(
                _status,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: _hasError ? Colors.red : const Color(0xFF1C3557),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),

              // Progress Bar
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

              // Progress Percentage
              Text(
                _hasError
                    ? 'Error occurred'
                    : '${(_progress * 100).toInt()}% Complete',
                style: TextStyle(
                  fontSize: 14.0,
                  color: _hasError ? Colors.red : const Color(0xFF4A4A4A),
                ),
              ),

              // Error Message
              if (_hasError && _errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 12.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
