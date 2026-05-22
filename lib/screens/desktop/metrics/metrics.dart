import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/screens/desktop/metrics/admin_search_panel.dart';
import 'package:athlete_hub/screens/desktop/metrics/admin_start_panel.dart';
import 'package:athlete_hub/screens/desktop/metrics/category_detail.dart';

class MetricsDesktop extends StatefulWidget {
  const MetricsDesktop({super.key});

  @override
  State<MetricsDesktop> createState() => _MetricsDesktopState();
}

class _MetricsDesktopState extends State<MetricsDesktop> {
  List<Users> _users = [];
  bool _isLoadingUsers = false;
  String? _usersError;
  DesktopErgometricsCategory? _selectedCategory;
  String? _selectedCategoryTitle;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) return;

    if (authState.user.isCustomer) {
      context.read<ErgometricsCubit>().getAthleteErgometrics(authState.user);
      return;
    }

    if (authState.user.isAdmin) {
      setState(() {
        _isLoadingUsers = true;
        _usersError = null;
      });

      try {
        final response = await UserService().getCustomers();
        if (!mounted) return;

        setState(() {
          _users = response.data ?? [];
          _isLoadingUsers = false;
        });
      } catch (e) {
        if (!mounted) return;

        setState(() {
          _isLoadingUsers = false;
          _usersError = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (context.isAdmin) {
      return _AdminMetricsDesktop(
        users: _users,
        isLoadingUsers: _isLoadingUsers,
        usersError: _usersError,
      );
    }

    return BlocBuilder<ErgometricsCubit, ErgometricsState>(
      builder: (context, state) {
        if (state.status == ErgometricsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == ErgometricsStatus.failure) {
          return Center(
            child: Text(
              state.errorMessage ?? 'Something went wrong',
              style: const TextStyle(color: Color(0xFF0F172A)),
            ),
          );
        }

        final ergometrics = state.data.ergometrics;
        if (ergometrics.isEmpty) {
          return const Center(
            child: Text(
              'No ergometrics found',
              style: TextStyle(color: Color(0xFF0F172A)),
            ),
          );
        }

        final items = [
          _MetricCategoryItem(
            title: 'Somatometrics',
            subtitle: 'Body profile and structure',
            icon: Icons.accessibility_new,
            category: DesktopErgometricsCategory.somatometrics,
          ),
          _MetricCategoryItem(
            title: 'Goniometrics',
            subtitle: 'Mobility and range',
            icon: Icons.straighten,
            category: DesktopErgometricsCategory.goniometrics,
          ),
          _MetricCategoryItem(
            title: 'Dynamometrics',
            subtitle: 'Strength output',
            icon: Icons.fitness_center,
            category: DesktopErgometricsCategory.dynamometrics,
          ),
          _MetricCategoryItem(
            title: 'Jumping Ability',
            subtitle: 'Power and reactivity',
            icon: Icons.arrow_upward,
            category: DesktopErgometricsCategory.jumping,
          ),
          _MetricCategoryItem(
            title: 'Agility & Speed',
            subtitle: 'Acceleration and COD',
            icon: Icons.directions_run,
            category: DesktopErgometricsCategory.agility,
          ),
          _MetricCategoryItem(
            title: 'Endurance',
            subtitle: 'Beep test insights',
            icon: Icons.favorite,
            category: DesktopErgometricsCategory.endurance,
          ),
          _MetricCategoryItem(
            title: 'Movement Quality',
            subtitle: 'Overhead squat checks',
            icon: Icons.accessibility,
            category: DesktopErgometricsCategory.overheadSquat,
          ),
        ];

        if (_selectedCategory != null && _selectedCategoryTitle != null) {
          return DesktopErgometricsCategoryDetail(
            title: _selectedCategoryTitle!,
            category: _selectedCategory!,
            onBack: () {
              setState(() {
                _selectedCategory = null;
                _selectedCategoryTitle = null;
              });
            },
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = width >= 1500
                      ? 4
                      : width >= 1000
                      ? 3
                      : 2;

                  return GridView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: crossAxisCount >= 3 ? 1.18 : 1.28,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          setState(() {
                            _selectedCategory = item.category;
                            _selectedCategoryTitle = item.title;
                          });
                        },
                        child: DesktopSurfaceCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF173E8C),
                                      Color(0xFF0D6EFD),
                                    ],
                                  ),
                                ),
                                child: Icon(item.icon, color: Colors.white),
                              ),
                              const Spacer(),
                              Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: const Color(0xFF0F172A),
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item.subtitle,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: const Color(0xFF64748B)),
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
        );
      },
    );
  }
}

class _AdminMetricsDesktop extends StatelessWidget {
  final List<Users> users;
  final bool isLoadingUsers;
  final String? usersError;

  const _AdminMetricsDesktop({
    required this.users,
    required this.isLoadingUsers,
    required this.usersError,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingUsers) {
      return const Center(child: CircularProgressIndicator());
    }

    if (usersError != null) {
      return Center(
        child: Text(
          usersError!,
          style: const TextStyle(color: Color(0xFF0F172A)),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            padding: const EdgeInsets.all(8),
            child: const TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                gradient: LinearGradient(
                  colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF475569),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  icon: Icon(Icons.sports_gymnastics, size: 24),
                  text: 'Start',
                ),
                Tab(icon: Icon(Icons.person_search, size: 24), text: 'Search'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: TabBarView(
              children: [
                DesktopSurfaceCard(
                  padding: const EdgeInsets.all(16),
                  child: DesktopAdminMetricsStartPanel(users: users),
                ),
                DesktopSurfaceCard(
                  padding: const EdgeInsets.all(16),
                  child: DesktopAdminMetricsSearchPanel(users: users),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCategoryItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final DesktopErgometricsCategory category;

  const _MetricCategoryItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
  });
}
