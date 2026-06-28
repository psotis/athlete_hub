import 'package:athlete_hub/helpers/imports.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return const SplashPage();

    return const _LandingDesktop();
  }
}

class _LandingDesktop extends StatelessWidget {
  const _LandingDesktop();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final heroHeight = max(620.0, constraints.maxHeight * 0.88);

        return Scaffold(
          backgroundColor: const Color(0xFFF8FBFF),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: heroHeight,
                  child: _LandingHero(
                    horizontalPadding: 72,
                    topPadding: 28,
                    bottomPadding: 56,
                    headlineStyle: Theme.of(context).textTheme.displayMedium,
                    bodyMaxWidth: 720,
                    logoSize: 430,
                  ),
                ),
                const _LandingFeatureBand(horizontalPadding: 72),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LandingHero extends StatelessWidget {
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;
  final TextStyle? headlineStyle;
  final double bodyMaxWidth;
  final double logoSize;
  final bool compact;

  const _LandingHero({
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.headlineStyle,
    required this.bodyMaxWidth,
    required this.logoSize,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.isLoggedIn;

    return Container(
      width: double.infinity,
      color: const Color(0xFF071A36),
      child: Stack(
        children: [
          Positioned(
            right: compact ? -84 : -72,
            bottom: compact ? -58 : -94,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                Images.logo2,
                width: logoSize,
                height: logoSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LandingTopBar(compact: compact),
                  const Spacer(),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: bodyMaxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Athlete Hub',
                          style: headlineStyle?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            height: 1.08,
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'A focused performance workspace for teams, coaches, nutritionists and athletes.',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Colors.white.withAlpha(224),
                                height: 1.45,
                                letterSpacing: 0,
                              ),
                        ),
                        const SizedBox(height: 30),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () => _openPrimaryRoute(context),
                              icon: Icon(
                                loggedIn
                                    ? Icons.dashboard_rounded
                                    : Icons.login_rounded,
                              ),
                              label: Text(
                                loggedIn ? 'Open dashboard' : 'Log in',
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => context.go(Routes.signup),
                              icon: const Icon(Icons.person_add_alt_1),
                              label: const Text('Create account'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withAlpha(150),
                                ),
                                backgroundColor: Colors.white.withAlpha(12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _LandingHighlights(compact: compact),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LandingTopBar extends StatelessWidget {
  final bool compact;

  const _LandingTopBar({required this.compact});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.isLoggedIn;

    return Row(
      children: [
        Container(
          width: compact ? 44 : 52,
          height: compact ? 44 : 52,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(Images.logo2),
        ),
        const SizedBox(width: 12),
        Text(
          'Athlete Hub',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        const Spacer(),
        if (!compact)
          TextButton(
            onPressed: () => _openPrimaryRoute(context),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: Text(loggedIn ? 'Dashboard' : 'Login'),
          ),
      ],
    );
  }
}

class _LandingHighlights extends StatelessWidget {
  final bool compact;

  const _LandingHighlights({required this.compact});

  @override
  Widget build(BuildContext context) {
    final children = const [
      _LandingHighlight(icon: Icons.analytics_rounded, label: 'Metrics'),
      _LandingHighlight(icon: Icons.monitor_heart_rounded, label: 'Health'),
      _LandingHighlight(icon: Icons.restaurant_menu_rounded, label: 'Nutrition'),
    ];

    if (compact) {
      return Wrap(spacing: 8, runSpacing: 8, children: children);
    }

    return Row(children: children);
  }
}

class _LandingHighlight extends StatelessWidget {
  final IconData icon;
  final String label;

  const _LandingHighlight({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withAlpha(30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF38BDF8)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _LandingFeatureBand extends StatelessWidget {
  final double horizontalPadding;
  final bool compact;

  const _LandingFeatureBand({
    required this.horizontalPadding,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: compact ? 34 : 54,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: compact
              ? const Column(
                  children: [
                    _LandingFeature(
                      icon: Icons.query_stats_rounded,
                      title: 'Performance metrics',
                      text:
                          'Track ergometric results and training progress in one organized workspace.',
                    ),
                    _LandingFeature(
                      icon: Icons.health_and_safety_rounded,
                      title: 'Athlete health',
                      text:
                          'Keep health history, profile details and team context connected to daily work.',
                    ),
                    _LandingFeature(
                      icon: Icons.groups_rounded,
                      title: 'Team workflow',
                      text:
                          'Support coaches, nutritionists, trainers and athletes with role-based access.',
                    ),
                  ],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _LandingFeature(
                        icon: Icons.query_stats_rounded,
                        title: 'Performance metrics',
                        text:
                            'Track ergometric results and training progress in one organized workspace.',
                      ),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: _LandingFeature(
                        icon: Icons.health_and_safety_rounded,
                        title: 'Athlete health',
                        text:
                            'Keep health history, profile details and team context connected to daily work.',
                      ),
                    ),
                    SizedBox(width: 18),
                    Expanded(
                      child: _LandingFeature(
                        icon: Icons.groups_rounded,
                        title: 'Team workflow',
                        text:
                            'Support coaches, nutritionists, trainers and athletes with role-based access.',
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _LandingFeature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _LandingFeature({
    required this.icon,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0D6EFD), size: 30),
          const SizedBox(height: 18),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF475569),
              height: 1.45,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

void _openPrimaryRoute(BuildContext context) {
  final route = context.currentUserRead == null
      ? Routes.login
      : Routes.dashboard;
  context.go(route);
}
