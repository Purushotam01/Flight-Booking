import 'package:flight_booking/core/theme/app_color.dart';
import 'package:flight_booking/core/theme/app_text_styles.dart';
import 'package:flight_booking/core/utils/responsive_util_extension.dart';
import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final VoidCallback? onTap;

  const AppBarIconButton({
    super.key,
    required this.icon,
    this.iconColor = AppColors.textPrimary,
    this.iconSize = 24,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double size = context.rs(40, tab: 4);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}

class AppCustomAppBar extends StatelessWidget {
  final String title;
  final Widget? rightWidget;

  const AppCustomAppBar({super.key, required this.title, this.rightWidget});

  @override
  Widget build(BuildContext context) {
    final double btnSize = context.rs(40, tab: 4);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.rs(16),
        context.rs(12),
        context.rs(16),
        0,
      ),
      child: Row(
        children: [
          AppBarIconButton(
            icon: Icons.chevron_left_rounded,
            iconColor: AppColors.textPrimary,
            iconSize: 26,
            onTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading3,
            ),
          ),

          rightWidget ?? SizedBox(width: btnSize, height: btnSize),
        ],
      ),
    );
  }
}
