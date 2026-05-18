// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:athlete_hub/blocs/ergometrics/ergometrics_state.dart';
import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

class GetCustomerMobile extends StatefulWidget {
  final List<Users> users;
  const GetCustomerMobile({super.key, required this.users});

  @override
  State<GetCustomerMobile> createState() => _GetCustomerMobileState();
}

class _GetCustomerMobileState extends State<GetCustomerMobile> {
  bool _teamLoading = false;
  String? _teamError;
  String? _selectedTeamName;
  List<_TeamErgometricsResult> _teamResults = [];

  List<_MetricsSearchOption> get _options {
    final athletes = widget.users
        .map((user) => _MetricsSearchOption.athlete(user))
        .toList();

    final teams = <_MetricsSearchOption>[];
    final grouped = <String, List<Users>>{};

    for (final user in widget.users) {
      final team = user.team?.trim();
      if (team == null || team.isEmpty) continue;
      grouped.putIfAbsent(team, () => []).add(user);
    }

    final sortedTeams = grouped.keys.toList()..sort();
    for (final team in sortedTeams) {
      teams.add(_MetricsSearchOption.team(team, grouped[team]!));
    }

    return [...athletes, ...teams];
  }

  Future<void> _loadTeamErgometrics(_MetricsSearchOption option) async {
    setState(() {
      _teamLoading = true;
      _teamError = null;
      _selectedTeamName = option.teamName;
      _teamResults = [];
    });

    final repository = context.read<ErgometricsRepository>();
    final results = <_TeamErgometricsResult>[];

    try {
      for (final user in option.members) {
        final data = await repository.getErgometricsPerUser(user.id);
        results.add(_TeamErgometricsResult(user: user, data: data));
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
      child: Column(
        children: [
          const MobileInfoCard(
            title: 'Search athlete or team',
            subtitle:
                'Pick a single athlete or load a team to inspect everyone with their metrics underneath.',
            icon: Icons.search_rounded,
          ),
          const SizedBox(height: 12),
          BlocBuilder<ErgometricsCubit, ErgometricsState>(
            builder: (context, state) {
              final selectedId =
                  widget.users.any((e) => e.id == state.selectedUser?.id)
                  ? state.selectedUser?.id
                  : null;

              final currentValue = _selectedTeamName != null
                  ? 'team:$_selectedTeamName'
                  : selectedId == null
                  ? null
                  : 'athlete:$selectedId';

              return IotDropdown2<String>(
                buttonWidth: MediaQuery.of(context).size.width * .9,
                value: currentValue,
                hintText: 'Select athlete or team',
                enableSearch: true,
                searchHintText: 'Search athlete or team...',
                itemAsString: (key) {
                  try {
                    return _options
                        .firstWhere((option) => option.key == key)
                        .displayLabel;
                  } catch (_) {
                    return '';
                  }
                },
                items: _options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.key,
                    child: Text(
                      option.displayLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: _onChanged,
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_selectedTeamName != null) {
      if (_teamLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_teamError != null) {
        return Center(
          child: Text(_teamError!, style: const TextStyle(color: Colors.white)),
        );
      }

      if (_teamResults.isEmpty) {
        return const Center(
          child: Text(
            'No ergometrics found',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return ListView.separated(
        itemCount: _teamResults.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final result = _teamResults[index];

          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0B1730),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(20)),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Text(
                  result.user.fullName,
                  style: const TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                  [
                    if ((result.user.team ?? '').trim().isNotEmpty)
                      result.user.team!,
                    if ((result.user.sport ?? '').trim().isNotEmpty)
                      result.user.sport!,
                  ].join(' - '),
                  style: TextStyle(color: Colors.black.withAlpha(173)),
                ),
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                children: [
                  if (result.data.ergometrics.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No ergometrics found',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    ...result.data.ergometrics.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _SessionCard(item: item),
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

        return ListView.separated(
          itemCount: ergometrics.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = ergometrics[index];
            return _SessionCard(item: item);
          },
        );
      },
    );
  }
}

class _MetricsSearchOption {
  final String key;
  final Users? athlete;
  final String? teamName;
  final List<Users> members;

  const _MetricsSearchOption._({
    required this.key,
    this.athlete,
    this.teamName,
    this.members = const [],
  });

  factory _MetricsSearchOption.athlete(Users user) {
    return _MetricsSearchOption._(key: 'athlete:${user.id}', athlete: user);
  }

  factory _MetricsSearchOption.team(String teamName, List<Users> members) {
    return _MetricsSearchOption._(
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

class _TeamErgometricsResult {
  final Users user;
  final AthleteErgometricsData data;

  const _TeamErgometricsResult({required this.user, required this.data});
}

class _SessionCard extends StatelessWidget {
  final ErgometricsDetails item;

  const _SessionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final session = item.session;
    final soma = item.somatometrics;
    final goni = item.goniometrics;
    final dynamo = item.dynamometrics;
    final jump = item.jumpingAbility;
    final agility = item.agilitySpeed;
    final endurance = item.endurance;
    final movementQualityItems = item.overheadSquatAssessmentItems;
    final date = session?.measurementDate;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0E1A34),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withAlpha(20)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          iconColor: Colors.black,
          collapsedIconColor: Colors.white70,
          title: Text(
            'Session ${date != null ? DateFormat('dd-MM-yyyy').format(date) : '-'}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            'Notes: ${session?.notes?.toString().trim().isNotEmpty == true ? session?.notes : '-'}',
            style: TextStyle(color: Colors.black.withAlpha(173)),
          ),
          children: [
            _CategoryCard(
              title: 'Somatometrics',
              values: {
                'Height (cm)': soma?.heightCm,
                'Arm span (cm)': soma?.armSpanCm,
                'Weight (kg)': soma?.weightKg,
                'Body fat %': soma?.bodyFatPercent,
                'BMI': soma?.bmi,
                'Ape index': soma?.apeIndex,
              },
            ),
            _CategoryCard(
              title: 'Goniometrics',
              values: {
                'Hip flexion right (deg)': goni?.hipFlexionRightDeg,
                'Hip flexion left (deg)': goni?.hipFlexionLeftDeg,
                'Knee flexion right (deg)': goni?.kneeFlexionRightDeg,
                'Knee flexion left (deg)': goni?.kneeFlexionLeftDeg,
                'Hip internal rotation right (deg)':
                    goni?.hipInternalRotationRightDeg,
                'Hip internal rotation left (deg)':
                    goni?.hipInternalRotationLeftDeg,
                'Hip external rotation right (deg)':
                    goni?.hipExternalRotationRightDeg,
                'Hip external rotation left (deg)':
                    goni?.hipExternalRotationLeftDeg,
                'Leg R/L ratio': goni?.legRlRatio,
                'Knee R/L ratio': goni?.kneeRlRatio,
                'Hip total': goni?.hipTotal,
              },
            ),
            _CategoryCard(
              title: 'Dynamometrics',
              values: {
                'Hand grip right (N)': dynamo?.handGripRightN,
                'Hand grip left (N)': dynamo?.handGripLeftN,
                'Mid thigh pull (N)': dynamo?.midThighPullN,
                'Knee extension right (N)': dynamo?.kneeExtensionRightN,
                'Knee extension left (N)': dynamo?.kneeExtensionLeftN,
                'Knee flexion right (N)': dynamo?.kneeFlexionRightN,
                'Knee flexion left (N)': dynamo?.kneeFlexionLeftN,
                'Shoulder internal right (N)':
                    dynamo?.shoulderInternalRotationRightN,
                'Shoulder internal left (N)':
                    dynamo?.shoulderInternalRotationLeftN,
                'Shoulder external right (N)':
                    dynamo?.shoulderExternalRotationRightN,
                'Shoulder external left (N)':
                    dynamo?.shoulderExternalRotationLeftN,
                'Hand R/L ratio': dynamo?.handRlRatio,
                'Leg R/L ratio': dynamo?.legRlRatio,
                'Knee R/L ratio': dynamo?.kneeRlRatio,
                'Shoulder int ratio': dynamo?.shoulderIntRatio,
                'Shoulder ext ratio': dynamo?.shoulderExtRatio,
              },
            ),
            _CategoryCard(
              title: 'Jumping Ability',
              values: {
                'Squat jump height (cm)': jump?.squatJumpHeightCm,
                'Squat jump power (W)': jump?.squatJumpPowerW,
                'CMJ height (cm)': jump?.cmjHeightCm,
                'CMJ power (W)': jump?.cmjPowerW,
                'CMJ free hands height (cm)': jump?.cmjFreeHandsHeightCm,
                'CMJ free hands power (W)': jump?.cmjFreeHandsPowerW,
                'Drop jump height (cm)': jump?.dropJumpHeightCm,
                'Drop jump RSI': jump?.dropJumpRsi,
                'Single leg CMJ right height (cm)':
                    jump?.singleLegCmjRightHeightCm,
                'Single leg CMJ right power (W)': jump?.singleLegCmjRightPowerW,
                'Single leg CMJ left height (cm)':
                    jump?.singleLegCmjLeftHeightCm,
                'Single leg CMJ left power (W)': jump?.singleLegCmjLeftPowerW,
                'Elastic util ratio': jump?.elasticUtilRatio,
                'Arm swing': jump?.armSwing,
                'Biliteral deficit': jump?.biliteralDeficit,
                'Single leg jump': jump?.singleLegJump,
              },
            ),
            _CategoryCard(
              title: 'Agility & Speed',
              values: {
                '5-10-5 right (sec)': agility?.test5105RightSec,
                '5-10-5 left (sec)': agility?.test5105LeftSec,
                'Sprint 0-10 (sec)': agility?.sprint010Sec,
                'Sprint 0-20 (sec)': agility?.sprint020Sec,
                'Sprint 0-30 (sec)': agility?.sprint030Sec,
              },
            ),
            _CategoryCard(
              title: 'Endurance',
              values: {
                'Beep test level': endurance?.beepTestLevel,
                'Beep test shuttles': endurance?.beepTestShuttles,
                'Beep test score': endurance?.beepTestContinuousScore,
                'Beep test time': _formatDurationFromSeconds(
                  endurance?.beepTestTimeSec,
                ),
                'Beep test distance (m)': endurance?.beepTestDistanceM,
                'Beep test speed (km/h)': endurance?.beepTestSpeedKmh,
                'Beep test VO2max (ml/kg/min)':
                    endurance?.beepTestVo2maxMlKgMin,
                'HR max': endurance?.hrMax,
              },
            ),
            if (movementQualityItems.isNotEmpty)
              _MovementQualitySection(items: movementQualityItems),
          ],
        ),
      ),
    );
  }

  String _formatDurationFromSeconds(double? seconds) {
    if (seconds == null) return '-';

    final totalSeconds = seconds.round();
    final minutes = totalSeconds ~/ 60;
    final remainingSeconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic> values;

  const _CategoryCard({required this.title, required this.values});

  @override
  Widget build(BuildContext context) {
    final entries = values.entries.toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF12203D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
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
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(184),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: Text(
                      _formatValue(e.value),
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Colors.white),
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

class _MovementQualitySection extends StatelessWidget {
  final List<Squat> items;

  const _MovementQualitySection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF12203D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withAlpha(26)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Movement Quality',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF172747),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withAlpha(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _line('View', item.viewName),
                  _line('Checkpoint', item.checkpointName),
                  _line('Compensation', item.compensation),
                  _line('Result', item.result == true ? 'Yes' : 'No'),
                  _line('Notes', item.notes),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
