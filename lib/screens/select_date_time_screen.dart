import 'package:flutter/material.dart';
import 'package:dai_auto_app/models/car.dart';
import 'package:dai_auto_app/screens/price_summary_screen.dart';

class SelectDateTimeScreen extends StatefulWidget {
  const SelectDateTimeScreen({
    super.key,
    required this.car,
    this.days = 1,
    this.totalFromBackend = 0,
  });

  final Car car;
  final int days;
  final double totalFromBackend;

  @override
  State<SelectDateTimeScreen> createState() => _SelectDateTimeScreenState();
}

class _SelectDateTimeScreenState extends State<SelectDateTimeScreen> {
  static const Color bg = Color(0xFF0B0C0E);
  static const Color gold = Color(0xFFD6A34A);
  static const Color card = Color(0xFF111317);

  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;
  int selectedTimePage = 0;

  late final List<_DateItem> dates;

  // 2 страницы времени: день и поздний вечер/ночь
  final List<List<String>> timePages = const [
    [
      '08:00', '09:00', '10:00', '11:00',
      '12:00', '13:00', '14:00', '15:00',
      '16:00', '17:00', '18:00', '19:00',
    ],
    [
      '20:00', '21:00', '22:00', '23:00',
      '00:00', '01:00', '02:00', '03:00',
      '04:00', '05:00', '06:00', '07:00',
    ],
  ];

