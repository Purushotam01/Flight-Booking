import 'package:flight_booking/core/theme/app_color.dart';
import 'package:flutter/material.dart';

enum TripCardType { saved, result, booking }

class TripCardData {
  final String airlineName;
  final String departureTime;
  final String arrivalTime;
  final String departureCode;
  final String arrivalCode;
  final String departureCity;
  final String arrivalCity;
  final String duration;
  final Color airlineBgColor;
  final Color airlineTextColor;
  final String? date;
  final double? pricePerPerson;
  final VoidCallback? onSelectFlight;
  final String? bookingId;
  final String? terminal;
  final String? gate;
  final String? flightClass;
  final String? logoUrl;

  const TripCardData({
    required this.airlineName,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureCode,
    required this.arrivalCode,
    required this.departureCity,
    required this.arrivalCity,
    required this.duration,
    this.airlineBgColor = const Color(0xFFE8F5E9),
    this.airlineTextColor = const Color(0xFF00A850),
    this.date,
    this.pricePerPerson,
    this.onSelectFlight,
    this.bookingId,
    this.terminal,
    this.gate,
    this.flightClass,
    this.logoUrl,
  });
}

class TripCard extends StatelessWidget {
  final TripCardData data;
  final TripCardType type;
  final double? width;

  const TripCard({
    super.key,
    required this.data,
    required this.type,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final cardW = width ?? double.infinity;

    return Container(
      width: cardW,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
            child: Column(
              children: [
                _buildAirlineHeader(),
                const SizedBox(height: 8),
                _buildRouteRow(),
              ],
            ),
          ),
          const TicketDivider(),
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildAirlineHeader() {
    switch (type) {
      case TripCardType.saved:
        return Text(
          data.airlineName,
          style: const TextStyle(
            color: AppColors.citilink,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.3,
          ),
        );

      case TripCardType.result:
        return Row(
          children: [
            _AirlineLogo(
              name: data.airlineName,
              bgColor: data.airlineBgColor,
              textColor: data.airlineTextColor,
              logoUrl: data.logoUrl,
            ),
            const SizedBox(width: 12),
            Text(
              data.airlineName,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
          ],
        );

      case TripCardType.booking:
        return Row(
          children: [
            _AirlineLogo(
              name: data.airlineName,
              bgColor: data.airlineBgColor,
              textColor: data.airlineTextColor,
              logoUrl: data.logoUrl,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.airlineName,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            if (data.bookingId != null)
              Text(
                data.bookingId!,
                style: const TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
          ],
        );
    }
  }

  Widget _buildRouteRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _airportCol(
          time: data.departureTime,
          code: data.departureCode,
          city: data.departureCity,
        ),
        Column(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CustomPaint(
                painter: _HalfDashedCirclePainter(),
                child: const Center(
                  child: Icon(
                    Icons.flight_takeoff,
                    color: AppColors.blue,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.duration,
              style: const TextStyle(
                color: AppColors.btnBlack,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        _airportCol(
          time: data.arrivalTime,
          code: data.arrivalCode,
          city: data.arrivalCity,
        ),
      ],
    );
  }

  Widget _airportCol({
    required String time,
    required String code,
    required String city,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              time,
              style: const TextStyle(
                color: AppColors.blue,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              code,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            '($city)',
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection() {
    switch (type) {
      case TripCardType.saved:
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dateCol('DATE', data.date ?? '', false),
              _dateCol('DATE', data.date ?? '', true),
            ],
          ),
        );

      case TripCardType.result:
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${data.pricePerPerson?.toInt() ?? 0}',
                    style: const TextStyle(
                      color: AppColors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Text(
                    '/person',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: data.onSelectFlight,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF111111),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Select flight',
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
        );

      case TripCardType.booking:
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoCol('TERMINAL', data.terminal ?? '-'),
              _infoCol('GATE', data.gate ?? '-'),
              _infoCol('Class', data.flightClass ?? '-'),
            ],
          ),
        );
    }
  }

  Widget _dateCol(String label, String date, bool right) {
    return Column(
      crossAxisAlignment: right
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _infoCol(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _AirlineLogo extends StatelessWidget {
  final String name;
  final Color bgColor;
  final Color textColor;
  final String? logoUrl;

  const _AirlineLogo({
    required this.name,
    required this.bgColor,
    required this.textColor,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final words = name.split(' ');
    final short = words.length >= 2
        ? '${words[0]}\n${words[1]}'
        : words[0].substring(0, words[0].length.clamp(0, 7));

    final fallback = Center(
      child: Text(
        short,
        style: TextStyle(
          color: textColor,
          fontSize: 8,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.1,
        ),
        textAlign: TextAlign.center,
      ),
    );

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: ClipOval(
        child: logoUrl != null && logoUrl!.isNotEmpty
            ? Image.network(
                logoUrl!,
                fit: BoxFit.cover,
                cacheHeight: 100,
                cacheWidth: 100,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return fallback;
                },
                errorBuilder: (_, __, ___) => fallback,
              )
            : fallback,
      ),
    );
  }
}

class TicketDivider extends StatelessWidget {
  const TicketDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: CustomPaint(
        painter: _TicketDividerPainter(),
        size: const Size(double.infinity, 24),
      ),
    );
  }
}

class _TicketDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const notchRadius = 18.0;
    final y = size.height / 2;

    final bgPaint = Paint()..color = const Color(0xFFECF2FB);
    canvas.drawCircle(Offset(0, y), notchRadius, bgPaint);
    canvas.drawCircle(Offset(size.width, y), notchRadius, bgPaint);

    final dashPaint = Paint()
      ..color = const Color(0xFFCDD5E8)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashWidth = 6.0;
    const dashGap = 5.0;
    final startX = notchRadius;
    final endX = size.width - notchRadius;

    double x = startX;
    while (x < endX) {
      canvas.drawLine(
        Offset(x, y),
        Offset((x + dashWidth).clamp(0, endX), y),
        dashPaint,
      );
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _HalfDashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.4)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    const totalDashes = 10;
    const sweepPerDash = 3.14159 / totalDashes;
    const gapFraction = 0.35;

    for (int i = 0; i < totalDashes; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        3.14159 + i * sweepPerDash,
        sweepPerDash * (1 - gapFraction),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
