import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/helpers/imports.dart';

enum ErgometricsEntryCategory {
  somatometrics,
  goniometrics,
  dynamometrics,
  jumpingAbility,
  agilitySpeed,
  movementQuality,
  endurance,
}

extension ErgometricsEntryCategoryX on ErgometricsEntryCategory {
  String get label {
    switch (this) {
      case ErgometricsEntryCategory.somatometrics:
        return 'Somatometrics';
      case ErgometricsEntryCategory.goniometrics:
        return 'Goniometrics';
      case ErgometricsEntryCategory.dynamometrics:
        return 'Dynamometrics';
      case ErgometricsEntryCategory.jumpingAbility:
        return 'Jumping Ability';
      case ErgometricsEntryCategory.agilitySpeed:
        return 'Agility & Speed';
      case ErgometricsEntryCategory.movementQuality:
        return 'Movement Quality';
      case ErgometricsEntryCategory.endurance:
        return 'Endurance';
    }
  }
}

class SessionEntriesMobile extends StatefulWidget {
  final String sessionId;
  final Users athlete;
  final Set<ErgometricsEntryCategory>? selectedCategories;
  final bool showSaveButton;

  const SessionEntriesMobile({
    super.key,
    required this.sessionId,
    required this.athlete,
    this.selectedCategories,
    this.showSaveButton = true,
  });

  @override
  State<SessionEntriesMobile> createState() => SessionEntriesMobileState();
}

class SessionEntriesMobileState extends State<SessionEntriesMobile> {
  final _formKey = GlobalKey<FormState>();
  final List<Squat> movementQualityItems = [];
  int? selectedBeepLevel;
  int? selectedBeepShuttle;

  final heightCmCtrl = TextEditingController();
  final armSpanCmCtrl = TextEditingController();
  final weightKgCtrl = TextEditingController();
  final bodyFatPercentCtrl = TextEditingController();

  final hipFlexionRightCtrl = TextEditingController();
  final hipFlexionLeftCtrl = TextEditingController();
  final kneeFlexionRightCtrl = TextEditingController();
  final kneeFlexionLeftCtrl = TextEditingController();
  final hipInternalRotationRightCtrl = TextEditingController();
  final hipInternalRotationLeftCtrl = TextEditingController();
  final hipExternalRotationRightCtrl = TextEditingController();
  final hipExternalRotationLeftCtrl = TextEditingController();

  final handGripRightCtrl = TextEditingController();
  final handGripLeftCtrl = TextEditingController();
  final midThighPullCtrl = TextEditingController();
  final kneeExtensionRightCtrl = TextEditingController();
  final kneeExtensionLeftCtrl = TextEditingController();
  final kneeFlexionRightNCtrl = TextEditingController();
  final kneeFlexionLeftNCtrl = TextEditingController();
  final shoulderInternalRotationRightCtrl = TextEditingController();
  final shoulderInternalRotationLeftCtrl = TextEditingController();
  final shoulderExternalRotationRightCtrl = TextEditingController();
  final shoulderExternalRotationLeftCtrl = TextEditingController();

  final squatJumpHeightCtrl = TextEditingController();
  final squatJumpPowerCtrl = TextEditingController();
  final cmjHeightCtrl = TextEditingController();
  final cmjPowerCtrl = TextEditingController();
  final cmjFreeHandsHeightCtrl = TextEditingController();
  final cmjFreeHandsPowerCtrl = TextEditingController();
  final dropJumpHeightCtrl = TextEditingController();
  final dropJumpRsiCtrl = TextEditingController();
  final singleLegCmjRightHeightCtrl = TextEditingController();
  final singleLegCmjRightPowerCtrl = TextEditingController();
  final singleLegCmjLeftHeightCtrl = TextEditingController();
  final singleLegCmjLeftPowerCtrl = TextEditingController();

  final test5105RightCtrl = TextEditingController();
  final test5105LeftCtrl = TextEditingController();
  final sprint010Ctrl = TextEditingController();
  final sprint020Ctrl = TextEditingController();
  final sprint030Ctrl = TextEditingController();

