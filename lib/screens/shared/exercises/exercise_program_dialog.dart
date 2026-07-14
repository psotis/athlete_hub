import 'package:athlete_hub/helpers/imports.dart';

Future<ExerciseProgram?> showExerciseProgramEditor(
  BuildContext context, {
  required ExerciseRepository repository,
  required List<Users> athletes,
  required List<Exercise> exercises,
  ExerciseProgram? program,
  String? initialAthleteId,
}) =>
    showDialog<ExerciseProgram>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ExerciseProgramEditor(
        repository: repository,
        athletes: athletes,
        exercises: exercises,
        program: program,
        initialAthleteId: initialAthleteId,
      ),
    );

class _ExerciseProgramEditor extends StatefulWidget {
  final ExerciseRepository repository;
  final List<Users> athletes;
  final List<Exercise> exercises;
  final ExerciseProgram? program;
  final String? initialAthleteId;

  const _ExerciseProgramEditor({
    required this.repository,
    required this.athletes,
    required this.exercises,
    this.program,
    this.initialAthleteId,
  });

  @override
  State<_ExerciseProgramEditor> createState() => _ExerciseProgramEditorState();
}

class _ExerciseProgramEditorState extends State<_ExerciseProgramEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late DateTime _date;
  late String? _athleteId;
  String? _selectedTeamName;
  late String _status;
  late List<ExerciseProgramItem> _items;
  String _search = '';
  String? _groupId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final program = widget.program;
    _title = TextEditingController(text: program?.title ?? 'Training program');
    _notes = TextEditingController(text: program?.notes ?? '');
    _date = program?.scheduledDate ?? DateTime.now();
    _athleteId = program?.athleteId ?? widget.initialAthleteId;
    _status = program?.status ?? 'active';
    _items = [...?program?.items];
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  List<Exercise> get _filteredExercises => widget.exercises.where((exercise) {
        final matchesGroup = _groupId == null ||
            exercise.muscleGroupId == _groupId;
        final query = _search.trim().toLowerCase();
        return matchesGroup &&
            (query.isEmpty || exercise.name.toLowerCase().contains(query));
      }).toList();

  Map<String, List<Users>> get _athletesByTeam {
    final teams = <String, List<Users>>{};
    for (final athlete in widget.athletes) {
      final team = athlete.team?.trim();
      if (team == null || team.isEmpty) continue;
      teams.putIfAbsent(team, () => []).add(athlete);
    }
    return teams;
  }

  String _athleteSearchLabel(String value) {
    if (value.startsWith('team:')) {
      final team = value.substring(5);
      return 'Team: $team (${_athletesByTeam[team]?.length ?? 0} athletes)';
    }
    final athlete = widget.athletes.firstWhere((user) => user.id == value);
    final team = athlete.team?.trim();
    return team == null || team.isEmpty
        ? athlete.fullName
        : '${athlete.fullName} - $team';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_athleteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose an athlete for this program')),
      );
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one exercise')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final saved = await widget.repository.saveProgram(
        id: widget.program?.id,
        athleteId: _athleteId!,
        title: _title.text.trim(),
        scheduledDate: _date,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        status: _status,
        items: [
          for (var i = 0; i < _items.length; i++)
            ExerciseProgramItem(
              id: _items[i].id,
              exerciseId: _items[i].exerciseId,
              sortOrder: i,
              sets: _items[i].sets,
              reps: _items[i].reps,
              durationSeconds: _items[i].durationSeconds,
              restSeconds: _items[i].restSeconds,
              notes: _items[i].notes,
              exercise: _items[i].exercise,
            ),
        ],
      );
      if (mounted) Navigator.of(context).pop(saved);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Dialog(
      insetPadding: EdgeInsets.all(wide ? 32 : 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120, maxHeight: 780),
        child: Column(
          children: [
            _DialogHeader(
              title: widget.program == null ? 'Create program' : 'Edit program',
              onClose: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: wide
                    ? Row(
                        children: [
                          Expanded(child: _buildDetails()),
                          const VerticalDivider(width: 1),
                          Expanded(flex: 2, child: _buildExerciseWorkspace()),
                        ],
                      )
                    : _buildMobileEditor(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  Text('${_items.length} exercises'),
                  const Spacer(),
                  TextButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: _saving
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: const Text('Save program'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileEditor() => ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDetails(scrollable: false),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
            child: Text(
              'Exercise library',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          _buildFilters(),
          if (_filteredExercises.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              child: Center(child: Text('No exercises match these filters')),
            )
          else
            ..._filteredExercises.map(_buildMobileLibraryRow),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Divider(height: 1),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              children: [
                Text(
                  'Added exercises',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const Spacer(),
                Text(
                  '${_items.length}',
                  style: const TextStyle(
                    color: Color(0xFF0D6EFD),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (_items.isEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.playlist_add_rounded,
                    color: Color(0xFF0D6EFD),
                    size: 32,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No exercises added yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Use the plus button above to build this program.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                ],
              ),
            )
          else
            ...List.generate(_items.length, _buildMobileAddedRow),
          const SizedBox(height: 20),
        ],
      );

  Widget _buildDetails({bool scrollable = true}) => ListView(
        shrinkWrap: !scrollable,
        physics: scrollable
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          IotDropdown2<String>(
            value: _selectedTeamName == null
                ? _athleteId
                : 'team:$_selectedTeamName',
            hintText: 'Search athlete or team',
            enableSearch: true,
            searchHintText: 'Search athlete or team...',
            dropdownMaxHeight: 320,
            itemAsString: _athleteSearchLabel,
            items: [
              ...widget.athletes.map(
                (u) => DropdownMenuItem(
                  value: u.id,
                  child: Text(_athleteSearchLabel(u.id)),
                ),
              ),
              ...(_athletesByTeam.keys.toList()..sort()).map(
                (team) => DropdownMenuItem(
                  value: 'team:$team',
                  child: Text(_athleteSearchLabel('team:$team')),
                ),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                if (value.startsWith('team:')) {
                  _selectedTeamName = value.substring(5);
                  _athleteId = null;
                } else {
                  _selectedTeamName = null;
                  _athleteId = value;
                }
              });
            },
          ),
          if (_selectedTeamName != null) ...[
            const SizedBox(height: 14),
            IotDropdown2<String>(
              value: _athleteId,
              hintText: 'Choose an athlete from $_selectedTeamName',
              enableSearch: true,
              searchHintText: 'Search team member...',
              itemAsString: (id) => _athletesByTeam[_selectedTeamName]!
                  .firstWhere((user) => user.id == id)
                  .fullName,
              items: (_athletesByTeam[_selectedTeamName] ?? const [])
                  .map(
                    (u) => DropdownMenuItem(
                      value: u.id,
                      child: Text(u.fullName),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _athleteId = value),
            ),
          ],
          const SizedBox(height: 14),
          TextFormField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Program title'),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter a title'
                : null,
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _date = picked);
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Scheduled date',
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              child: Text(DateFormat('EEE, d MMM yyyy').format(_date)),
            ),
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<String>(
            initialValue: _status,
            decoration: const InputDecoration(labelText: 'Status'),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
              DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
            onChanged: (value) => setState(() => _status = value ?? 'active'),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _notes,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(labelText: 'Program notes'),
          ),
        ],
      );

  Widget _buildFilters() {
    final groups = _exerciseGroups;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search exercise library',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (value) => setState(() => _search = value),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _groupId == null,
                  onSelected: (_) => setState(() => _groupId = null),
                ),
                for (final group in groups) ...[
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(group.name),
                    selected: _groupId == group.id,
                    onSelected: (_) => setState(() => _groupId = group.id),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ExerciseMuscleGroup> get _exerciseGroups {
    final groups = <String, ExerciseMuscleGroup>{
      for (final exercise in widget.exercises)
        exercise.muscleGroupId: ?exercise.muscleGroup,
    }.values.toList();
    groups.sort((a, b) => a.name.compareTo(b.name));
    return groups;
  }

  Widget _buildMobileLibraryRow(Exercise exercise) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onDoubleTap: () => showExerciseInfo(context, exercise),
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
            title: Text(
              exercise.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                exercise.description?.trim().isNotEmpty == true
                    ? exercise.description!
                    : exercise.muscleGroup?.name ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: IconButton(
              tooltip: 'Add exercise',
              icon: const Icon(Icons.add_circle_rounded),
              color: const Color(0xFF0D6EFD),
              onPressed: () => _addExercise(exercise),
            ),
          ),
        ),
      );

  Widget _buildMobileAddedRow(int index) {
    final item = _items[index];
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${item.exercise.name}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _prescription(item),
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
                  if ((item.notes ?? '').trim().isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      item.notes!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: 'Edit prescription',
              icon: const Icon(Icons.tune_rounded),
              onPressed: () => _editItem(index),
            ),
            IconButton(
              tooltip: 'Remove',
              icon: const Icon(Icons.close_rounded),
              onPressed: () => setState(() => _items.removeAt(index)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseWorkspace() {
    return Column(
      children: [
        _buildFilters(),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 8, 16),
                  itemCount: _filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _filteredExercises[index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: () => showExerciseInfo(context, exercise),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(exercise.name),
                        subtitle: Text(
                          exercise.description?.trim().isNotEmpty == true
                              ? exercise.description!
                              : exercise.muscleGroup?.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          tooltip: 'Add exercise',
                          icon: const Icon(Icons.add_circle_outline_rounded),
                          onPressed: () => _addExercise(exercise),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: _items.isEmpty
                    ? const Center(child: Text('Added exercises appear here'))
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.fromLTRB(8, 0, 16, 16),
                        itemCount: _items.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex--;
                            final item = _items.removeAt(oldIndex);
                            _items.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return Card(
                            key: ValueKey('${item.exerciseId}-$index'),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(item.exercise.name),
                              subtitle: Text(_prescription(item)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit prescription',
                                    icon: const Icon(Icons.tune_rounded),
                                    onPressed: () => _editItem(index),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove',
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () => setState(() => _items.removeAt(index)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _addExercise(Exercise exercise) {
    setState(() => _items.add(ExerciseProgramItem(
          exerciseId: exercise.id,
          sortOrder: _items.length,
          sets: 3,
          reps: 10,
          restSeconds: 60,
          exercise: exercise,
        )));
  }

  Future<void> _editItem(int index) async {
    final updated = await showDialog<ExerciseProgramItem>(
      context: context,
      builder: (_) => _PrescriptionDialog(item: _items[index]),
    );
    if (updated != null) setState(() => _items[index] = updated);
  }
}

class _PrescriptionDialog extends StatefulWidget {
  final ExerciseProgramItem item;
  const _PrescriptionDialog({required this.item});

  @override
  State<_PrescriptionDialog> createState() => _PrescriptionDialogState();
}

class _PrescriptionDialogState extends State<_PrescriptionDialog> {
  late final TextEditingController sets = _ctrl(widget.item.sets);
  late final TextEditingController reps = _ctrl(widget.item.reps);
  late final TextEditingController duration = _ctrl(widget.item.durationSeconds);
  late final TextEditingController rest = _ctrl(widget.item.restSeconds);
  late final TextEditingController notes = TextEditingController(text: widget.item.notes);
  TextEditingController _ctrl(int? value) => TextEditingController(text: value?.toString() ?? '');
  int? _number(TextEditingController c) => int.tryParse(c.text.trim());

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.item.exercise.name),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Expanded(child: TextField(controller: sets, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Sets'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: reps, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Reps'))),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: TextField(controller: duration, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (sec)'))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: rest, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rest (sec)'))),
                ]),
                const SizedBox(height: 12),
                TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Coach notes')),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              ExerciseProgramItem(
                id: widget.item.id,
                exerciseId: widget.item.exerciseId,
                sortOrder: widget.item.sortOrder,
                sets: _number(sets),
                reps: _number(reps),
                durationSeconds: _number(duration),
                restSeconds: _number(rest),
                notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
                exercise: widget.item.exercise,
              ),
            ),
            child: const Text('Apply'),
          ),
        ],
      );
}

class _DialogHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  const _DialogHeader({required this.title, required this.onClose});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 12, 14),
        decoration: const BoxDecoration(color: Color(0xFF071A36)),
        child: Row(children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton(tooltip: 'Close', onPressed: onClose, icon: const Icon(Icons.close_rounded, color: Colors.white)),
        ]),
      );
}

