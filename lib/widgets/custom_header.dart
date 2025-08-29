import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../l10n/app_localizations.dart';
import '../widgets/branch_switch_popup.dart';
import '../view/notification_screen.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String subtitle;
  final bool showBackButton;
  final double height;
  final Color backgroundColor;
  final double borderRadius;
  final String? currentBranchId;
  final Function(Map<String, dynamic>)? onBranchChanged;

  const CustomHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
    this.height = 110,
    this.backgroundColor = const Color(0xFF209A9F),
    this.borderRadius = 21,
    this.currentBranchId,
    this.onBranchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      toolbarHeight: height,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${localizations?.contactSupport ?? 'Please contact Support for Company Details'}\n056-3015516",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          Row(
            children: [
              SvgPicture.asset(
                'assets/branch.svg',
                width: 20,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                icon: SvgPicture.asset(
                  'assets/direction-down.svg',
                  width: 13,
                  height: 6,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return BranchSwitchPopup(
                        currentBranchId: currentBranchId,
                        onBranchSelected: onBranchChanged,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: SvgPicture.asset(
                'assets/bell.svg',
                width: 21,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF434343),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ],
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