  final movementQualityViewNameCtrl = TextEditingController();
  final movementQualityCheckpointNameCtrl = TextEditingController();
  final movementQualityCompensationCtrl = TextEditingController();
  final movementQualityNotesCtrl = TextEditingController();

  final hrMaxCtrl = TextEditingController();

  bool isSaving = false;

  Set<ErgometricsEntryCategory> get _selectedCategories =>
      widget.selectedCategories ??
      ErgometricsEntryCategory.values.toSet();

  bool _isSelected(ErgometricsEntryCategory category) {
    return _selectedCategories.contains(category);
  }

  @override
  void dispose() {
    final controllers = [
      heightCmCtrl,
      armSpanCmCtrl,
      weightKgCtrl,
      bodyFatPercentCtrl,
      hipFlexionRightCtrl,
      hipFlexionLeftCtrl,
      kneeFlexionRightCtrl,
      kneeFlexionLeftCtrl,
      hipInternalRotationRightCtrl,
      hipInternalRotationLeftCtrl,
      hipExternalRotationRightCtrl,
      hipExternalRotationLeftCtrl,
      handGripRightCtrl,
      handGripLeftCtrl,
      midThighPullCtrl,
      kneeExtensionRightCtrl,
      kneeExtensionLeftCtrl,
      kneeFlexionRightNCtrl,
      kneeFlexionLeftNCtrl,
      shoulderInternalRotationRightCtrl,
      shoulderInternalRotationLeftCtrl,
      shoulderExternalRotationRightCtrl,
      shoulderExternalRotationLeftCtrl,
      squatJumpHeightCtrl,
      squatJumpPowerCtrl,
      cmjHeightCtrl,
      cmjPowerCtrl,
      cmjFreeHandsHeightCtrl,
      cmjFreeHandsPowerCtrl,
      dropJumpHeightCtrl,
      dropJumpRsiCtrl,
      singleLegCmjRightHeightCtrl,
      singleLegCmjRightPowerCtrl,
      singleLegCmjLeftHeightCtrl,
      singleLegCmjLeftPowerCtrl,
      test5105RightCtrl,
      test5105LeftCtrl,
      sprint010Ctrl,
      sprint020Ctrl,
      sprint030Ctrl,
      movementQualityViewNameCtrl,
      movementQualityCheckpointNameCtrl,
      movementQualityCompensationCtrl,
      movementQualityNotesCtrl,
      hrMaxCtrl,
    ];

    for (final c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  double? _toDouble(TextEditingController c) {
    final text = c.text.trim();
    if (text.isEmpty) return null;
    return double.tryParse(text.replaceAll(',', '.'));
  }

  int? _toInt(TextEditingController c) {
    final text = c.text.trim();
    if (text.isEmpty) return null;
    return int.tryParse(text);
  }

  Map<String, dynamic>? buildValidatedPayload() {
    if (!_formKey.currentState!.validate()) return null;

    final beep = BeepTestTable.calculate(
      level: selectedBeepLevel,
      shuttle: selectedBeepShuttle,
      age: widget.athlete.birthDate == null
          ? null
          : DateTime.now().year - widget.athlete.birthDate!.year,
    );

    final payload = <String, dynamic>{"session_id": widget.sessionId};

    if (_isSelected(ErgometricsEntryCategory.somatometrics)) {
      payload["somatometrics"] = {
        "height_cm": _toDouble(heightCmCtrl),
        "arm_span_cm": _toDouble(armSpanCmCtrl),
        "weight_kg": _toDouble(weightKgCtrl),
        "body_fat_percent": _toDouble(bodyFatPercentCtrl),
      };
    }

    if (_isSelected(ErgometricsEntryCategory.goniometrics)) {
      payload["goniometrics"] = {
        "hip_flexion_right_deg": _toDouble(hipFlexionRightCtrl),
        "hip_flexion_left_deg": _toDouble(hipFlexionLeftCtrl),
        "knee_flexion_right_deg": _toDouble(kneeFlexionRightCtrl),
        "knee_flexion_left_deg": _toDouble(kneeFlexionLeftCtrl),
        "hip_internal_rotation_right_deg": _toDouble(
          hipInternalRotationRightCtrl,
        ),
        "hip_internal_rotation_left_deg": _toDouble(
          hipInternalRotationLeftCtrl,
        ),
        "hip_external_rotation_right_deg": _toDouble(
          hipExternalRotationRightCtrl,
        ),
        "hip_external_rotation_left_deg": _toDouble(
          hipExternalRotationLeftCtrl,
        ),
      };
    }

    if (_isSelected(ErgometricsEntryCategory.dynamometrics)) {
      payload["dynamometrics"] = {
        "hand_grip_right_n": _toDouble(handGripRightCtrl),
        "hand_grip_left_n": _toDouble(handGripLeftCtrl),
        "mid_thigh_pull_n": _toDouble(midThighPullCtrl),
        "knee_extension_right_n": _toDouble(kneeExtensionRightCtrl),
        "knee_extension_left_n": _toDouble(kneeExtensionLeftCtrl),
        "knee_flexion_right_n": _toDouble(kneeFlexionRightNCtrl),
        "knee_flexion_left_n": _toDouble(kneeFlexionLeftNCtrl),
        "shoulder_internal_rotation_right_n": _toDouble(
          shoulderInternalRotationRightCtrl,
        ),
        "shoulder_internal_rotation_left_n": _toDouble(
          shoulderInternalRotationLeftCtrl,
        ),
        "shoulder_external_rotation_right_n": _toDouble(
          shoulderExternalRotationRightCtrl,
        ),
        "shoulder_external_rotation_left_n": _toDouble(
          shoulderExternalRotationLeftCtrl,
        ),
      };
    }

    if (_isSelected(ErgometricsEntryCategory.jumpingAbility)) {
      payload["jumping_ability"] = {
        "squat_jump_height_cm": _toDouble(squatJumpHeightCtrl),
        "squat_jump_power_w": _toDouble(squatJumpPowerCtrl),
        "cmj_height_cm": _toDouble(cmjHeightCtrl),
        "cmj_power_w": _toDouble(cmjPowerCtrl),
        "cmj_free_hands_height_cm": _toDouble(cmjFreeHandsHeightCtrl),
        "cmj_free_hands_power_w": _toDouble(cmjFreeHandsPowerCtrl),
        "drop_jump_height_cm": _toDouble(dropJumpHeightCtrl),
        "drop_jump_rsi": _toDouble(dropJumpRsiCtrl),
        "single_leg_cmj_right_height_cm": _toDouble(
          singleLegCmjRightHeightCtrl,
        ),
        "single_leg_cmj_right_power_w": _toDouble(singleLegCmjRightPowerCtrl),
        "single_leg_cmj_left_height_cm": _toDouble(singleLegCmjLeftHeightCtrl),
        "single_leg_cmj_left_power_w": _toDouble(singleLegCmjLeftPowerCtrl),
      };
    }

    if (_isSelected(ErgometricsEntryCategory.agilitySpeed)) {
      payload["agility_speed"] = {
        "test_5_10_5_right_sec": _toDouble(test5105RightCtrl),
        "test_5_10_5_left_sec": _toDouble(test5105LeftCtrl),
        "sprint_0_10_sec": _toDouble(sprint010Ctrl),
        "sprint_0_20_sec": _toDouble(sprint020Ctrl),
        "sprint_0_30_sec": _toDouble(sprint030Ctrl),
      };
    }

    if (_isSelected(ErgometricsEntryCategory.movementQuality)) {
      payload["overhead_squat_assessment_items"] = movementQualityItems
          .map(
            (e) => {
              "view_name": e.viewName,
              "checkpoint_name": e.checkpointName,
              "compensation": e.compensation,
              "result": e.result,
              "notes": e.notes,
            },
          )
          .toList();
    }

    if (_isSelected(ErgometricsEntryCategory.endurance)) {
      payload["endurance"] = {
        "beep_test_level": selectedBeepLevel,
        "beep_test_shuttles": selectedBeepShuttle,
        "hr_max": _toInt(hrMaxCtrl),
        "beep_test_time_sec": beep?.totalTimeSec,
        "beep_test_distance_m": beep?.totalDistanceM,
        "beep_test_speed_kmh": beep?.speedKmh,
        "beep_test_continuous_score": beep?.continuousScore,
        "beep_test_vo2max_ml_kg_min": beep?.vo2maxMlKgMin,
      };
    }

    return payload;
  }

  Future<void> _submit() async {
    final payload = buildValidatedPayload();
    if (payload == null) return;

    setState(() => isSaving = true);

    try {
      await SessionService().bulkCreateSessionEntries(payload);

      if (!mounted) return;
      context.read<SessionCubit>().clearErgometrics();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session entries saved successfully')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          Text(
            'Session for ${widget.athlete.fullName}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          if (_isSelected(ErgometricsEntryCategory.somatometrics))
            _CategorySection(
              title: 'Somatometrics',
              children: [
                _numberField('Height (cm)', heightCmCtrl),
                _numberField('Arm span (cm)', armSpanCmCtrl),
                _numberField('Weight (kg)', weightKgCtrl),
                _numberField('Body fat %', bodyFatPercentCtrl),
              ],
            ),
          if (_isSelected(ErgometricsEntryCategory.goniometrics))
            _CategorySection(
              title: 'Goniometrics',
              children: [
                _numberField('Hip flexion right (Â°)', hipFlexionRightCtrl),
                _numberField('Hip flexion left (Â°)', hipFlexionLeftCtrl),
                _numberField('Knee flexion right (Â°)', kneeFlexionRightCtrl),
                _numberField('Knee flexion left (Â°)', kneeFlexionLeftCtrl),
                _numberField(
                  'Hip internal rotation right (Â°)',
                  hipInternalRotationRightCtrl,
                ),
                _numberField(
                  'Hip internal rotation left (Â°)',
                  hipInternalRotationLeftCtrl,
                ),
                _numberField(
                  'Hip external rotation right (Â°)',
                  hipExternalRotationRightCtrl,
                ),
                _numberField(
                  'Hip external rotation left (Â°)',
                  hipExternalRotationLeftCtrl,
                ),
              ],
            ),
          if (_isSelected(ErgometricsEntryCategory.dynamometrics))
            _CategorySection(
              title: 'Dynamometrics',
              children: [
                _numberField('Hand grip right (N)', handGripRightCtrl),
                _numberField('Hand grip left (N)', handGripLeftCtrl),
                _numberField('Mid thigh pull (N)', midThighPullCtrl),
                _numberField('Knee extension right (N)', kneeExtensionRightCtrl),
                _numberField('Knee extension left (N)', kneeExtensionLeftCtrl),
                _numberField('Knee flexion right (N)', kneeFlexionRightNCtrl),
                _numberField('Knee flexion left (N)', kneeFlexionLeftNCtrl),
                _numberField(
                  'Shoulder internal rotation right (N)',
                  shoulderInternalRotationRightCtrl,
                ),
                _numberField(
                  'Shoulder internal rotation left (N)',
                  shoulderInternalRotationLeftCtrl,
                ),
                _numberField(
                  'Shoulder external rotation right (N)',
                  shoulderExternalRotationRightCtrl,
                ),
                _numberField(
                  'Shoulder external rotation left (N)',
                  shoulderExternalRotationLeftCtrl,
                ),
              ],
            ),
          if (_isSelected(ErgometricsEntryCategory.jumpingAbility))
            _CategorySection(
              title: 'Jumping Ability',
              children: [
                _numberField('Squat jump height (cm)', squatJumpHeightCtrl),
                _numberField('Squat jump power (W)', squatJumpPowerCtrl),
                _numberField('CMJ height (cm)', cmjHeightCtrl),
                _numberField('CMJ power (W)', cmjPowerCtrl),
                _numberField(
                  'CMJ free hands height (cm)',
                  cmjFreeHandsHeightCtrl,
                ),
                _numberField(
                  'CMJ free hands power (W)',
                  cmjFreeHandsPowerCtrl,
                ),
                _numberField('Drop jump height (cm)', dropJumpHeightCtrl),
                _numberField('Drop jump RSI', dropJumpRsiCtrl),
                _numberField(
                  'Single leg CMJ right height (cm)',
                  singleLegCmjRightHeightCtrl,
                ),
                _numberField(
                  'Single leg CMJ right power (W)',
                  singleLegCmjRightPowerCtrl,
                ),
                _numberField(
                  'Single leg CMJ left height (cm)',
                  singleLegCmjLeftHeightCtrl,
                ),
                _numberField(
                  'Single leg CMJ left power (W)',
                  singleLegCmjLeftPowerCtrl,
                ),
              ],
            ),
          if (_isSelected(ErgometricsEntryCategory.agilitySpeed))
            _CategorySection(
              title: 'Agility & Speed',
              children: [
                _numberField('5-10-5 right (sec)', test5105RightCtrl),
                _numberField('5-10-5 left (sec)', test5105LeftCtrl),
                _numberField('Sprint 0-10 (sec)', sprint010Ctrl),
                _numberField('Sprint 0-20 (sec)', sprint020Ctrl),
                _numberField('Sprint 0-30 (sec)', sprint030Ctrl),
              ],
            ),
          if (_isSelected(ErgometricsEntryCategory.movementQuality))
            _CategorySection(
              title: 'Movement Quality',
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton.icon(
                    onPressed: _addMovementQualityItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add item'),
                  ),
                ),
                const SizedBox(height: 10),
                if (movementQualityItems.isEmpty)
                  const Text('No movement quality items added yet.')
                else
                  ...movementQualityItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoRow('View', item.viewName ?? '-'),
                            _infoRow('Checkpoint', item.checkpointName ?? '-'),
                            _infoRow('Compensation', item.compensation ?? '-'),
                            _infoRow(
                              'Result',
                              item.result == true ? 'Yes' : 'No',
                            ),
                            _infoRow('Notes', item.notes ?? '-'),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    movementQualityItems.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          if (_isSelected(ErgometricsEntryCategory.endurance))
            _CategorySection(
              title: 'Endurance',
              children: [
                _beepLevelDropdown(),
                const SizedBox(height: 10),
                _beepShuttleDropdown(),
                const SizedBox(height: 10),
                _beepCalculatedFields(),
                const SizedBox(height: 10),
                _numberField('HR max', hrMaxCtrl, isInteger: true),
              ],
            ),
          if (widget.showSaveButton) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSaving ? null : _submit,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save all categories'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _beepCalculatedFields() {
    final result = BeepTestTable.calculate(
      level: selectedBeepLevel,
      shuttle: selectedBeepShuttle,
    );

    return Column(
      children: [
        _readonlyField(
          'Beep test time',
          result == null ? '' : BeepTestTable.formatTime(result.totalTimeSec),
        ),
        const SizedBox(height: 10),
        _readonlyField(
          'Beep test distance (m)',
          result?.totalDistanceM.toString() ?? '',
        ),
        const SizedBox(height: 10),
        _readonlyField(
          'Beep test speed (km/h)',
          result?.speedKmh.toStringAsFixed(2) ?? '',
        ),
        const SizedBox(height: 10),
        _readonlyField(
          'Beep test continuous score',
          result?.continuousScore.toStringAsFixed(2) ?? '',
        ),
        const SizedBox(height: 10),
        _readonlyField(
          'Beep test VO2max (ml/kg/min)',
          result?.vo2maxMlKgMin?.toStringAsFixed(2) ?? '',
        ),
      ],
    );
  }

  Widget _readonlyField(String label, String value) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _beepLevelDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Beep test level',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        IotDropdown2<int>(
          buttonWidth: double.infinity,
          value: selectedBeepLevel,
          hintText: 'Select level',
          enableSearch: true,
          dropdownMaxHeight: 350,
          searchHintText: 'Search level...',
          itemAsString: (level) => 'Level $level',
          items: BeepTestTable.allLevels
              .map(
                (level) => DropdownMenuItem<int>(
                  value: level,
                  child: Text('Level $level'),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedBeepLevel = value;
              selectedBeepShuttle = null;
            });
          },
        ),
      ],
    );
  }

  Widget _beepShuttleDropdown() {
    final shuttles = BeepTestTable.shuttlesForLevel(selectedBeepLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Beep test shuttle',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        IotDropdown2<int>(
          buttonWidth: double.infinity,
          dropdownMaxHeight: 350,
          value: shuttles.contains(selectedBeepShuttle)
              ? selectedBeepShuttle
              : null,
          hintText: selectedBeepLevel == null
              ? 'Select level first'
              : 'Select shuttle',
          enableSearch: true,
          searchHintText: 'Search shuttle...',
          itemAsString: (shuttle) => 'Shuttle $shuttle',
          items: shuttles
              .map(
                (shuttle) => DropdownMenuItem<int>(
                  value: shuttle,
                  child: Text('Shuttle $shuttle'),
                ),
              )
              .toList(),
          onChanged: selectedBeepLevel == null
              ? null
              : (value) {
                  setState(() {
                    selectedBeepShuttle = value;
                  });
                },
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
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
          Expanded(flex: 6, child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _addMovementQualityItem() async {
    final item = await showModalBottomSheet<Squat>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _MovementQualityItemSheet(),
    );

    if (item != null) {
      setState(() {
        movementQualityItems.add(item);
      });
    }
  }

  Widget _numberField(
    String label,
    TextEditingController controller, {
    bool isInteger = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) return null;

          if (isInteger) {
            if (int.tryParse(text) == null) {
              return 'Enter a valid integer';
            }
          } else {
            if (double.tryParse(text.replaceAll(',', '.')) == null) {
              return 'Enter a valid number';
            }
          }
          return null;
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _CategorySection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: children,
      ),
    );
  }
}

