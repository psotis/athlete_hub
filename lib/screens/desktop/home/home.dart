import 'package:athlete_hub/helpers/imports.dart';

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DesktopSurfaceCard(
            padding: const EdgeInsets.all(28),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user == null
                            ? 'Welcome to Athlete Hub'
                            : 'Welcome back, ${user.firstName}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: const Color(0xFF0F172A),
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your desktop workspace is now organized like a modern website so you can move faster between planning, metrics, nutrition and profile tasks.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF475569),
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _QuickChip(
                            icon: Icons.auto_graph_rounded,
                            label: 'Metrics ready',
                          ),
                          _QuickChip(
                            icon: Icons.event_available_rounded,
                            label: 'Planning visible',
                          ),
                          _QuickChip(
                            icon: Icons.favorite_outline_rounded,
                            label: 'Health and profile linked',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE0F2FE), Color(0xFFDBEAFE)],
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Image.asset(Images.logo2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: DesktopStatCard(
                  label: 'Sessions',
                  value: '03',
                  note: 'Active training blocks in view',
                  accent: Color(0xFF0EA5E9),
                  icon: Icons.play_circle_outline_rounded,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DesktopStatCard(
                  label: 'Recovery',
                  value: '87%',
                  note: 'Current readiness snapshot',
                  accent: Color(0xFF22C55E),
                  icon: Icons.monitor_heart_outlined,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DesktopStatCard(
                  label: 'Categories',
                  value: '07',
                  note: 'Ergometric groups available',
                  accent: Color(0xFFF97316),
                  icon: Icons.grid_view_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DesktopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniLine(
                  label: 'Logged user',
                  value: user?.fullName ?? 'Unknown',
                ),
                _MiniLine(
                  label: 'Role',
                  value: user == null
                      ? '-'
                      : user.isAdmin
                      ? 'Administrator'
                      : user.isNutritionist
                      ? 'Nutritionist'
                      : user.isTrainer
                      ? 'Trainer'
                      : 'Athlete',
                ),
                _MiniLine(
                  label: 'Team',
                  value: (user?.team ?? '').trim().isEmpty ? '-' : user!.team!,
                ),
                _MiniLine(
                  label: 'Sport',
                  value: (user?.sport ?? '').trim().isEmpty ? '-' : user!.sport!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniLine extends StatelessWidget {
  final String label;
  final String value;

  const _MiniLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF0F172A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
