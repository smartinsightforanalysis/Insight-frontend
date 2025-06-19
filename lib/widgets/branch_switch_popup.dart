import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BranchSwitchPopup extends StatefulWidget {
  const BranchSwitchPopup({Key? key}) : super(key: key);

  @override
  State<BranchSwitchPopup> createState() => _BranchSwitchPopupState();
}

class _BranchSwitchPopupState extends State<BranchSwitchPopup> {
  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'Switch Branch',
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
                const Text(
                  'Search Branch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 8.0),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Branch',
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
                        colorFilter: const ColorFilter.mode(Color(0xFF9CA3AF), BlendMode.srcIn),
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
            child: ListView(
              children: [
                _buildBranchItem(context, 'Main Branch', 'Near xyz location, UAE'),
                _buildBranchItem(context, 'Main Branch', 'Near xyz location, UAE'),
                // Add more branch items as needed
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle switch branch logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF209A9F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Switch Branch',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchItem(BuildContext context, String name, String location) {
    return InkWell(
      onTap: () {
        // Handle branch selection
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              child: SvgPicture.asset(
                'assets/branch.svg', // Assuming you have a branch SVG icon
                width: 17,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF209A9F), // Teal color for the icon
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
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
          ],
        ),
      ),
    );
  }
} 