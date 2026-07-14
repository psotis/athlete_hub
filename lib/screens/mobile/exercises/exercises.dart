import 'package:athlete_hub/helpers/imports.dart';

class ExercisesMobile extends StatefulWidget {
  const ExercisesMobile({super.key});
  @override State<ExercisesMobile> createState() => _ExercisesMobileState();
}

class _ExercisesMobileState extends State<ExercisesMobile> {
  final repository = ExerciseRepository();
  List<ExerciseProgram> programs = [];
  List<Exercise> exercises = [];
  List<Users> athletes = [];
  String? athleteId;
  bool loading = true;
  String? error;
  bool get manager {
    final user = context.currentUserRead;
    return user?.isAdmin == true || user?.isTrainer == true;
  }

  @override void initState() { super.initState(); Future.microtask(load); }

  Future<void> load() async {
    setState(() { loading = true; error = null; });
    try {
      if (manager) {
        final customers = await UserService().getCustomers();
        athletes = customers.data ?? [];
        exercises = await repository.getExercises();
        athleteId ??= athletes.isEmpty ? null : athletes.first.id;
      }
      programs = await repository.getPrograms(athleteId: athleteId);
    } catch (e) { error = e.toString(); }
    if (mounted) setState(() => loading = false);
  }

  Future<void> edit([ExerciseProgram? program]) async {
    final result = await showExerciseProgramEditor(context, repository: repository, athletes: athletes, exercises: exercises, program: program, initialAthleteId: athleteId);
    if (result != null) await load();
  }

  Future<void> remove(ExerciseProgram program) async {
    final yes = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Delete program?'), content: Text('${program.title} will be permanently removed.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))],
    ));
    if (yes == true) { await repository.deleteProgram(program.id); await load(); }
  }

  @override Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: MobilePageScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      MobilePageHeader(
        title: manager ? 'Training programs' : 'My training',
        subtitle: manager ? 'Build focused sessions and assign them to an athlete.' : 'Your scheduled workouts and coaching instructions.',
        trailing: manager ? MobileTopIconButton(icon: Icons.add_rounded, onTap: athletes.isEmpty ? null : edit) : null,
        bottom: manager && athletes.isNotEmpty ? IotDropdown2<String>(
          value: athleteId,
          hintText: 'Search athlete or team',
          enableSearch: true,
          searchHintText: 'Search athlete or team...',
          itemAsString: (id) {
            final athlete = athletes.firstWhere((user) => user.id == id);
            final team = athlete.team?.trim();
            return team == null || team.isEmpty
                ? athlete.fullName
                : '${athlete.fullName} - $team';
          },
          items: athletes.map((u) => DropdownMenuItem(
            value: u.id,
            child: Text(
              (u.team ?? '').trim().isEmpty
                  ? u.fullName
                  : '${u.fullName} - ${u.team}',
            ),
          )).toList(),
          onChanged: (value) { athleteId = value; load(); },
        ) : null,
      ),
      const SizedBox(height: 22),
      if (loading) const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()))
      else if (error != null) _Message(icon: Icons.cloud_off_rounded, title: 'Could not load programs', message: error!, action: load)
      else if (manager && athletes.isEmpty) const _Message(icon: Icons.group_off_outlined, title: 'No athletes yet', message: 'Add an athlete before creating a training program.')
      else if (programs.isEmpty) _Message(icon: Icons.fitness_center_rounded, title: manager ? 'No programs for this athlete' : 'No training assigned yet', message: manager ? 'Create the first program from the plus button.' : 'Your coach’s next program will appear here.')
      else ...[
        MobileSectionTitle(title: manager ? 'Assigned programs' : 'Your schedule', subtitle: '${programs.length} ${programs.length == 1 ? 'program' : 'programs'}'),
        const SizedBox(height: 14),
        for (final program in programs) ...[
          _ProgramCard(program: program, manager: manager, onEdit: () => edit(program), onDelete: () => remove(program)),
          const SizedBox(height: 14),
        ],
      ],
      ]),
    ),
  );
}

class _ProgramCard extends StatefulWidget {
  final ExerciseProgram program; final bool manager; final VoidCallback onEdit; final VoidCallback onDelete;
  const _ProgramCard({required this.program, required this.manager, required this.onEdit, required this.onDelete});
  @override State<_ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<_ProgramCard> {
  bool expanded = false;
  @override Widget build(BuildContext context) {
    final p = widget.program;
    final date = p.scheduledDate == null ? 'Any day' : DateFormat('EEE, d MMM').format(p.scheduledDate!);
    return MobileGlassCard(borderRadius: BorderRadius.circular(8), padding: EdgeInsets.zero, child: Column(children: [
      InkWell(onTap: () => setState(() => expanded = !expanded), child: Padding(padding: const EdgeInsets.all(18), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: const Color(0xFF6EE7FF).withAlpha(30), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF6EE7FF))),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)), const SizedBox(height: 7), Text('$date  •  ${p.items.length} exercises', style: TextStyle(color: Colors.white.withAlpha(180))), if ((p.notes ?? '').isNotEmpty) ...[const SizedBox(height: 8), Text(p.notes!, maxLines: expanded ? null : 2, overflow: expanded ? null : TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withAlpha(160), height: 1.4))]])),
        Icon(expanded ? Icons.expand_less_rounded : Icons.expand_more_rounded, color: Colors.white70),
      ]))),
      if (expanded) ...[
        Divider(height: 1, color: Colors.white.withAlpha(28)),
        for (var i = 0; i < p.items.length; i++) InkWell(onTap: () => showExerciseDetails(context, p.items[i]), child: Padding(padding: const EdgeInsets.fromLTRB(18, 13, 12, 13), child: Row(children: [
          SizedBox(width: 28, child: Text('${i + 1}', style: const TextStyle(color: Color(0xFF6EE7FF), fontWeight: FontWeight.w800))),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.items[i].exercise.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(exercisePrescription(p.items[i]), style: TextStyle(color: Colors.white.withAlpha(155), fontSize: 12))])),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54),
        ]))),
        if (widget.manager) Padding(padding: const EdgeInsets.fromLTRB(12, 8, 12, 14), child: Row(children: [Expanded(child: OutlinedButton.icon(onPressed: widget.onEdit, icon: const Icon(Icons.edit_outlined), label: const Text('Edit'))), const SizedBox(width: 10), IconButton(tooltip: 'Delete program', onPressed: widget.onDelete, icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF8A8A)))])),
      ],
    ]));
  }
}

class _Message extends StatelessWidget {
  final IconData icon; final String title; final String message; final VoidCallback? action;
  const _Message({required this.icon, required this.title, required this.message, this.action});
  @override Widget build(BuildContext context) => MobileGlassCard(borderRadius: BorderRadius.circular(8), child: Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: Column(children: [
    Icon(icon, size: 42, color: const Color(0xFF6EE7FF)), const SizedBox(height: 14),
    Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)), const SizedBox(height: 8),
    Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withAlpha(170))),
    if (action != null) ...[const SizedBox(height: 18), OutlinedButton.icon(onPressed: action, icon: const Icon(Icons.refresh_rounded), label: const Text('Try again'))],
  ]))));
}
