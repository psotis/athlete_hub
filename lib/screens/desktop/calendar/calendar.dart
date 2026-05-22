import 'package:athlete_hub/helpers/imports.dart';

class CalendarDesktop extends StatefulWidget {
  const CalendarDesktop({super.key});

  @override
  State<CalendarDesktop> createState() => _CalendarDesktopState();
}

class _CalendarDesktopState extends State<CalendarDesktop> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DesktopSurfaceCard(
          child: CalendarTimeline(
            initialDate: _selectedDate,
            firstDate: DateTime(2019, 1, 15),
            lastDate: DateTime(2040, 11, 20),
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            leftMargin: 0,
            monthColor: const Color(0xFF0F172A),
            dayColor: const Color(0xFF64748B),
            activeDayColor: Colors.white,
            activeBackgroundDayColor: const Color(0xFF1D4ED8),
            locale: 'en_ISO',
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
                child: DesktopSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      DateFormat('EEEE, d MMMM yyyy').format(_selectedDate),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _CalendarNote(
                      icon: Icons.schedule_rounded,
                      title: 'Session planning',
                      subtitle:
                          'Use this space for upcoming sessions, testing blocks and athlete scheduling.',
                    ),
                    const SizedBox(height: 12),
                    const _CalendarNote(
                      icon: Icons.notifications_active_outlined,
                      title: 'Reminders',
                      subtitle:
                          'Health checks, nutrition updates and ergometric follow-ups can all live around the chosen date.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: DesktopSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CalendarMiniItem(label: 'Selected day', value: 'Focused'),
                    _CalendarMiniItem(label: 'Layout', value: 'Wide view'),
                    _CalendarMiniItem(label: 'Visual mode', value: 'Desktop web'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CalendarNote extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CalendarNote({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFDBEAFE),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF1D4ED8)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CalendarMiniItem extends StatelessWidget {
  final String label;
  final String value;

  const _CalendarMiniItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
