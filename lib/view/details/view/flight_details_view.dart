import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flight_booking/core/theme/app_color.dart';
import 'package:flight_booking/core/theme/app_text_styles.dart';
import 'package:flight_booking/core/utils/responsive_util_extension.dart';
import 'package:flight_booking/core/widgets/custom_appbar.dart';
import 'package:flight_booking/core/widgets/trip_card.dart';
import 'package:flight_booking/data/repositories/flight_repository.dart';
import 'package:flight_booking/view/details/viewmodel/flight_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:provider/provider.dart';

class FlightDetailsScreen extends StatelessWidget {
  final int flightId;
  final FlightRepository repository;

  const FlightDetailsScreen({
    super.key,
    required this.flightId,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          FlightDetailsViewModel(repository: repository, flightId: flightId),
      child: const _FlightDetailsView(),
    );
  }
}

class _FlightDetailsView extends StatefulWidget {
  const _FlightDetailsView();

  @override
  State<_FlightDetailsView> createState() => _FlightDetailsViewState();
}

class _FlightDetailsViewState extends State<_FlightDetailsView> {
  final GlobalKey _ticketKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveTicket() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
          _ticketKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) throw Exception('Could not find ticket boundary');

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List? bytes = byteData?.buffer.asUint8List();

      if (bytes != null) {
        await Gal.putImageBytes(bytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ticket saved to gallery successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save ticket: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FlightDetailsViewModel>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              const AppCustomAppBar(title: 'Your flight details'),
              Expanded(child: _buildBody(context, vm)),
            ],
          ),
        ),
        bottomNavigationBar: vm.hasData
            ? _BottomBar(onDownload: _saveTicket, isSaving: _isSaving)
            : null,
      ),
    );
  }

  Widget _buildBody(BuildContext context, FlightDetailsViewModel vm) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blue),
      );
    }

    if (vm.errorMessage != null && !vm.hasData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.textGrey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                vm.errorMessage!,
                style: AppTextStyles.labelTiny.copyWith(
                  color: AppColors.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => vm.retry(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        context.rs(16),
        context.rs(20),
        context.rs(16),
        100,
      ),
      child: RepaintBoundary(
        key: _ticketKey,
        child: Container(
          color: AppColors.scaffoldBg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _BookingCard(),
              SizedBox(height: 20),
              _PassengersCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<FlightDetailsViewModel>();
    return TripCard(
      type: TripCardType.booking,
      width: double.infinity,
      data: TripCardData(
        airlineName: vm.airlineName,
        logoUrl: vm.logoUrl,
        departureTime: vm.departureTime,
        arrivalTime: vm.arrivalTime,
        departureCode: vm.departureCode,
        arrivalCode: vm.arrivalCode,
        departureCity: vm.departureCity,
        arrivalCity: vm.arrivalCity,
        duration: vm.duration,
        bookingId: vm.bookingId,
        terminal: vm.terminal,
        gate: vm.gate,
        flightClass: vm.flightClass,
      ),
    );
  }
}

class _PassengersCard extends StatelessWidget {
  const _PassengersCard();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<FlightDetailsViewModel>();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(18),
              context.rs(18),
              context.rs(18),
              context.rs(12),
            ),
            child: const Text('Passengers Info', style: AppTextStyles.heading2),
          ),

          ...List.generate(vm.passengers.length, (i) {
            final p = vm.passengers[i];
            final isLast = i == vm.passengers.length - 1;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.rs(18),
                    context.rs(8),
                    context.rs(18),
                    context.rs(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: context.rs(44, tab: 4),
                        height: context.rs(44, tab: 4),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipOval(
                          child: Image.network(
                            p.avatarUrl,
                            fit: BoxFit.cover,
                            cacheHeight: 200,
                            cacheWidth: 200,
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: AppColors.scaffoldBg,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.textGrey,
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.scaffoldBg,
                              child: const Icon(
                                Icons.person,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: context.rs(12)),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.label, style: AppTextStyles.labelTiny),
                            const SizedBox(height: 4),
                            Text(p.name, style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('SEAT', style: AppTextStyles.labelTiny),
                          const SizedBox(height: 4),
                          Text(p.seat, style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.rs(18)),
                    child: const Divider(color: AppColors.divider, height: 1),
                  ),
              ],
            );
          }),

          const TicketDivider(),

          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(18),
              context.rs(16),
              context.rs(18),
              context.rs(20),
            ),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              child: CustomPaint(painter: _BarcodePainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.textPrimary;
    final random = [
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      1,
      2,
      1,
      1,
      2,
      1,
      1,
      1,
      2,
    ];
    double x = 0;
    bool isBar = true;
    for (final w in random) {
      final barW = w * (size.width / 120);
      if (isBar) {
        canvas.drawRect(Rect.fromLTWH(x, 0, barW, size.height), paint);
      }
      x += barW;
      isBar = !isBar;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onDownload;
  final bool isSaving;

  const _BottomBar({required this.onDownload, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.scaffoldBg,
      padding: EdgeInsets.fromLTRB(
        context.rs(16),
        context.rs(12),
        context.rs(16),
        32,
      ),
      child: SizedBox(
        width: double.infinity,
        height: context.rs(54, tab: 4),
        child: ElevatedButton(
          onPressed: isSaving ? null : onDownload,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.btnBlack,
            disabledBackgroundColor: AppColors.btnBlack.withOpacity(0.7),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Download & Save pass',
                  style: AppTextStyles.buttonText,
                ),
        ),
      ),
    );
  }
}
