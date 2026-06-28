import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/helpers/imports.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  String? _loadedUserId;
  String? _loadingUserId;
  bool _isLoadingSummary = false;
  List<ErgometricsDetails> _ergometrics = const [];

  void _queueSummaryLoad(Users? user) {
    if (user == null || user.id.isEmpty) return;
    if (_loadedUserId == user.id || _loadingUserId == user.id) return;

    _loadingUserId = user.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadSummary(user);
    });
  }

  Future<void> _loadSummary(Users user) async {
    setState(() {
      _isLoadingSummary = true;
    });

    try {
      final data = await context
          .read<ErgometricsRepository>()
          .getErgometricsPerUser(user.id);

      if (!mounted) return;
      setState(() {
        _ergometrics = data.ergometrics;
        _loadedUserId = user.id;
        _loadingUserId = null;
        _isLoadingSummary = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _ergometrics = const [];
        _loadedUserId = user.id;
        _loadingUserId = null;
        _isLoadingSummary = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final user = state is AuthAuthenticated ? state.user : null;
    _queueSummaryLoad(user);

    final latestHeight = _latestSomatometricsValue(
      (somatometrics) => somatometrics.heightCm,
    );
    final latestWeight = _latestSomatometricsValue(
      (somatometrics) => somatometrics.weightKg,
    );
    final sessionCount = _ergometrics.length;

    return MobileGlowScaffold(
      child: MobilePageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobileGlassCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(235),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 14,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Image.asset(Images.logo2),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user == null ? 'Athlete Hub' : user.fullName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _profileSubtitle(user),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.white.withAlpha(170),
                                    height: 1.3,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (user != null) ...[
                    const SizedBox(height: 18),
                    _HomeSummaryRow(
                      isLoading: _isLoadingSummary,
                      height: _formatMeasurement(latestHeight, 'cm'),
                      weight: _formatMeasurement(latestWeight, 'kg'),
                      sessions: _isLoadingSummary
                          ? '-'
                          : sessionCount.toString(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double? _latestSomatometricsValue(double? Function(Somatometrics) selector) {
    final items = [..._ergometrics];
    items.sort((a, b) {
      final aDate = a.session?.measurementDate ?? a.somatometrics?.createdAt;
      final bDate = b.session?.measurementDate ?? b.somatometrics?.createdAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });

    for (final item in items) {
      final somatometrics = item.somatometrics;
      if (somatometrics == null) continue;
      final value = selector(somatometrics);
      if (value != null) return value;
    }

    return null;
  }

  String _formatMeasurement(double? value, String unit) {
    if (_isLoadingSummary) return '-';
    if (value == null) return '-';

    final formatted = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);

    return '$formatted $unit';
  }

  String _profileSubtitle(Users? user) {
    if (user == null) return 'Performance workspace';

    final details = [
      if ((user.sport ?? '').trim().isNotEmpty) user.sport!.trim(),
      if ((user.team ?? '').trim().isNotEmpty) user.team!.trim(),
    ];

    return details.isEmpty ? 'Athlete profile' : details.join(' - ');
  }
}

class _HomeSummaryRow extends StatelessWidget {
  final bool isLoading;
  final String height;
  final String weight;
  final String sessions;

  const _HomeSummaryRow({
    required this.isLoading,
    required this.height,
    required this.weight,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _HomeSummaryItem(
            icon: Icons.height_rounded,
            label: 'Height',
            value: height,
            isLoading: isLoading,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _HomeSummaryItem(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: weight,
            isLoading: isLoading,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _HomeSummaryItem(
            icon: Icons.timeline_rounded,
            label: 'Sessions',
            value: sessions,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}

class _HomeSummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLoading;

  const _HomeSummaryItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(22),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha(34)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF7DEBFF)),
          const SizedBox(height: 7),
          Text(
            isLoading ? '-' : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(136),
            ),
          ),
        ],
      ),
    );
  }
}
