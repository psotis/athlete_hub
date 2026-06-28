import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

class DesktopAdminMetricsSearchPanel extends StatefulWidget {
  final List<Users> users;

  const DesktopAdminMetricsSearchPanel({super.key, required this.users});

  @override
  State<DesktopAdminMetricsSearchPanel> createState() =>
      _DesktopAdminMetricsSearchPanelState();
}

class _DesktopAdminMetricsSearchPanelState
    extends State<DesktopAdminMetricsSearchPanel> {
  bool _teamLoading = false;
  String? _teamError;
  String? _selectedTeamName;
  String? _selectedOptionKey;
  List<_DesktopTeamErgometricsResult> _teamResults = [];

  List<_DesktopMetricsSearchOption> get _options {
    final athletes = widget.users
        .map((user) => _DesktopMetricsSearchOption.athlete(user))
        .toList();

    final teams = <_DesktopMetricsSearchOption>[];
    final grouped = <String, List<Users>>{};

    for (final user in widget.users) {
      final team = user.team?.trim();
      if (team == null || team.isEmpty) continue;
      grouped.putIfAbsent(team, () => []).add(user);
    }

    final sortedTeams = grouped.keys.toList()..sort();
    for (final team in sortedTeams) {
      teams.add(_DesktopMetricsSearchOption.team(team, grouped[team]!));
    }

    return [...athletes, ...teams];
  }

  Future<void> _loadTeamErgometrics(_DesktopMetricsSearchOption option) async {
    setState(() {
      _teamLoading = true;
      _teamError = null;
      _selectedTeamName = option.teamName;
      _teamResults = [];
    });

    final repository = context.read<ErgometricsRepository>();
    final results = <_DesktopTeamErgometricsResult>[];

    try {
      for (final user in option.members) {
        final data = await repository.getErgometricsPerUser(user.id);
        results.add(_DesktopTeamErgometricsResult(user: user, data: data));
      }

      if (!mounted) return;

      setState(() {
        _teamLoading = false;
        _teamResults = results;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _teamLoading = false;
        _teamError = e.toString();
      });
    }
  }

  Future<void> _onChanged(String? value) async {
    if (value == null) return;

    setState(() {
      _selectedOptionKey = value;
    });

    final option = _options.firstWhere((element) => element.key == value);

    if (option.isTeam) {
      context.read<ErgometricsCubit>().clearErgometrics();
      await _loadTeamErgometrics(option);
      return;
    }

    setState(() {
      _selectedTeamName = null;
      _teamResults = [];
      _teamError = null;
      _teamLoading = false;
    });

    context.read<ErgometricsCubit>().getAthleteErgometrics(option.athlete!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedOptionKey,
          style: const TextStyle(color: Color(0xFF0F172A)),
          decoration: const InputDecoration(
            labelText: 'Select athlete or team',
            labelStyle: TextStyle(color: Color(0xFF475569)),
            floatingLabelStyle: TextStyle(color: Color(0xFF334155)),
          ),
          items: _options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.key,
                  child: Text(
                    option.displayLabel,
                    style: const TextStyle(color: Color(0xFF0F172A)),
                  ),
                ),
              )
              .toList(),
          onChanged: _onChanged,
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    if (_selectedTeamName != null) {
      if (_teamLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_teamError != null) {
        return Center(
          child: Text(
            _teamError!,
            style: const TextStyle(color: Color(0xFF0F172A)),
          ),
        );
      }

      if (_teamResults.isEmpty) {
        return const Center(
          child: Text(
            'No ergometrics found',
            style: TextStyle(color: Color(0xFF0F172A)),
          ),
        );
      }

      return ListView.separated(
        itemCount: _teamResults.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final result = _teamResults[index];

          return DesktopSurfaceCard(
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  result.user.fullName,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  [
                    if ((result.user.team ?? '').trim().isNotEmpty)
                      result.user.team!,
                    if ((result.user.sport ?? '').trim().isNotEmpty)
                      result.user.sport!,
                  ].join(' - '),
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                children: [
                  if (result.data.ergometrics.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No ergometrics found',
                        style: TextStyle(color: Color(0xFF0F172A)),
                      ),
                    )
                  else
                    ...result.data.ergometrics.map(
                      (item) => Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: _DesktopMetricsSessionCard(item: item),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
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

        return ListView.separated(
          itemCount: ergometrics.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = ergometrics[index];
            return _DesktopMetricsSessionCard(item: item);
          },
        );
      },
    );
  }
}

class _DesktopMetricsSearchOption {
  final String key;
  final Users? athlete;
  final String? teamName;
  final List<Users> members;

  const _DesktopMetricsSearchOption._({
    required this.key,
    this.athlete,
    this.teamName,
    this.members = const [],
  });

  factory _DesktopMetricsSearchOption.athlete(Users user) {
    return _DesktopMetricsSearchOption._(
      key: 'athlete:${user.id}',
      athlete: user,
    );
  }

