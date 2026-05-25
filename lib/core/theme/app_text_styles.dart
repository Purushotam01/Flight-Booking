import 'package:flutter/material.dart';
import 'app_color.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle heading1 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  static const TextStyle heading3 = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 21,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodySmall = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle labelLarge = TextStyle(
    color: AppColors.textGrey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    color: AppColors.textGrey,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelTiny = TextStyle(
    color: AppColors.textGrey,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );

  static const TextStyle airportCode = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle airportCity = TextStyle(
    color: AppColors.textGrey,
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle airportTime = TextStyle(
    color: AppColors.btnBlack,
    fontSize: 13,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle priceLarge = TextStyle(
    color: AppColors.btnBlack,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle priceLabel = TextStyle(
    color: AppColors.textGrey,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
  );

  static const TextStyle buttonSmall = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle airlineNameItalic = TextStyle(
    color: AppColors.citilink,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.3,
  );

  static const TextStyle airlineName = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 17,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle dateValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle dateLabel = TextStyle(
    color: AppColors.textGrey,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );

  static const TextStyle duration = TextStyle(
    color: AppColors.textGrey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle headingWhite = TextStyle(
    color: AppColors.textWhite,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
  );

  static const TextStyle link = TextStyle(
    color: AppColors.textGrey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bookingValue = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle bookingId = TextStyle(
    color: AppColors.textGrey,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}
