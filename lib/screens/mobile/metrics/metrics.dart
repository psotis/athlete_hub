import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/screens/mobile/metrics/widgets.dart/category_screen.dart';

class MetricsMobile extends StatefulWidget {
  const MetricsMobile({super.key});

  @override
  State<MetricsMobile> createState() => _MetricsMobileState();
}

class _MetricsMobileState extends State<MetricsMobile> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (authState.user.isCustomer) {
        context.read<ErgometricsCubit>().getAthleteErgometrics(authState.user);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.isAdmin) {
      return AdminMobile();
    }

    return MobileGlowScaffold(
      child: BlocBuilder<ErgometricsCubit, ErgometricsState>(
        builder: (context, state) {
          if (state.status == ErgometricsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ErgometricsStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final ergometrics = state.data.ergometrics;

          if (ergometrics.isEmpty) {
            return const Center(
              child: Text(
                'No ergometrics found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final items = [
            _MetricCategoryItem(
              title: 'Somatometrics',
              subtitle: 'Body profile and structure',
              icon: Icons.accessibility_new,
              category: ErgometricsCategory.somatometrics,
            ),
            _MetricCategoryItem(
              title: 'Goniometrics',
              subtitle: 'Mobility and range',
              icon: Icons.straighten,
              category: ErgometricsCategory.goniometrics,
            ),
            _MetricCategoryItem(
              title: 'Dynamometrics',
              subtitle: 'Strength output',
              icon: Icons.fitness_center,
              category: ErgometricsCategory.dynamometrics,
            ),
            _MetricCategoryItem(
              title: 'Jumping Ability',
              subtitle: 'Power and reactivity',
              icon: Icons.arrow_upward,
              category: ErgometricsCategory.jumping,
            ),
            _MetricCategoryItem(
              title: 'Agility & Speed',
              subtitle: 'Acceleration and COD',
              icon: Icons.directions_run,
              category: ErgometricsCategory.agility,
            ),
            _MetricCategoryItem(
              title: 'Endurance',
              subtitle: 'Beep test insights',
              icon: Icons.favorite,
              category: ErgometricsCategory.endurance,
            ),
            _MetricCategoryItem(
              title: 'Movement Quality',
              subtitle: 'Overhead squat checks',
              icon: Icons.accessibility,
              category: ErgometricsCategory.overheadSquat,
            ),
          ];

          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MobilePageHeader(
                  title: 'Ergometrics',
                  subtitle:
                      'Choose a category to explore your athlete data, comparisons and session history.',
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final crossAxisCount = width >= 680
                          ? 3
                          : width >= 360
                          ? 2
                          : 1;
                      final aspectRatio = crossAxisCount == 1 ? 1.7 : 0.98;

                      return GridView.builder(
                        itemCount: items.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return InkWell(
                            borderRadius: BorderRadius.circular(24),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ErgometricsCategoryScreen(
                                    title: item.title,
                                    category: item.category,
                                  ),
                                ),
                              );
                            },
                            child: MobileGlassCard(
                              borderRadius: BorderRadius.circular(24),
                              padding: const EdgeInsets.all(18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF183E8B),
                                          Color(0xFF0D6EFD),
                                        ],
                                      ),
                                    ),
                                    child: Icon(item.icon, color: Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    item.title,
                                    style: Theme.of(context).textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.subtitle,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withAlpha(168),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MetricCategoryItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final ErgometricsCategory category;

  const _MetricCategoryItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
  });
}