  factory _DesktopMetricsSearchOption.team(
    String teamName,
    List<Users> members,
  ) {
    return _DesktopMetricsSearchOption._(
      key: 'team:$teamName',
      teamName: teamName,
      members: members,
    );
  }

  bool get isTeam => teamName != null;

  String get displayLabel {
    if (isTeam) {
      return 'Team: $teamName (${members.length} athletes)';
    }

    final team = athlete?.team?.trim();
    if (team == null || team.isEmpty) return athlete?.fullName ?? '';
    return '${athlete?.fullName} - $team';
  }
}

class _DesktopTeamErgometricsResult {
  final Users user;
  final AthleteErgometricsData data;

  const _DesktopTeamErgometricsResult({required this.user, required this.data});
}

class _DesktopMetricsSessionCard extends StatelessWidget {
  final ErgometricsDetails item;

  const _DesktopMetricsSessionCard({required this.item});

  bool _hasVo2Data(Endurance? endurance) {
    return endurance?.maxSpeed != null ||
        endurance?.hrMaxVo != null ||
        endurance?.vo2Max != null;
  }

  @override
  Widget build(BuildContext context) {
    final session = item.session;
    final date = session?.measurementDate;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          title: Text(
            'Session ${date != null ? DateFormat('dd-MM-yyyy').format(date) : '-'}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          subtitle: Text(
            'Notes: ${session?.notes?.toString().trim().isNotEmpty == true ? session?.notes : '-'}',
            style: const TextStyle(color: Color(0xFF64748B)),
          ),
          children: [
            _DesktopCategoryCard(
              title: 'Somatometrics',
              values: {
                'Height (cm)': item.somatometrics?.heightCm,
                'Arm span (cm)': item.somatometrics?.armSpanCm,
                'Weight (kg)': item.somatometrics?.weightKg,
                'Body fat %': item.somatometrics?.bodyFatPercent,
                'BMI': item.somatometrics?.bmi,
                'Ape index': item.somatometrics?.apeIndex,
              },
            ),
            _DesktopCategoryCard(
              title: 'Goniometrics',
              values: {
                'Hip flexion right (deg)':
                    item.goniometrics?.hipFlexionRightDeg,
                'Hip flexion left (deg)': item.goniometrics?.hipFlexionLeftDeg,
                'Knee flexion right (deg)':
                    item.goniometrics?.kneeFlexionRightDeg,
                'Knee flexion left (deg)':
                    item.goniometrics?.kneeFlexionLeftDeg,
              },
            ),
            _DesktopCategoryCard(
              title: 'Dynamometrics',
              values: {
                'Hand grip right (N)': item.dynamometrics?.handGripRightN,
                'Hand grip left (N)': item.dynamometrics?.handGripLeftN,
                'Mid thigh pull (N)': item.dynamometrics?.midThighPullN,
              },
            ),
            _DesktopCategoryCard(
              title: 'Jumping Ability',
              values: {
                'Squat jump height (cm)': item.jumpingAbility?.squatJumpHeightCm,
                'Squat jump power (W)': item.jumpingAbility?.squatJumpPowerW,
                'CMJ height (cm)': item.jumpingAbility?.cmjHeightCm,
                'CMJ power (W)': item.jumpingAbility?.cmjPowerW,
              },
            ),
            _DesktopCategoryCard(
              title: 'Agility & Speed',
              values: {
                '5-10-5 right (sec)': item.agilitySpeed?.test5105RightSec,
                '5-10-5 left (sec)': item.agilitySpeed?.test5105LeftSec,
                'Sprint 0-10 (sec)': item.agilitySpeed?.sprint010Sec,
              },
            ),
            _DesktopCategoryCard(
              title: 'Endurance',
              values: _hasVo2Data(item.endurance)
                  ? {
                      'Max speed (km/h)': item.endurance?.maxSpeed,
                      'HR max VO': item.endurance?.hrMaxVo,
                      'VO2max (ml/kg/min)': item.endurance?.vo2Max,
                    }
                  : {
                      'Beep test level': item.endurance?.beepTestLevel,
                      'Beep test shuttles': item.endurance?.beepTestShuttles,
                      'Distance (m)': item.endurance?.beepTestDistanceM,
                      'VO2max (ml/kg/min)':
                          item.endurance?.beepTestVo2maxMlKgMin,
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopCategoryCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> values;

  const _DesktopCategoryCard({required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    final entries = values.entries.toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          ...entries.map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      e.key,
                      style: const TextStyle(color: Color(0xFF64748B)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: Text(
                      _formatValue(e.value),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatValue(dynamic value) {
    if (value == null) return '-';

    if (value is num) {
      final doubleValue = value.toDouble();
      if (doubleValue == doubleValue.roundToDouble()) {
        return doubleValue.toStringAsFixed(0);
      }
      return doubleValue.toStringAsFixed(2);
    }

    return value.toString();
  }
}
