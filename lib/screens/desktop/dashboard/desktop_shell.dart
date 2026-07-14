import 'package:athlete_hub/helpers/imports.dart';

class DesktopAppShell extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;
  final String title;
  final String subtitle;
  final Widget body;
  final Widget? trailing;
  final bool scrollBody;

  const DesktopAppShell({
    super.key,
    required this.selectedIndex,
    required this.title,
    required this.subtitle,
    required this.body,
    this.onDestinationSelected,
    this.trailing,
    this.scrollBody = true,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 272,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF071A36), Color(0xFF0F2E61)],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A0F172A),
                      blurRadius: 30,
                      offset: Offset(0, 18),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withAlpha(18),
                          border: Border.all(color: Colors.white.withAlpha(24)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF173E8C),
                                    Color(0xFF0D6EFD),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(Images.logo2),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Athlete Hub',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Performance workspace',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withAlpha(170),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Navigation',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white.withAlpha(180),
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: NavigationRail(
                            backgroundColor: Colors.transparent,
                            extended: true,
                            selectedIndex: selectedIndex,
                            onDestinationSelected: onDestinationSelected,
                            minExtendedWidth: 220,
                            groupAlignment: -0.85,
                            indicatorColor: const Color(0xFF0D6EFD),
                            selectedIconTheme: const IconThemeData(
                              color: Colors.white,
                            ),
                            unselectedIconTheme: IconThemeData(
                              color: Colors.white.withAlpha(170),
                            ),
                            selectedLabelTextStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            unselectedLabelTextStyle: TextStyle(
                              color: Colors.white.withAlpha(170),
                              fontWeight: FontWeight.w500,
                            ),
                            destinations: [
                              const NavigationRailDestination(
                                icon: Icon(Icons.home_outlined),
                                selectedIcon: Icon(Icons.home_rounded),
                                label: Text('Home'),
                              ),
                              NavigationRailDestination(
                                icon: Icon(
                                  user?.isNutritionist == true
                                      ? Icons.calendar_month_outlined
                                      : Icons.fitness_center_outlined,
                                ),
                                selectedIcon: Icon(
                                  user?.isNutritionist == true
                                      ? Icons.calendar_month_rounded
                                      : Icons.fitness_center_rounded,
                                ),
                                label: Text(
                                  user?.isNutritionist == true
                                      ? 'Calendar'
                                      : 'Training',
                                ),
                              ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.analytics_outlined),
                                selectedIcon: Icon(Icons.analytics_rounded),
                                label: Text('Metrics'),
                              ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.restaurant_menu_outlined),
                                selectedIcon: Icon(
                                  Icons.restaurant_menu_rounded,
                                ),
                                label: Text('Nutrition'),
                              ),
                              const NavigationRailDestination(
                                icon: Icon(Icons.person_outline_rounded),
                                selectedIcon: Icon(Icons.person_rounded),
                                label: Text('Profile'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (user != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white.withAlpha(14),
                            border: Border.all(
                              color: Colors.white.withAlpha(22),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: TextStyle(
                                  color: Colors.white.withAlpha(170),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FBFF),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: scrollBody ? SingleChildScrollView(child: body) : body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _roleLabel(Users user) {
    if (user.isAdmin) return 'Administrator';
    if (user.isNutritionist) return 'Nutritionist';
    if (user.isTrainer) return 'Trainer';
    return 'Athlete';
  }
}

class DesktopSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;

  const DesktopSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    final darkTextTheme = baseTheme.textTheme.copyWith(
      bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
        color: const Color(0xFF0F172A),
      ),
      bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF0F172A),
      ),
      bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
        color: const Color(0xFF475569),
      ),
      titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
        color: const Color(0xFF0F172A),
      ),
      titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
        color: const Color(0xFF0F172A),
      ),
      titleSmall: baseTheme.textTheme.titleSmall?.copyWith(
        color: const Color(0xFF0F172A),
      ),
      headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
        color: const Color(0xFF0F172A),
      ),
      headlineMedium: baseTheme.textTheme.headlineMedium?.copyWith(
        color: const Color(0xFF0F172A),
      ),
    );

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Theme(
        data: baseTheme.copyWith(
          textTheme: darkTextTheme,
          iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
          listTileTheme: const ListTileThemeData(
            textColor: Color(0xFF0F172A),
            iconColor: Color(0xFF0F172A),
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: const TextStyle(color: Color(0xFF475569)),
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF0D6EFD)),
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}

class DesktopSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const DesktopSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: const Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF64748B),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class DesktopStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String note;
  final Color accent;
  final IconData icon;

  const DesktopStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.note,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DesktopSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withAlpha(30),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            note,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
