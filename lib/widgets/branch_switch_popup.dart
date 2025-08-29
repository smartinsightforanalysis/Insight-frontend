import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';

class BranchSwitchPopup extends StatefulWidget {
  final String? currentBranchId;
  final Function(Map<String, dynamic>)? onBranchSelected;

  const BranchSwitchPopup({
    Key? key,
    this.currentBranchId,
    this.onBranchSelected,
  }) : super(key: key);

  @override
  State<BranchSwitchPopup> createState() => _BranchSwitchPopupState();
}

class _BranchSwitchPopupState extends State<BranchSwitchPopup> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _branches = [];
  List<Map<String, dynamic>> _filteredBranches = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _selectedBranchId;

  @override
  void initState() {
    super.initState();
    _selectedBranchId = widget.currentBranchId;
    _loadBranches();
    _searchController.addListener(_filterBranches);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBranches() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _apiService.getAllBranches();
      setState(() {
        _branches = List<Map<String, dynamic>>.from(response['branches'] ?? []);
        _filteredBranches = List.from(_branches);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _filterBranches() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBranches = List.from(_branches);
      } else {
        _filteredBranches = _branches.where((branch) {
          final name = (branch['branchName'] ?? '').toLowerCase();
          final address = (branch['branchAddress'] ?? '').toLowerCase();
          return name.contains(query) || address.contains(query);
        }).toList();
      }
    });
  }

  void _selectBranch(Map<String, dynamic> branch) {
    setState(() {
      _selectedBranchId = branch['id'] ?? branch['_id'];
    });
  }

  void _switchBranch() {
    if (_selectedBranchId != null) {
      final selectedBranch = _branches.firstWhere(
        (branch) => (branch['id'] ?? branch['_id']) == _selectedBranchId,
        orElse: () => {},
      );

      if (selectedBranch.isNotEmpty && widget.onBranchSelected != null) {
        widget.onBranchSelected!(selectedBranch);
      }

      Navigator.pop(context, selectedBranch.isNotEmpty ? selectedBranch : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // 60% of screen height
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations?.switchBranch ?? 'Switch Branch',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations?.searchBranch ?? 'Search Branch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText:
                        localizations?.searchBranches ?? 'Search branches...',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                    prefixIcon: Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.all(12.0),
                      child: SvgPicture.asset(
                        'assets/search.svg',
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF9CA3AF),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF209A9F)),
                  )
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: $_errorMessage',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadBranches,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF209A9F),
                          ),
                          child: Text(
                            localizations?.retry ?? 'Retry',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : _filteredBranches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.business_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isNotEmpty
                              ? (localizations?.noBranchesFound ??
                                    'No branches found')
                              : (localizations?.noBranchesAvailable ??
                                    'No branches available'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          const SizedBox(height: 8),
                        if (_searchController.text.isNotEmpty)
                          Text(
                            localizations?.tryDifferentSearchTerm ??
                                'Try a different search term',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredBranches.length,
                    itemBuilder: (context, index) {
                      final branch = _filteredBranches[index];
                      final branchId = branch['id'] ?? branch['_id'];
                      final isSelected = _selectedBranchId == branchId;

                      return _buildBranchItem(
                        context,
                        branch['branchName'] ??
                            (localizations?.unknownBranch ?? 'Unknown Branch'),
                        branch['branchAddress'] ??
                            (localizations?.unknownAddress ??
                                'Unknown Address'),
                        isSelected,
                        () => _selectBranch(branch),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedBranchId != null ? _switchBranch : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF209A9F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  localizations?.switchBranch ?? 'Switch Branch',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchItem(
    BuildContext context,
    String name,
    String location,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF209A9F).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          border: isSelected
              ? Border.all(color: const Color(0xFF209A9F), width: 1.5)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              child: SvgPicture.asset(
                'assets/branch.svg', // Assuming you have a branch SVG icon
                width: 17,
                height: 16,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? const Color(0xFF209A9F)
                      : const Color(0xFF9CA3AF),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF209A9F)
                          : const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF209A9F),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
