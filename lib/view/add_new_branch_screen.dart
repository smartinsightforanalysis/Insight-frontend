import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/user_session.dart';
import 'package:insight/l10n/app_localizations.dart';

class AddNewBranchScreen extends StatefulWidget {
  const AddNewBranchScreen({super.key});

  @override
  State<AddNewBranchScreen> createState() => _AddNewBranchScreenState();
}

class _AddNewBranchScreenState extends State<AddNewBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _branchNameController = TextEditingController();
  final _branchAddressController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _branchNameController.dispose();
    _branchAddressController.dispose();
    super.dispose();
  }

  Future<void> _addBranch() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = UserSession.instance.currentToken;
      if (token == null) {
        throw Exception('Authentication required');
      }

      await _apiService.addBranch(
        branchName: _branchNameController.text.trim(),
        branchAddress: _branchAddressController.text.trim(),
        token: token,
      );

      if (mounted) {
        final localizations = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizations?.branchAddedSuccessfully ??
                  'Branch added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString().replaceFirst('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations?.addNewBranch ?? 'Add New Branch',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                    fontSize: 14.0,
                  ),
                  children: [
                    TextSpan(text: localizations?.branchName ?? 'Branch Name'),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _branchNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations?.branchNameRequired ??
                        'Branch name is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText:
                      localizations?.enterBranchName ?? 'Enter branch name',
                  hintStyle: const TextStyle(color: Color(0xFFADAEBC)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                    fontSize: 14.0,
                  ),
                  children: [
                    TextSpan(
                      text: localizations?.branchAddress ?? 'Branch Address',
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _branchAddressController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return localizations?.branchAddressRequired ??
                        'Branch address is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText:
                      localizations?.enterBranchAddress ??
                      'Enter branch address',
                  hintStyle: const TextStyle(color: Color(0xFFADAEBC)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _addBranch,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF209A9F),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  localizations?.addBranch ?? 'Add Branch',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
        ),
      ),
    );
  }
}
