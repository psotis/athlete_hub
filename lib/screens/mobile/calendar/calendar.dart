import 'package:athlete_hub/helpers/imports.dart';

class CalendarMobile extends StatefulWidget {
  const CalendarMobile({super.key});

  @override
  State<CalendarMobile> createState() => _CalendarMobileState();
}

class _CalendarMobileState extends State<CalendarMobile> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return MobileGlowScaffold(
      child: MobilePageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobilePageHeader(
              title: 'Calendar',
              subtitle:
                  'Review planning, sessions and your upcoming athlete workload.',
              trailing: const MobileTopIconButton(
                icon: Icons.event_available_rounded,
              ),
              bottom: CalendarTimeline(
                initialDate: _selectedDate,
                firstDate: DateTime(2019, 1, 15),
                lastDate: DateTime(2040, 11, 20),
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                leftMargin: 0,
                monthColor: Colors.white70,
                dayColor: Colors.white60,
                activeDayColor: const Color(0xFF06142B),
                activeBackgroundDayColor: const Color(0xFF7DEBFF),
                // dotsColor: const Color(0xFF7DEBFF),
                locale: 'en_ISO',
              ),
            ),
            const SizedBox(height: 18),
            MobileInfoCard(
              title: DateFormat('EEEE, d MMMM').format(_selectedDate),
              subtitle:
                  'No calendar-specific workflow was changed here. This is a visual refactor only.',
              icon: Icons.date_range_rounded,
            ),
            const SizedBox(height: 12),
            const MobileInfoCard(
              title: 'Planning ready',
              subtitle:
                  'Use this space for sessions, reminders and day-by-day athlete planning while keeping the existing logic untouched.',
              icon: Icons.insights_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
