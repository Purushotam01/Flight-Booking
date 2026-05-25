import 'package:flight_booking/core/theme/app_color.dart';
import 'package:flight_booking/core/theme/app_text_styles.dart';
import 'package:flight_booking/core/utils/responsive_util_extension.dart';
import 'package:flight_booking/core/widgets/app_bottom_sheet.dart';
import 'package:flight_booking/core/widgets/bottom_nav_bar.dart';
import 'package:flight_booking/core/widgets/trip_card.dart';
import 'package:flight_booking/data/models/airport_model.dart';
import 'package:flight_booking/view/home/viewmodel/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Column(
          children: [
            _HeaderSection(),
            Expanded(child: _BodySection()),
          ],
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.gradTop, AppColors.gradMid, AppColors.gradBottom],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: topPad),
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.rs(24),
              context.rs(16),
              context.rs(20),
              0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Plan your trip', style: AppTextStyles.headingWhite),
                Container(
                  width: context.rs(46, tab: 6, desk: 10),
                  height: context.rs(46, tab: 6, desk: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2),
                    color: Colors.grey.shade300,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=100&h=100&fit=crop&crop=face',
                      fit: BoxFit.cover,
                      cacheHeight: 200,
                      cacheWidth: 200,
                      loadingBuilder: (_, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.rs(30)),
          const _TripFormCard(),
          SizedBox(height: context.rs(28)),
        ],
      ),
    );
  }
}

