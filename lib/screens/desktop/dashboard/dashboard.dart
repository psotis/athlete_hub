import 'package:athlete_hub/helpers/imports.dart';

class DashboardDesktop extends StatefulWidget {
  const DashboardDesktop({super.key});

  @override
  State<DashboardDesktop> createState() => _DashboardDesktopState();
}

class _DashboardDesktopState extends State<DashboardDesktop> {
  int _selectedIndex = 0;

  List<_DesktopDashboardTab> _tabs(BuildContext context) => [
    _DesktopDashboardTab(
      title: 'Home',
      subtitle: '',
      builder: () => const HomeDesktop(),
    ),
    _DesktopDashboardTab(
      title: context.isNutritionist ? 'Calendar' : 'Training',
      subtitle: '',
      builder: () => context.isNutritionist
          ? const CalendarDesktop()
          : const ExercisesDesktop(),
    ),
    _DesktopDashboardTab(
      title: 'Metrics',
      subtitle: '',
      builder: () => const MetricsDesktop(),
    ),
    _DesktopDashboardTab(
      title: 'Nutrition',
      subtitle: '',
      builder: () => const NutritionDesktop(),
    ),
    _DesktopDashboardTab(
      title: 'Profile',
      subtitle: '',
      builder: () => const SettingsDesktop(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tabs = _tabs(context);
    final tab = tabs[_selectedIndex];

    return DesktopAppShell(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      title: tab.title,
      subtitle: tab.subtitle,
      body: KeyedSubtree(
        key: ValueKey(_selectedIndex),
        child: tab.builder(),
      ),
      scrollBody: false,
    );
  }
}

class _DesktopDashboardTab {
  final String title;
  final String subtitle;
  final Widget Function() builder;

  _DesktopDashboardTab({
    required this.title,
    required this.subtitle,
    required this.builder,
  });
}
