import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dai_auto_app/models/car.dart';

class PriceSummaryScreen extends StatelessWidget {
  const PriceSummaryScreen({
    super.key,
    required this.car,
    required this.pickupLocation,
    required this.pickupDateTime,
    required this.dropoffLocation,
    required this.dropoffDateTime,
    required this.days,
    required this.totalFromBackend,
  });

  final Car car;
  final String pickupLocation;
  final DateTime pickupDateTime;

  final String dropoffLocation;
  final DateTime dropoffDateTime;

  final int days;
  final double totalFromBackend;

  static const Color bg = Color(0xFF0B0C0E);
  static const Color gold = Color(0xFFD6A34A);
  static const Color card = Color(0xFF111317);

  @override
  Widget build(BuildContext context) {
    const double serviceFee = 5.0;

    final String pickupLine = _formatDateTime(pickupDateTime);
    final String dropoffLine = _formatDateTime(dropoffDateTime);

    // Duration (rounded up to full hours)
    final diff = dropoffDateTime.difference(pickupDateTime);
    final totalMinutes = diff.inMinutes;
    final totalHours = (totalMinutes / 60).ceil().clamp(0, 24 * 365);
    final calcDays = totalHours ~/ 24;
    final calcHours = totalHours % 24;

    final dayCost = car.pricePerDay * calcDays;
    final hourCost = (calcHours == 0) ? 0 : (car.pricePerHour * calcHours);
    final rentByRates = (dayCost + hourCost).toDouble();

    // Total is calculated from selected pickup/drop-off + fixed service fee.
    // When backend is connected, you can replace this with the backend total.
    final totalToShow = rentByRates + serviceFee;

    // Если у твоей модели Car поля называются иначе — скажи, подгоню.
    final String subtitle =
        '${car.year} / ${car.fuel} / ${car.type}';

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Price Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Car card
              _SurfaceCard(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        car.imageUrl,
                        width: 76,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 76,
                          height: 56,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${car.brand} ${car.model}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Booking Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),

              // Booking details card (NOW includes drop-off)
              _SurfaceCard(
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      title: 'Pickup',
                      value: pickupLocation,
                    ),
                    _divider(),
                    _DetailRow(
                      icon: Icons.access_time_rounded,
                      title: 'Pickup time',
                      value: pickupLine,
                    ),
                    _divider(),
                    _DetailRow(
                      icon: Icons.flag_outlined,
                      title: 'Drop-off',
                      value: dropoffLocation,
                    ),
                    _divider(),
                    _DetailRow(
                      icon: Icons.access_time_rounded,
                      title: 'Drop-off time',
                      value: dropoffLine,
                    ),
                    _divider(),
                    _DetailRow(
                      icon: Icons.shield_outlined,
                      title: 'Duration',
                      value: calcHours == 0
                          ? '$calcDays day${calcDays == 1 ? '' : 's'}'
                          : '$calcDays day${calcDays == 1 ? '' : 's'} $calcHours hour${calcHours == 1 ? '' : 's'}',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                'Price Breakdown',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),

              _SurfaceCard(
                child: Column(
                  children: [
                    if (calcDays > 0)
                      _PriceLine(
                        left: '\$${car.pricePerDay} × $calcDays day${calcDays == 1 ? '' : 's'}',
                        right: '\$${dayCost.toStringAsFixed(0)}',
                        dim: true,
                      ),
                    if (calcDays > 0 && calcHours > 0) const SizedBox(height: 10),
                    if (calcHours > 0)
                      _PriceLine(
                        left: '\$${car.pricePerHour} × $calcHours hour${calcHours == 1 ? '' : 's'}',
                        right: '\$${hourCost.toStringAsFixed(0)}',
                        dim: true,
                      ),
                    if (calcDays == 0 && calcHours == 0)
                      _PriceLine(
                        left: 'Rent',
                        right: '\$${rentByRates.toStringAsFixed(0)}',
                        dim: true,
                      ),
                    const SizedBox(height: 10),
                    _PriceLine(
                      left: 'Service fee',
                      right: '\$${serviceFee.toStringAsFixed(0)}',
                      dim: true,
                    ),
                    const SizedBox(height: 14),
                    _divider(),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${totalToShow.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: gold,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Service fee is always \$5. Total is calculated from your pickup & drop-off time.',
                      style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _PrimaryButton(
                text: 'Confirm Booking',
                onTap: () {
                  // TODO: replace with real booking id/status from backend after successful payment
                  const bookingId = 'HF-2026-0847';
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => BookingConfirmedScreen(
                        car: car,
                        bookingId: bookingId,
                        pickupLocation: pickupLocation,
                        pickupDateTime: pickupDateTime,
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _divider() => Container(
    height: 1,
    color: Colors.white.withOpacity(0.06),
  );

  static String _formatDateTime(DateTime dt) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final w = weekdays[dt.weekday - 1];
    final m = months[dt.month - 1];
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$w, $m ${dt.day} at $hh:$mm';
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({required this.child});
  final Widget child;

  static const Color card = Color(0xFF111317);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  static const Color gold = Color(0xFFD6A34A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: gold.withOpacity(0.16),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.left,
    required this.right,
    this.dim = false,
  });

  final String left;
  final String right;
  final bool dim;

  @override
  Widget build(BuildContext context) {
    final color = dim ? Colors.white.withOpacity(0.60) : Colors.white;
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          right,
          style: TextStyle(color: color, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(0.06),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, required this.onTap});
  final String text;
  final VoidCallback onTap;

  static const Color gold = Color(0xFFD6A34A);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: gold,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class BookingConfirmedScreen extends StatefulWidget {
  const BookingConfirmedScreen({
    super.key,
    required this.car,
    required this.bookingId,
    required this.pickupLocation,
    required this.pickupDateTime,
  });

  final Car car;
  final String bookingId;
  final String pickupLocation;
  final DateTime pickupDateTime;

  @override
  State<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends State<BookingConfirmedScreen> with SingleTickerProviderStateMixin {
  static const Color bg = Color(0xFF0B0C0E);
  static const Color gold = Color(0xFFD6A34A);
  static const Color card = Color(0xFF111317);
  static const Color green = Color(0xFF3DDC84);

  late final Ticker _ticker;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(() {
      if (mounted) setState(() {});
    })..start();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    final curved = CurvedAnimation(parent: _pulseController, curve: Curves.easeOut);
    _pulseScale = Tween<double>(begin: 0.7, end: 1.35).animate(curved);
    _pulseOpacity = Tween<double>(begin: 0.28, end: 0.0).animate(curved);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  String _statusText() {
    final now = DateTime.now();
    final diff = widget.pickupDateTime.difference(now);

    // If pickup is within 2 hours (or already started), show Ready for pickup
    if (diff.inSeconds <= 2 * 3600) {
      return 'Ready for pickup';
    }

    // Otherwise show countdown
    final totalSeconds = diff.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final hh = hours.toString().padLeft(2, '0');
    final mm = minutes.toString().padLeft(2, '0');
    return 'Pickup in $hh:$mm';
  }

  bool _isReady() {
    final diff = widget.pickupDateTime.difference(DateTime.now());
    return diff.inSeconds <= 2 * 3600;
  }

  @override
  Widget build(BuildContext context) {
    final status = _statusText();
    final ready = _isReady();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 34),

                    // Check icon
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FadeTransition(
                            opacity: _pulseOpacity,
                            child: ScaleTransition(
                              scale: _pulseScale,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: green.withOpacity(0.12),
                                  border: Border.all(
                                    color: green.withOpacity(0.25),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: green.withOpacity(0.18),
                              border: Border.all(color: green, width: 2),
                            ),
                            child: const Icon(Icons.check_rounded, color: green, size: 32),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Center(
                      child: Text(
                        'Booking Confirmed!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Your car has been successfully booked',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Car card
                    _SurfaceCard(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.network(
                              widget.car.imageUrl,
                              width: 76,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 76,
                                height: 56,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.car.brand} ${widget.car.model}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.car.year} / ${widget.car.fuel}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Details card
                    _SurfaceCard(
                      child: Column(
                        children: [
                          _ConfirmRow(
                            icon: Icons.directions_car_filled_outlined,
                            title: 'Booking ID',
                            value: widget.bookingId,
                          ),
                          PriceSummaryScreen._divider(),
                          _ConfirmRow(
                            icon: Icons.location_on_outlined,
                            title: 'Pickup',
                            value: widget.pickupLocation,
                          ),
                          PriceSummaryScreen._divider(),
                          _ConfirmRow(
                            icon: Icons.access_time_rounded,
                            title: 'Status',
                            value: status,
                            valueColor: ready ? green : gold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _PrimaryButton(
                text: 'Back to Home',
                onTap: () {
                  // Pop to first route (Home)
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  const _ConfirmRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  static const Color gold = Color(0xFFD6A34A);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: gold.withOpacity(0.16),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: gold, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Lightweight ticker without importing animation libraries.
class Ticker {
  Ticker(this.onTick);
  final VoidCallback onTick;
  Timer? _timer;

  void start() {
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) => onTick());
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}