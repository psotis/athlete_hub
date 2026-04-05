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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          BlocBuilder<ErgometricsCubit, ErgometricsState>(
            builder: (context, state) {
              final selectedId =
                  widget.users.any((e) => e.id == state.selectedUser?.id)
                  ? state.selectedUser?.id
                  : null;

              if (state.status == ErgometricsStatus.failure) {
                return Text(state.errorMessage!);
              }

              return IotDropdown2<String>(
                buttonWidth: MediaQuery.of(context).size.width * .9,
                value: selectedId,
                hintText: 'Select athlete',
                enableSearch: true,
                searchHintText: 'Search athlete...',
                itemAsString: (id) {
                  try {
                    return widget.users.firstWhere((e) => e.id == id).fullName;
                  } catch (_) {
                    return '';
                  }
                },
                items: widget.users.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.id,
                    child: Text(e.fullName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final selectedUser = widget.users.firstWhere(
                    (e) => e.id == value,
                  );
                  context.read<ErgometricsCubit>().getAthleteErgometrics(
                    selectedUser,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 12),
          Expanded(
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

                return ListView.separated(
                  itemCount: ergometrics.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = ergometrics[index];
                    return _SessionCard(item: item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final dynamic item;

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
    final overheadItems = item.overheadSquatAssessmentItems ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(
          'Session ${session.measurementDate ?? '-'}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Notes: ${session.notes?.toString().trim().isNotEmpty == true ? session.notes : '-'}',
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
              'Hip flexion right (°)': goni?.hipFlexionRightDeg,
              'Hip flexion left (°)': goni?.hipFlexionLeftDeg,
              'Knee flexion right (°)': goni?.kneeFlexionRightDeg,
              'Knee flexion left (°)': goni?.kneeFlexionLeftDeg,
              'Hip internal rotation right (°)':
                  goni?.hipInternalRotationRightDeg,
              'Hip internal rotation left (°)':
                  goni?.hipInternalRotationLeftDeg,
              'Hip external rotation right (°)':
                  goni?.hipExternalRotationRightDeg,
              'Hip external rotation left (°)':
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
              'Single leg CMJ left height (cm)': jump?.singleLegCmjLeftHeightCm,
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
              'HR max': endurance?.hrMax,
            },
          ),
          if (overheadItems.isNotEmpty) _OverheadSection(items: overheadItems),
        ],
      ),
    );
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
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: Text(
                      _formatValue(e.value),
                      textAlign: TextAlign.end,
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
    if (value is double) {
      if (value == value.roundToDouble()) {
        return value.toStringAsFixed(0);
      }
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }
}

class _OverheadSection extends StatelessWidget {
  final List<dynamic> items;

  const _OverheadSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overhead Squat Assessment',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200),
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
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(flex: 6, child: Text(value?.toString() ?? '-')),
        ],
      ),
    );
  }
}
