import 'package:athlete_hub/helpers/imports.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  PageController? pageController;
  int _selectedIndex = 0;

  void onpageChange(int page) {
    setState(() {
      _selectedIndex = page;
    });
  }

  void ontabTap({int page = 0}) {
    onpageChange(page);
    pageController?.animateToPage(
      _selectedIndex,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    final exerciseAccess = !context.isNutritionist;
    final screens = [
      const HomePage(),
      exerciseAccess ? const ExercisesPage() : const CalendarPage(),
      const MetricsPage(),
      const NutritionPage(),
      const SettingsPage(),
    ];
    final navItems = [
      (icon: FontAwesomeIcons.house, label: 'Home'),
      (
        icon: exerciseAccess
            ? FontAwesomeIcons.dumbbell
            : FontAwesomeIcons.calendar,
        label: exerciseAccess ? 'Training' : 'Plan',
      ),
      (icon: FontAwesomeIcons.database, label: 'Metrics'),
      (icon: FontAwesomeIcons.nutritionix, label: 'Nutrition'),
      (icon: FontAwesomeIcons.user, label: 'Profile'),
    ];
    return MobileGlowScaffold(
      useSafeArea: false,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: MobileGlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          borderRadius: BorderRadius.circular(30),
          child: Row(
            children: [
              for (var i = 0; i < navItems.length; i++)
                Expanded(
                  child: _MobileNavItem(
                    icon: navItems[i].icon,
                    label: navItems[i].label,
                    selected: _selectedIndex == i,
                    onTap: () {
                      setState(() {
                        _selectedIndex = i;
                        ontabTap(page: _selectedIndex);
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      child: PageView(
        controller: pageController,
        onPageChanged: onpageChange,
        children: screens,
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF6EE7FF);
    final inactiveColor = Colors.white.withAlpha(148);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF102A62), Color(0xFF138CFF)],
                )
              : null,
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x55148CFF),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 18,
              color: selected ? activeColor : inactiveColor,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? Colors.white : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
