import 'package:flutter/material.dart';
import 'package:flight_booking/core/theme/app_color.dart';
import 'package:flight_booking/core/theme/app_text_styles.dart';

Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget content,
  String confirmLabel = 'Confirm',
  required VoidCallback onConfirm,
  bool isScrollControlled = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        isScrollControlled ? MediaQuery.of(ctx).viewInsets.bottom + 24 : 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          content,
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.btnBlack,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                confirmLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
}

Future<void> showSortBottomSheet({
  required BuildContext context,
  required String currentSort,
  required List<Map<String, String>> sortOptions,
  required ValueChanged<String> onApply,
}) {
  String tempSort = currentSort;

  return showAppBottomSheet(
    context: context,
    title: 'Sort By',
    confirmLabel: 'Apply',
    content: StatefulBuilder(
      builder: (_, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: sortOptions.map((opt) {
          final isSelected = opt['value'] == tempSort;
          return GestureDetector(
            onTap: () => setState(() => tempSort = opt['value']!),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.blue.withOpacity(0.08)
                    : const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.blue : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      opt['label']!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.blue
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.blue,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
    onConfirm: () {
      onApply(tempSort);
      Navigator.pop(context);
    },
  );
}

Future<void> showAdvancedFilterBottomSheet({
  required BuildContext context,
  required String? initialAirline,
  required String? initialAircraftType,
  required double? initialPriceMin,
  required double? initialPriceMax,
  required int? initialStops,
  required ValueChanged<_FilterResult> onApply,
}) {
  final airlineCtrl = TextEditingController(text: initialAirline ?? '');
  final aircraftCtrl = TextEditingController(text: initialAircraftType ?? '');
  final priceMinCtrl = TextEditingController(
    text: initialPriceMin?.toStringAsFixed(0) ?? '',
  );
  final priceMaxCtrl = TextEditingController(
    text: initialPriceMax?.toStringAsFixed(0) ?? '',
  );
  int? tempStops = initialStops;

  InputDecoration fieldDecor(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textGrey),
    filled: true,
    fillColor: const Color(0xFFF5F7FF),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  return showAppBottomSheet(
    context: context,
    title: 'Advanced Filters',
    confirmLabel: 'Apply Filters',
    isScrollControlled: true,
    content: StatefulBuilder(
      builder: (_, setState) => SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => setState(() {
                  airlineCtrl.clear();
                  aircraftCtrl.clear();
                  priceMinCtrl.clear();
                  priceMaxCtrl.clear();
                  tempStops = null;
                }),
                child: Text('Clear all', style: AppTextStyles.link),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Airline', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: airlineCtrl,
              style: AppTextStyles.bodyMedium,
              decoration: fieldDecor('e.g. Garuda, Lion Air'),
            ),
            const SizedBox(height: 16),
            const Text('Price Range (USD)', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: priceMinCtrl,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium,
                    decoration: fieldDecor('Min').copyWith(prefixText: '\$'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('–', style: AppTextStyles.bodyMedium),
                ),
                Expanded(
                  child: TextField(
                    controller: priceMaxCtrl,
                    keyboardType: TextInputType.number,
                    style: AppTextStyles.bodyMedium,
                    decoration: fieldDecor('Max').copyWith(prefixText: '\$'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Stops', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StopChip(
                  label: 'Any',
                  isSelected: tempStops == null,
                  onTap: () => setState(() => tempStops = null),
                ),
                _StopChip(
                  label: 'Direct',
                  isSelected: tempStops == 0,
                  onTap: () => setState(() => tempStops = 0),
                ),
                _StopChip(
                  label: '1 Stop',
                  isSelected: tempStops == 1,
                  onTap: () => setState(() => tempStops = 1),
                ),
                _StopChip(
                  label: '2+',
                  isSelected: tempStops == 2,
                  onTap: () => setState(() => tempStops = 2),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Aircraft Type', style: AppTextStyles.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: aircraftCtrl,
              style: AppTextStyles.bodyMedium,
              decoration: fieldDecor('e.g. Boeing 737, Airbus A320'),
            ),
          ],
        ),
      ),
    ),
    onConfirm: () {
      onApply(
        _FilterResult(
          airline: airlineCtrl.text.trim().isEmpty
              ? null
              : airlineCtrl.text.trim(),
          aircraftType: aircraftCtrl.text.trim().isEmpty
              ? null
              : aircraftCtrl.text.trim(),
          priceMin: double.tryParse(priceMinCtrl.text),
          priceMax: double.tryParse(priceMaxCtrl.text),
          stops: tempStops,
        ),
      );
      Navigator.pop(context);
    },
  );
}

Future<void> showPassengerBottomSheet({
  required BuildContext context,
  required int currentCount,
  required ValueChanged<int> onApply,
}) {
  int tempCount = currentCount;

  return showAppBottomSheet(
    context: context,
    title: 'Passengers',
    confirmLabel: 'Confirm',
    content: StatefulBuilder(
      builder: (_, setState) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: tempCount > 1 ? () => setState(() => tempCount--) : null,
            icon: const Icon(Icons.remove_circle_outline),
            iconSize: 32,
            color: AppColors.btnBlack,
          ),
          const SizedBox(width: 24),
          Text('$tempCount', style: AppTextStyles.priceLarge),
          const SizedBox(width: 24),
          IconButton(
            onPressed: tempCount < 9 ? () => setState(() => tempCount++) : null,
            icon: const Icon(Icons.add_circle_outline),
            iconSize: 32,
            color: AppColors.btnBlack,
          ),
        ],
      ),
    ),
    onConfirm: () {
      onApply(tempCount);
      Navigator.pop(context);
    },
  );
}

class _FilterResult {
  final String? airline;
  final String? aircraftType;
  final double? priceMin;
  final double? priceMax;
  final int? stops;

  const _FilterResult({
    this.airline,
    this.aircraftType,
    this.priceMin,
    this.priceMax,
    this.stops,
  });
}

class _StopChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StopChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : const Color(0xFFF5F7FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelTiny.copyWith(
            color: isSelected ? Colors.white : AppColors.textGrey,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
