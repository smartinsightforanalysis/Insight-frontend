import 'package:flutter/material.dart';
import 'package:insight/l10n/app_localizations.dart';

class SecretKeyModal extends StatefulWidget {
  final Function(String?)? onSecretKeySubmitted;

  const SecretKeyModal({Key? key, this.onSecretKeySubmitted}) : super(key: key);

  @override
  State<SecretKeyModal> createState() => _SecretKeyModalState();
}

class _SecretKeyModalState extends State<SecretKeyModal> {
  final TextEditingController _secretKeyController = TextEditingController();

  @override
  void dispose() {
    _secretKeyController.dispose();
    super.dispose();
  }

  void _handleYes() {
    final secretKey = _secretKeyController.text.trim();
    if (secretKey.isNotEmpty) {
      Navigator.of(context).pop();
      widget.onSecretKeySubmitted?.call(secretKey);
    } else {
      final localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseEnterSecretKey),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleNo() {
    Navigator.of(context).pop();
    widget.onSecretKeySubmitted?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F7FB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Center(
              child: Text(
                localizations.doYouHaveSecretKey,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),

            // Secret key input field
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF209A9F), width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _secretKeyController,
                decoration: InputDecoration(
                  hintText: localizations.enterYourSecretKey,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleYes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF209A9F),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      localizations.yes,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleNo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      localizations.no,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
