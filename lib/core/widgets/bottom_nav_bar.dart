import 'package:flight_booking/core/theme/app_color.dart';
import 'package:flight_booking/view/home/viewmodel/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                active: vm.selectedNavIndex == 0,
                onTap: () => context.read<HomeViewModel>().setNavIndex(0),
              ),
              _NavItem(
                icon: Icons.flight_takeoff_rounded,
                active: vm.selectedNavIndex == 1,
                onTap: () => context.read<HomeViewModel>().setNavIndex(1),
              ),
              _NavItem(
                icon: Icons.map_outlined,
                active: vm.selectedNavIndex == 2,
                onTap: () => context.read<HomeViewModel>().setNavIndex(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                active: vm.selectedNavIndex == 3,
                onTap: () => context.read<HomeViewModel>().setNavIndex(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 60,
        height: 44,
        child: Center(
          child: active
              ? Icon(icon, color: AppColors.blue, size: 24)
              : Icon(icon, color: AppColors.navInactive, size: 24),
        ),
      ),
    );
  }
}