class _MovementQualityItemSheet extends StatefulWidget {
  const _MovementQualityItemSheet();

  @override
  State<_MovementQualityItemSheet> createState() =>
      _MovementQualityItemSheetState();
}

class _MovementQualityItemSheetState extends State<_MovementQualityItemSheet> {
  final _formKey = GlobalKey<FormState>();

  final viewNameCtrl = TextEditingController();
  final checkpointNameCtrl = TextEditingController();
  final compensationCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  bool result = false;

  @override
  void dispose() {
    viewNameCtrl.dispose();
    checkpointNameCtrl.dispose();
    compensationCtrl.dispose();
    notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Movement Quality Item',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: viewNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'View (e.g. ANTERIOR / LATERAL)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: checkpointNameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Checkpoint',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Checkpoint is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: compensationCtrl,
                decoration: const InputDecoration(
                  labelText: 'Compensation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Compensation is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Result'),
                subtitle: Text(result ? 'Yes' : 'No'),
                value: result,
                onChanged: (value) {
                  setState(() {
                    result = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    Navigator.pop(
                      context,
                      Squat(
                        '',
                        '',
                        viewNameCtrl.text.trim().isEmpty
                            ? null
                            : viewNameCtrl.text.trim(),
                        checkpointNameCtrl.text.trim(),
                        compensationCtrl.text.trim(),
                        result,
                        notesCtrl.text.trim().isEmpty
                            ? null
                            : notesCtrl.text.trim(),
                        null,
                        null,
                      ),
                    );
                  },
                  child: const Text('Add item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
