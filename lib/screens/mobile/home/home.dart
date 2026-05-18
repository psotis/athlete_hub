import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/helpers/imports.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final user = state is AuthAuthenticated ? state.user : null;

    return MobileGlowScaffold(
      child: MobilePageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobilePageHeader(
              title: 'Welcome back',
              subtitle: user == null
                  ? 'Athlete Hub'
                  : '${user.fullName}\nYour training workspace is ready.',
              trailing: const MobileTopIconButton(
                icon: Icons.notifications_none_rounded,
              ),
              bottom: Container(
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  image: const DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(Images.logo2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 330) {
                  return const Column(
                    children: [
                      _HomeStatCard(
                        title: 'Sessions',
                        value: '03',
                        accent: Color(0xFF4CC9F0),
                      ),
                      SizedBox(height: 12),
                      _HomeStatCard(
                        title: 'Recovery',
                        value: '87%',
                        accent: Color(0xFF22C55E),
                      ),
                    ],
                  );
                }

                return const Row(
                  children: [
                    Expanded(
                      child: _HomeStatCard(
                        title: 'Sessions',
                        value: '03',
                        accent: Color(0xFF4CC9F0),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _HomeStatCard(
                        title: 'Recovery',
                        value: '87%',
                        accent: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            const MobileInfoCard(
              title: 'Quick snapshot',
              subtitle:
                  'Stay consistent with training, recovery and the latest athlete metrics from one clean mobile flow.',
              icon: Icons.auto_graph_rounded,
            ),
            const SizedBox(height: 14),
            const MobileInfoCard(
              title: 'Today\'s focus',
              subtitle:
                  'Review sessions, keep an eye on recovery and move through health and metrics without losing context.',
              icon: Icons.bolt_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _HomeStatCard({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return MobileGlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withAlpha(32),
            ),
            child: Icon(Icons.circle, size: 14, color: accent),
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withAlpha(136),
            ),
          ),
        ],
      ),
    );
  }
}