String exercisePrescription(ExerciseProgramItem item) => _prescription(item);

String _prescription(ExerciseProgramItem item) {
  final values = <String>[];
  if (item.sets != null) values.add('${item.sets} sets');
  if (item.reps != null) values.add('${item.reps} reps');
  if (item.durationSeconds != null) values.add('${item.durationSeconds}s work');
  if (item.restSeconds != null) values.add('${item.restSeconds}s rest');
  return values.isEmpty ? 'No prescription' : values.join('  |  ');
}

void showExerciseInfo(BuildContext context, Exercise exercise) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if ((exercise.photoUrl ?? '').isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  exercise.photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFFE8F2FF),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: Color(0xFF0D6EFD),
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Text(exercise.name),
          ),
        ],
      ),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if ((exercise.muscleGroup?.name ?? '').isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    exercise.muscleGroup!.name,
                    style: const TextStyle(
                      color: Color(0xFF0D6EFD),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                exercise.description?.trim().isNotEmpty == true
                    ? exercise.description!
                    : 'No description has been added for this exercise.',
                style: const TextStyle(height: 1.5),
              ),
              if ((exercise.videoUrl ?? '').isNotEmpty) ...[
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () async {
                    final uri = Uri.tryParse(exercise.videoUrl!);
                    if (uri != null) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  icon: const Icon(Icons.play_circle_outline_rounded),
                  label: const Text('Watch demonstration'),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void showExerciseDetails(BuildContext context, ExerciseProgramItem item) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if ((item.exercise.photoUrl ?? '').isNotEmpty)
            ClipRRect(borderRadius: BorderRadius.circular(8), child: AspectRatio(aspectRatio: 16 / 9, child: Image.network(item.exercise.photoUrl!, fit: BoxFit.cover))),
          const SizedBox(height: 20),
          Text(item.exercise.name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(item.exercise.muscleGroup?.name ?? ''),
          const SizedBox(height: 18),
          Text(exercisePrescription(item), style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          if ((item.exercise.description ?? '').isNotEmpty) ...[const SizedBox(height: 18), Text(item.exercise.description!)],
          if ((item.notes ?? '').isNotEmpty) ...[const SizedBox(height: 18), Text('Coach notes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 6), Text(item.notes!)],
          if ((item.exercise.videoUrl ?? '').isNotEmpty) ...[
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () async {
                final uri = Uri.tryParse(item.exercise.videoUrl!);
                if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: const Text('Watch demonstration'),
            ),
          ],
        ]),
      ),
    ),
  );
}
