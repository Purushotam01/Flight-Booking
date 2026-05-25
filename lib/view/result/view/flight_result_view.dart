import 'package:flight_booking/core/theme/app_color.dart';
import 'package:flight_booking/core/theme/app_text_styles.dart';
import 'package:flight_booking/core/utils/responsive_util_extension.dart';
import 'package:flight_booking/core/widgets/app_bottom_sheet.dart';
import 'package:flight_booking/core/widgets/custom_appbar.dart';
import 'package:flight_booking/core/widgets/trip_card.dart';
import 'package:flight_booking/data/models/flight_model.dart';
import 'package:flight_booking/data/models/pagination_model.dart';
import 'package:flight_booking/data/repositories/flight_repository.dart';
import 'package:flight_booking/view/details/view/flight_details_view.dart';
import 'package:flight_booking/view/home/viewmodel/home_controller.dart';
import 'package:flight_booking/view/result/viewmodel/flight_result_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FlightResultScreen extends StatelessWidget {
  final String fromCode;
  final String toCode;
  final String fromCity;
  final String toCity;
  final String departureDate;
  final int passengerCount;
  final FlightSearchFilters filters;
  final List<FlightApiModel> initialFlights;
  final PaginationModel initialPagination;
  final FlightRepository repository;

  const FlightResultScreen({
    super.key,
    required this.fromCode,
    required this.toCode,
    required this.fromCity,
    required this.toCity,
    required this.departureDate,
    required this.passengerCount,
    required this.filters,
    required this.initialFlights,
    required this.initialPagination,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FlightResultViewModel(
        repository: repository,
        fromCode: fromCode,
        toCode: toCode,
        fromCity: fromCity,
        toCity: toCity,
        departureDate: departureDate,
        passengerCount: passengerCount,
        filters: filters,
        initialFlights: initialFlights,
        initialPagination: initialPagination,
      ),
      child: const _FlightResultView(),
    );
  }
}

class _FlightResultView extends StatelessWidget {
  const _FlightResultView();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => _showFilterSheet(context),
            backgroundColor: AppColors.fabBlue,
            elevation: 0,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.filter_alt_rounded,
              color: AppColors.blue,
              size: 28,
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.resultGradTop,
                AppColors.resultGradMid,
                AppColors.resultGradBottom,
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                AppCustomAppBar(
                  title: 'Flight result',
                  rightWidget: AppBarIconButton(
                    icon: Icons.more_vert_rounded,
                    iconColor: AppColors.textPrimary,
                    iconSize: 20,
                  ),
                ),
                SizedBox(height: context.rs(16)),
                const _FilterBar(),
                SizedBox(height: context.rs(16)),
                const Expanded(child: _ResultList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final vm = context.read<FlightResultViewModel>();
    int tempFilter = vm.selectedFilter;

    showAppBottomSheet(
      context: context,
      title: 'Sort Flights',
      confirmLabel: 'Apply',
      content: StatefulBuilder(
        builder: (_, setState) => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(vm.filterLabels.length, (i) {
            final isActive = tempFilter == i;
            return GestureDetector(
              onTap: () => setState(() => tempFilter = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.blue : const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  vm.filterLabels[i],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isActive ? Colors.white : AppColors.textGrey,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
      onConfirm: () {
        vm.setFilter(tempFilter);
        Navigator.pop(context);
      },
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FlightResultViewModel>();

    return SizedBox(
      height: context.rs(40, tab: 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.rs(16)),
        itemCount: vm.filterLabels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final isActive = vm.selectedFilter == i;
          return GestureDetector(
            onTap: () => vm.setFilter(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: context.rs(18)),
              decoration: BoxDecoration(
                color: isActive ? AppColors.blue : AppColors.cardWhite,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  vm.filterLabels[i],
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isActive ? AppColors.textWhite : AppColors.textGrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FlightResultViewModel>();

    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.blue),
      );
    }

    if (vm.errorMessage != null && !vm.hasResults) {
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

    if (!vm.hasResults) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flight_takeoff,
                size: 64,
                color: AppColors.textGrey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'No flights found',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your filters or search for a different date.',
                style: AppTextStyles.labelTiny.copyWith(
                  color: AppColors.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.extentAfter < 200 &&
            vm.hasNextPage &&
            !vm.isLoadingMore) {
          vm.loadNextPage();
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(16),
          vertical: context.rs(4),
        ),
        itemCount: vm.results.length + (vm.isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: context.rs(16)),
        itemBuilder: (_, i) {
          if (i >= vm.results.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.blue),
              ),
            );
          }
          return _FlightCard(flight: vm.results[i], repository: vm.repository);
        },
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final FlightApiModel flight;
  final FlightRepository repository;
  const _FlightCard({required this.flight, required this.repository});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TripCard(
          type: TripCardType.result,
          data: TripCardData(
            airlineName: flight.airlineName,
            logoUrl: flight.airlineLogo,
            departureTime: flight.departureTimeShort,
            arrivalTime: flight.arrivalTimeShort,
            departureCode: flight.departure.airportCode,
            arrivalCode: flight.arrival.airportCode,
            departureCity: flight.departure.city,
            arrivalCity: flight.arrival.city,
            duration: flight.duration,
            pricePerPerson: flight.price.amount,
            onSelectFlight: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FlightDetailsScreen(
                    flightId: flight.id,
                    repository: repository,
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: flight.stops == 0
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      flight.stops == 0
                          ? Icons.flight_rounded
                          : Icons.connecting_airports_rounded,
                      size: 12,
                      color: flight.stops == 0
                          ? const Color(0xFF388E3C)
                          : const Color(0xFFF57C00),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      flight.stops == 0
                          ? 'Direct'
                          : '${flight.stops} Stop${flight.stops > 1 ? 's' : ''}',
                      style: AppTextStyles.labelTiny.copyWith(
                        color: flight.stops == 0
                            ? const Color(0xFF388E3C)
                            : const Color(0xFFF57C00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