class _TripFormCard extends StatelessWidget {
  const _TripFormCard();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.rs(18)),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF).withOpacity(0.82),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3366CC).withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        context.rs(20),
        context.rs(18),
        context.rs(20),
        context.rs(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _locationRow(
            context,
            'From',
            vm.fromLocation,
            onTap: () => _showAirportPicker(context, isFrom: true),
          ),

          SizedBox(
            height: 5,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 2,
                  child: Divider(
                    color: Color(0xFFCDD5E8),
                    thickness: 1,
                    height: 1,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: -18,
                  child: GestureDetector(
                    onTap: () => context.read<HomeViewModel>().swapLocations(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.swap_vert_rounded,
                        color: AppColors.swapIcon,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          _locationRow(
            context,
            'To',
            vm.toLocation,
            onTap: () => _showAirportPicker(context, isFrom: false),
          ),

          const SizedBox(height: 5),
          const Divider(color: Color(0xFFCDD5E8), thickness: 1, height: 1),
          SizedBox(height: context.rs(14)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      context.read<HomeViewModel>().onDepartureTapped(context),
                  behavior: HitTestBehavior.translucent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Departure', style: AppTextStyles.labelLarge),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            vm.departureDate,
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF8E9BB5),
                            size: 25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 1,
                color: const Color(0xFFCDD5E8),
                margin: const EdgeInsets.symmetric(horizontal: 14),
              ),
              Expanded(child: _PassengerField(vm: vm)),
            ],
          ),

          SizedBox(height: context.rs(14)),
          _AdvancedFiltersRow(),
          SizedBox(height: context.rs(18)),

          if (vm.searchError != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                vm.searchError!,
                style: AppTextStyles.labelTiny.copyWith(
                  color: Colors.red.shade600,
                ),
              ),
            ),
          ],

          SizedBox(
            width: double.infinity,
            height: context.rs(54, tab: 4),
            child: ElevatedButton(
              onPressed: vm.isSearching
                  ? null
                  : () => context.read<HomeViewModel>().searchFlights(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF111111),
                disabledBackgroundColor: const Color(
                  0xFF111111,
                ).withOpacity(0.55),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: vm.isSearching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Search flights',
                      style: AppTextStyles.buttonText,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationRow(
    BuildContext context,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.labelLarge),
            const SizedBox(height: 4),
            Text(value, style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }

  void _showAirportPicker(BuildContext context, {required bool isFrom}) {
    final vm = context.read<HomeViewModel>();

    if (isFrom) {
      vm.loadDepartureAirports();
    } else {
      vm.loadArrivalAirports();
    }

    showAppBottomSheet(
      context: context,
      title: isFrom ? 'Select Departure' : 'Select Arrival',
      isScrollControlled: true,
      content: ChangeNotifierProvider.value(
        value: vm,
        child: _AirportPickerSheet(isFrom: isFrom),
      ),
      confirmLabel: 'Close',
      onConfirm: () => Navigator.pop(context),
    );
  }
}

class _AirportPickerSheet extends StatefulWidget {
  final bool isFrom;
  const _AirportPickerSheet({required this.isFrom});

  @override
  State<_AirportPickerSheet> createState() => _AirportPickerSheetState();
}

class _AirportPickerSheetState extends State<_AirportPickerSheet> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final airports = widget.isFrom ? vm.departureAirports : vm.arrivalAirports;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchCtrl,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search airport or city…',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
              filled: true,
              fillColor: const Color(0xFFF5F7FF),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (query) {
              if (widget.isFrom) {
                vm.loadDepartureAirports(search: query);
              } else {
                vm.loadArrivalAirports(search: query);
              }
            },
          ),
          const SizedBox(height: 16),

          if (vm.isLoadingAirports)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(color: AppColors.blue),
            )
          else if (vm.airportsError != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Text(
                    vm.airportsError!,
                    style: AppTextStyles.labelTiny.copyWith(
                      color: AppColors.textGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      if (widget.isFrom) {
                        vm.loadDepartureAirports(search: _searchCtrl.text);
                      } else {
                        vm.loadArrivalAirports(search: _searchCtrl.text);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          else if (airports.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No airports found',
                style: AppTextStyles.labelTiny.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: airports.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (_, i) =>
                    _AirportTile(airport: airports[i], isFrom: widget.isFrom),
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AirportTile extends StatelessWidget {
  final AirportModel airport;
  final bool isFrom;

  const _AirportTile({required this.airport, required this.isFrom});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Icon(Icons.flight, color: AppColors.blue, size: 20),
        ),
      ),
      title: Text(airport.displayLabel, style: AppTextStyles.bodySmall),
      subtitle: Text(
        '${airport.flightCount} flights',
        style: AppTextStyles.labelTiny,
      ),
      onTap: () {
        final vm = context.read<HomeViewModel>();
        if (isFrom) {
          vm.setFromLocation(airport.airportCode, airport.city);
        } else {
          vm.setToLocation(airport.airportCode, airport.city);
        }
        Navigator.pop(context);
      },
    );
  }
}

class _AdvancedFiltersRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    final currentSort = HomeViewModel.sortOptions.firstWhere(
      (o) => o['value'] == vm.filters.sortBy,
      orElse: () => HomeViewModel.sortOptions.first,
    );

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showSortBottomSheet(
                context: context,
                currentSort: vm.filters.sortBy,
                sortOptions: HomeViewModel.sortOptions,
                onApply: (value) {
                  vm.setSortBy(value);
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFCDD5E8)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sort_rounded,
                    size: 16,
                    color: Color(0xFF8E9BB5),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      currentSort['label']!,
                      style: AppTextStyles.labelTiny,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            showAdvancedFilterBottomSheet(
              context: context,
              initialAirline: vm.filters.airline,
              initialAircraftType: vm.filters.aircraftType,
              initialPriceMin: vm.filters.priceMin,
              initialPriceMax: vm.filters.priceMax,
              initialStops: vm.filters.stops,
              onApply: (result) {
                vm.updateFilters(
                  FlightSearchFilters(
                    airline: result.airline,
                    aircraftType: result.aircraftType,
                    priceMin: result.priceMin,
                    priceMax: result.priceMax,
                    stops: result.stops,
                    sortBy: vm.filters.sortBy,
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: vm.hasActiveFilters ? AppColors.blue : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: vm.hasActiveFilters
                    ? AppColors.blue
                    : const Color(0xFFCDD5E8),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune_rounded,
                  size: 16,
                  color: vm.hasActiveFilters
                      ? Colors.white
                      : const Color(0xFF8E9BB5),
                ),
                const SizedBox(width: 6),
                Text(
                  'Filters',
                  style: AppTextStyles.labelTiny.copyWith(
                    color: vm.hasActiveFilters
                        ? Colors.white
                        : AppColors.textGrey,
                  ),
                ),
                if (vm.hasActiveFilters) ...[
                  const SizedBox(width: 4),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PassengerField extends StatelessWidget {
  final HomeViewModel vm;
  const _PassengerField({required this.vm});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPassengerBottomSheet(
          context: context,
          currentCount: vm.passengerCount,
          onApply: (count) {
            vm.setPassengerCount(count);
          },
        );
      },
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amount', style: AppTextStyles.airportCity),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(vm.passengerLabel, style: AppTextStyles.bodySmall),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textGrey,
                size: 25,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BodySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final double cardWidth = context.screenWidth * 0.88;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.rs(12)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.rs(24)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saved trips', style: AppTextStyles.heading2),
                GestureDetector(
                  onTap: () {},
                  child: const Text('See more', style: AppTextStyles.link),
                ),
              ],
            ),
          ),
          SizedBox(height: context.rs(16)),
          SizedBox(
            height: context.rs(225, tab: 20),
            child: Builder(
              builder: (context) {
                if (vm.isLoadingSavedTrips) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.blue),
                  );
                }
                if (vm.savedTripsError != null) {
                  return Center(
                    child: Text(
                      vm.savedTripsError!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                if (vm.savedTrips.isEmpty) {
                  return Center(
                    child: Text(
                      'No saved trips yet',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textGrey,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: context.rs(24),
                    right: context.rs(12),
                  ),
                  itemCount: vm.savedTrips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => TripCard(
                    type: TripCardType.saved,
                    width: cardWidth,
                    data: TripCardData(
                      airlineName: vm.savedTrips[i].airlineName,
                      departureTime: vm.savedTrips[i].departureTime,
                      arrivalTime: vm.savedTrips[i].arrivalTime,
                      departureCode: vm.savedTrips[i].departureCode,
                      arrivalCode: vm.savedTrips[i].arrivalCode,
                      departureCity: vm.savedTrips[i].departureCity,
                      arrivalCity: vm.savedTrips[i].arrivalCity,
                      duration: vm.savedTrips[i].duration,
                      date: vm.savedTrips[i].date,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: context.rs(30)),
        ],
      ),
    );
  }
}