  final List<String> locations = const [
    'Downtown Hub',
    'Airport Terminal A',
    'Airport Terminal B',
    'Central Mall Parking',
    'North District Station',
    'University Gate',
    'Business Center Plaza',
    'South Park Entrance',
    'Old Town Square',
    'West Side Garage',
  ];

  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = locations.first;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    dates = List.generate(7, (i) => _DateItem.fromDate(today.add(Duration(days: i))));
  }

  Future<void> _openLocationPicker() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose pickup location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: locations.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.white.withOpacity(0.06),
                      height: 1,
                    ),
                    itemBuilder: (context, i) {
                      final loc = locations[i];
                      final isSelected = loc == selectedLocation;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => Navigator.of(context).pop(loc),
                        title: Text(
                          loc,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                            isSelected ? FontWeight.w900 : FontWeight.w700,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_rounded, color: gold)
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => selectedLocation = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageTimes = timePages[selectedTimePage];

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Select Date & Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pick a date
                    const _SectionTitle(
                      icon: Icons.calendar_month_outlined,
                      title: 'Pick a Date',
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final isSelected = i == selectedDateIndex;
                          return _DateCard(
                            day: dates[i].day,
                            date: dates[i].dayOfMonth,
                            isSelected: isSelected,
                            onTap: () => setState(() => selectedDateIndex = i),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Pickup time + arrows
                    Row(
                      children: [
                        const _SectionTitle(
                          icon: Icons.access_time_rounded,
                          title: 'Pickup Time',
                        ),
                        const Spacer(),
                        _MiniIconButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: selectedTimePage == 0
                              ? null
                              : () {
                            setState(() {
                              selectedTimePage--;
                              selectedTimeIndex = 0;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        _MiniIconButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: selectedTimePage == timePages.length - 1
                              ? null
                              : () {
                            setState(() {
                              selectedTimePage++;
                              selectedTimeIndex = 0;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    GridView.builder(
                      itemCount: pageTimes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.6,
                      ),
                      itemBuilder: (context, i) {
                        final isSelected = i == selectedTimeIndex;
                        return _TimeChip(
                          text: pageTimes[i],
                          isSelected: isSelected,
                          onTap: () => setState(() => selectedTimeIndex = i),
                        );
                      },
                    ),

                    const SizedBox(height: 22),

                    // Pickup location
                    const Text(
                      'Pickup Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),

                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: _openLocationPicker,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(18),
                          border:
                          Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: gold, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                selectedLocation ?? 'Choose location',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.expand_more_rounded,
                                color: Colors.white70),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                    const SizedBox(height: 80), // space for bottom button
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _PrimaryButton(
                text: 'Calculate Price',
                onTap: () async {
                  final loc = selectedLocation ?? locations.first;
                  final timeStr = pageTimes[selectedTimeIndex];
                  final parts = timeStr.split(':');
                  final hh = int.parse(parts[0]);
                  final mm = int.parse(parts[1]);

                  final selectedDate = dates[selectedDateIndex].date;
                  final pickupDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    hh,
                    mm,
                  );

                  final total = widget.totalFromBackend == 0
                      ? (widget.car.pricePerDay * widget.days + 5).toDouble()
                      : widget.totalFromBackend;

                  final startLocation = loc;
                  final ret = await Navigator.of(context).push<_ReturnSelection>(
                    MaterialPageRoute(
                      builder: (_) => SelectReturnDateTimeScreen(
                        startDateTime: pickupDateTime,
                        startLocation: startLocation,
                        locations: locations,
                      ),
                    ),
                  );

                  if (ret == null) return;

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PriceSummaryScreen(
                        car: widget.car,
                        pickupLocation: startLocation,
                        pickupDateTime: pickupDateTime,
                        dropoffLocation: ret.dropoffLocation,
                        dropoffDateTime: ret.dropoffDateTime,
                        days: widget.days,
                        totalFromBackend: total,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------- SelectReturnDateTimeScreen -----------

class SelectReturnDateTimeScreen extends StatefulWidget {
  const SelectReturnDateTimeScreen({
    super.key,
    required this.startDateTime,
    required this.startLocation,
    required this.locations,
  });

  final DateTime startDateTime;
  final String startLocation;
  final List<String> locations;

  @override
  State<SelectReturnDateTimeScreen> createState() => _SelectReturnDateTimeScreenState();
}

class _SelectReturnDateTimeScreenState extends State<SelectReturnDateTimeScreen> {
  static const Color bg = Color(0xFF0B0C0E);
  static const Color gold = Color(0xFFD6A34A);
  static const Color card = Color(0xFF111317);

  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;
  int selectedTimePage = 0;

  late final List<_DateItem> dates;
  late String selectedLocation;

  // same 2-page time list
  final List<List<String>> timePages = const [
    [
      '08:00', '09:00', '10:00', '11:00',
      '12:00', '13:00', '14:00', '15:00',
      '16:00', '17:00', '18:00', '19:00',
    ],
    [
      '20:00', '21:00', '22:00', '23:00',
      '00:00', '01:00', '02:00', '03:00',
      '04:00', '05:00', '06:00', '07:00',
    ],
  ];

  @override
  void initState() {
    super.initState();

    // dates start from start day
    final start = widget.startDateTime;
    final startDay = DateTime(start.year, start.month, start.day);
    dates = List.generate(7, (i) => _DateItem.fromDate(startDay.add(Duration(days: i))));

    selectedLocation = widget.startLocation;

    // default end = start + 4 hours
    final minEnd = widget.startDateTime.add(const Duration(hours: 4));
    // set default date index
    selectedDateIndex = minEnd.difference(startDay).inDays.clamp(0, 6);

    // set default time selection to minEnd rounded down to hour in our grid
    final hh = minEnd.hour.toString().padLeft(2, '0');
    final mm = '00';
    final timeStr = '$hh:$mm';

    // choose the page that contains timeStr; if not found, pick closest by hour
    int foundPage = 0;
    int foundIndex = 0;
    bool found = false;
    for (var p = 0; p < timePages.length; p++) {
      final idx = timePages[p].indexOf(timeStr);
      if (idx != -1) {
        foundPage = p;
        foundIndex = idx;
        found = true;
        break;
      }
    }
    if (!found) {
      // fallback: 12:00
      foundPage = 0;
      foundIndex = 4;
    }
    selectedTimePage = foundPage;
    selectedTimeIndex = foundIndex;
  }

  Future<void> _openLocationPicker() async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose drop-off location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: widget.locations.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.white.withOpacity(0.06),
                      height: 1,
                    ),
                    itemBuilder: (context, i) {
                      final loc = widget.locations[i];
                      final isSelected = loc == selectedLocation;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => Navigator.of(context).pop(loc),
                        title: Text(
                          loc,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_rounded, color: gold)
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null && mounted) {
      setState(() => selectedLocation = picked);
    }
  }

  bool _isDisabledTime(DateTime endDate, int hour, int minute) {
    final end = DateTime(endDate.year, endDate.month, endDate.day, hour, minute);
    final minEnd = widget.startDateTime.add(const Duration(hours: 4));
    return end.isBefore(minEnd);
  }

  @override
  Widget build(BuildContext context) {
    final pageTimes = timePages[selectedTimePage];
    final selectedDate = dates[selectedDateIndex].date;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Return Date & Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle(
                      icon: Icons.calendar_month_outlined,
                      title: 'Pick return date',
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final isSelected = i == selectedDateIndex;
                          return _DateCard(
                            day: dates[i].day,
                            date: dates[i].dayOfMonth,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                selectedDateIndex = i;
                                // reset time page/index to first valid on new date
                                selectedTimePage = 0;
                                selectedTimeIndex = 0;
                              });
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        const _SectionTitle(
                          icon: Icons.access_time_rounded,
                          title: 'Return time',
                        ),
                        const Spacer(),
                        _MiniIconButton(
                          icon: Icons.chevron_left_rounded,
                          onTap: selectedTimePage == 0
                              ? null
                              : () {
                                  setState(() {
                                    selectedTimePage--;
                                    selectedTimeIndex = 0;
                                  });
                                },
                        ),
                        const SizedBox(width: 8),
                        _MiniIconButton(
                          icon: Icons.chevron_right_rounded,
                          onTap: selectedTimePage == timePages.length - 1
                              ? null
                              : () {
                                  setState(() {
                                    selectedTimePage++;
                                    selectedTimeIndex = 0;
                                  });
                                },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    GridView.builder(
                      itemCount: pageTimes.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.6,
                      ),
                      itemBuilder: (context, i) {
                        final timeStr = pageTimes[i];
                        final parts = timeStr.split(':');
                        final hh = int.parse(parts[0]);
                        final mm = int.parse(parts[1]);
                        final disabled = _isDisabledTime(selectedDate, hh, mm);
                        final isSelected = i == selectedTimeIndex;

                        return Opacity(
                          opacity: disabled ? 0.35 : 1,
                          child: IgnorePointer(
                            ignoring: disabled,
                            child: _TimeChip(
                              text: timeStr,
                              isSelected: isSelected,
                              onTap: () => setState(() => selectedTimeIndex = i),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Drop-off Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),

                    InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: _openLocationPicker,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: gold, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                selectedLocation,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.expand_more_rounded, color: Colors.white70),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _PrimaryButton(
                text: 'Continue',
                onTap: () {
                  final timeStr = pageTimes[selectedTimeIndex];
                  final parts = timeStr.split(':');
                  final hh = int.parse(parts[0]);
                  final mm = int.parse(parts[1]);
                  final endDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    hh,
                    mm,
                  );
                  final minEnd = widget.startDateTime.add(const Duration(hours: 4));

                  if (endDateTime.isBefore(minEnd)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Return time must be at least 4 hours after pickup')),
                    );
                    return;
                  }

                  Navigator.of(context).pop(_ReturnSelection(
                    dropoffLocation: selectedLocation,
                    dropoffDateTime: endDateTime,
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReturnSelection {
  final String dropoffLocation;
  final DateTime dropoffDateTime;
  const _ReturnSelection({required this.dropoffLocation, required this.dropoffDateTime});
}

class _DateItem {
  final DateTime date;
  final String day;
  final String dayOfMonth;

  const _DateItem({required this.date, required this.day, required this.dayOfMonth});

  factory _DateItem.fromDate(DateTime d) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return _DateItem(
      date: d,
      day: weekdays[d.weekday - 1],
      dayOfMonth: d.day.toString().padLeft(2, '0'),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  static const Color gold = Color(0xFFD6A34A);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: gold, size: 20),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DateCard extends StatelessWidget {
  const _DateCard({
    required this.day,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final String day;
  final String date;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color gold = Color(0xFFD6A34A);
  static const Color card = Color(0xFF111317);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 76,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? gold.withOpacity(0.22) : card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? gold : Colors.white.withOpacity(0.06),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  static const Color gold = Color(0xFFD6A34A);
  static const Color card = Color(0xFF111317);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? gold.withOpacity(0.22) : card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? gold : Colors.white.withOpacity(0.06),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
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

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: Colors.white.withOpacity(disabled ? 0.03 : 0.06),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            color: Colors.white.withOpacity(disabled ? 0.25 : 0.85),
            size: 24,
          ),
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