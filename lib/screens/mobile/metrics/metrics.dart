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
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ErgometricsCubit, ErgometricsState>(
          builder: (context, state) {
            if (state.status == ErgometricsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ErgometricsStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }

            final ergometrics = state.data.ergometrics;

            if (ergometrics.isEmpty) {
              return const Center(child: Text('No ergometrics found'));
            }

            final items = [
              _MetricCategoryItem(
                title: 'Somatometrics',
                icon: Icons.accessibility_new,
                category: ErgometricsCategory.somatometrics,
              ),
              _MetricCategoryItem(
                title: 'Goniometrics',
                icon: Icons.straighten,
                category: ErgometricsCategory.goniometrics,
              ),
              _MetricCategoryItem(
                title: 'Dynamometrics',
                icon: Icons.fitness_center,
                category: ErgometricsCategory.dynamometrics,
              ),
              _MetricCategoryItem(
                title: 'Jumping Ability',
                icon: Icons.arrow_upward,
                category: ErgometricsCategory.jumping,
              ),
              _MetricCategoryItem(
                title: 'Agility & Speed',
                icon: Icons.directions_run,
                category: ErgometricsCategory.agility,
              ),
              _MetricCategoryItem(
                title: 'Endurance',
                icon: Icons.favorite,
                category: ErgometricsCategory.endurance,
              ),
              _MetricCategoryItem(
                title: 'Overhead Squat',
                icon: Icons.accessibility,
                category: ErgometricsCategory.overheadSquat,
              ),
            ];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ergometrics',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose a category',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.15,
                          ),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
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
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(item.icon, size: 36),
                                  const SizedBox(height: 12),
                                  Text(
                                    item.title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MetricCategoryItem {
  final String title;
  final IconData icon;
  final ErgometricsCategory category;

  const _MetricCategoryItem({
    required this.title,
    required this.icon,
    required this.category,
  });
}
