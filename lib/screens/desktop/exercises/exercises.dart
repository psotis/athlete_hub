import 'package:athlete_hub/helpers/imports.dart';

class ExercisesDesktop extends StatefulWidget {
  const ExercisesDesktop({super.key});
  @override State<ExercisesDesktop> createState() => _ExercisesDesktopState();
}

class _ExercisesDesktopState extends State<ExercisesDesktop> {
  final repository = ExerciseRepository();
  List<ExerciseProgram> programs = [];
  List<Exercise> exercises = [];
  List<Users> athletes = [];
  String? athleteId;
  String athleteSearch = '';
  ExerciseProgram? selected;
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
      final selectedIndex = programs.indexWhere((p) => p.id == selected?.id);
      selected = selectedIndex >= 0
          ? programs[selectedIndex]
          : (programs.isEmpty ? null : programs.first);
    } catch (e) { error = e.toString(); }
    if (mounted) setState(() => loading = false);
  }

  Future<void> edit([ExerciseProgram? program]) async {
    final result = await showExerciseProgramEditor(context, repository: repository, athletes: athletes, exercises: exercises, program: program, initialAthleteId: athleteId);
    if (result != null) { selected = result; await load(); }
  }

  Future<void> remove(ExerciseProgram program) async {
    final yes = await showDialog<bool>(context: context, builder: (_) => AlertDialog(title: const Text('Delete program?'), content: Text('${program.title} will be permanently removed.'), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')), FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))]));
    if (yes == true) { await repository.deleteProgram(program.id); await load(); }
  }

  @override Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) return _Empty(icon: Icons.cloud_off_rounded, title: 'Could not load exercise programs', message: error!, action: load);
    if (!manager) return _customerView();
    return Column(children: [
      Row(children: [
        Expanded(child: DesktopSectionTitle(title: 'Training programs', subtitle: 'Assign clear, focused sessions and manage every prescription.')),
        OutlinedButton.icon(onPressed: () => context.push(Routes.exerciseLibrary), icon: const Icon(Icons.local_library_outlined), label: const Text('Exercise library')),
        const SizedBox(width: 10),
        FilledButton.icon(onPressed: athletes.isEmpty ? null : edit, icon: const Icon(Icons.add_rounded), label: const Text('New program')),
      ]),
      const SizedBox(height: 22),
      Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(width: 280, child: DesktopSurfaceCard(padding: const EdgeInsets.all(14), borderRadius: 8, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(padding: EdgeInsets.all(8), child: Text('Athletes', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16))),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search athlete or team',
              prefixIcon: Icon(Icons.search_rounded),
            ),
            onChanged: (value) => setState(() => athleteSearch = value),
          ),
          const SizedBox(height: 10),
          Expanded(child: athletes.isEmpty ? const _Empty(icon: Icons.group_off_outlined, title: 'No athletes', message: 'Add an athlete to begin.') : Builder(builder: (context) {
            final query = athleteSearch.trim().toLowerCase();
            final shown = athletes.where((u) => query.isEmpty || u.fullName.toLowerCase().contains(query) || (u.team ?? '').toLowerCase().contains(query)).toList();
            return ListView.builder(itemCount: shown.length, itemBuilder: (_, i) { final u = shown[i]; final active = u.id == athleteId; return ListTile(selected: active, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), leading: CircleAvatar(child: Text(u.firstName.isEmpty ? '?' : u.firstName[0].toUpperCase())), title: Text(u.fullName, maxLines: 1, overflow: TextOverflow.ellipsis), subtitle: Text((u.team ?? '').isEmpty ? (u.sport ?? 'Athlete') : u.team!, maxLines: 1), onTap: () { setState(() => athleteId = u.id); load(); }); });
          })),
        ]))),
        const SizedBox(width: 16),
        SizedBox(width: 330, child: DesktopSurfaceCard(padding: const EdgeInsets.all(14), borderRadius: 8, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.all(8), child: Row(children: [const Text('Programs', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)), const Spacer(), Text('${programs.length}', style: const TextStyle(color: Color(0xFF64748B)))])),
          const SizedBox(height: 8),
          Expanded(child: programs.isEmpty ? const _Empty(icon: Icons.event_note_outlined, title: 'No programs', message: 'Create the first program for this athlete.') : ListView.builder(itemCount: programs.length, itemBuilder: (_, i) => _ProgramTile(program: programs[i], selected: selected?.id == programs[i].id, onTap: () => setState(() => selected = programs[i])))),
        ]))),
        const SizedBox(width: 16),
        Expanded(child: DesktopSurfaceCard(padding: EdgeInsets.zero, borderRadius: 8, child: selected == null ? const _Empty(icon: Icons.fitness_center_rounded, title: 'Select a program', message: 'Program details and exercises will appear here.') : _ProgramDetail(program: selected!, manager: true, onEdit: () => edit(selected), onDelete: () => remove(selected!)))),
      ])),
    ]);
  }

  Widget _customerView() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const DesktopSectionTitle(title: 'My training', subtitle: 'Your scheduled workouts and coaching instructions.'),
    const SizedBox(height: 22),
    Expanded(child: programs.isEmpty ? const _Empty(icon: Icons.fitness_center_rounded, title: 'No training assigned yet', message: 'Your coach’s next program will appear here.') : Row(children: [
      SizedBox(width: 340, child: DesktopSurfaceCard(padding: const EdgeInsets.all(14), borderRadius: 8, child: ListView.builder(itemCount: programs.length, itemBuilder: (_, i) => _ProgramTile(program: programs[i], selected: selected?.id == programs[i].id, onTap: () => setState(() => selected = programs[i]))))),
      const SizedBox(width: 16),
      Expanded(child: DesktopSurfaceCard(padding: EdgeInsets.zero, borderRadius: 8, child: _ProgramDetail(program: selected ?? programs.first, manager: false))),
    ])),
  ]);
}

class _ProgramTile extends StatelessWidget {
  final ExerciseProgram program; final bool selected; final VoidCallback onTap;
  const _ProgramTile({required this.program, required this.selected, required this.onTap});
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 8), child: ListTile(
    selected: selected, selectedTileColor: const Color(0xFFE8F2FF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), onTap: onTap,
    leading: Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF0D6EFD).withAlpha(24), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.fitness_center_rounded, color: Color(0xFF0D6EFD), size: 20)),
    title: Text(program.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text('${program.scheduledDate == null ? 'Any day' : DateFormat('d MMM yyyy').format(program.scheduledDate!)}  •  ${program.items.length} exercises'),
  ));
}

class _ProgramDetail extends StatelessWidget {
  final ExerciseProgram program; final bool manager; final VoidCallback? onEdit; final VoidCallback? onDelete;
  const _ProgramDetail({required this.program, required this.manager, this.onEdit, this.onDelete});
  @override Widget build(BuildContext context) => Column(children: [
    Container(padding: const EdgeInsets.all(22), decoration: const BoxDecoration(color: Color(0xFF071A36), borderRadius: BorderRadius.vertical(top: Radius.circular(8))), child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(program.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)), const SizedBox(height: 6), Text('${program.scheduledDate == null ? 'Flexible date' : DateFormat('EEEE, d MMMM yyyy').format(program.scheduledDate!)}  •  ${program.items.length} exercises', style: const TextStyle(color: Colors.white70))])),
      if (manager) ...[IconButton(tooltip: 'Edit program', onPressed: onEdit, icon: const Icon(Icons.edit_outlined, color: Colors.white)), IconButton(tooltip: 'Delete program', onPressed: onDelete, icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFFF9C9C)))],
    ])),
    if ((program.notes ?? '').isNotEmpty) Container(width: double.infinity, padding: const EdgeInsets.all(18), color: const Color(0xFFF1F6FC), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.notes_rounded, color: Color(0xFF0D6EFD)), const SizedBox(width: 12), Expanded(child: Text(program.notes!, style: const TextStyle(height: 1.45)))])),
    Expanded(child: ListView.separated(padding: const EdgeInsets.all(18), itemCount: program.items.length, separatorBuilder: (_, _) => const Divider(height: 1), itemBuilder: (_, i) { final item = program.items[i]; return ListTile(contentPadding: const EdgeInsets.symmetric(vertical: 8), onTap: () => showExerciseDetails(context, item), leading: CircleAvatar(backgroundColor: const Color(0xFFE8F2FF), child: Text('${i + 1}', style: const TextStyle(color: Color(0xFF0D6EFD), fontWeight: FontWeight.w800))), title: Text(item.exercise.name, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text(exercisePrescription(item))), trailing: const Icon(Icons.chevron_right_rounded)); })),
  ]);
}

class _Empty extends StatelessWidget {
  final IconData icon; final String title; final String message; final VoidCallback? action;
  const _Empty({required this.icon, required this.title, required this.message, this.action});
  @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 42, color: const Color(0xFF0D6EFD)), const SizedBox(height: 14), Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)), const SizedBox(height: 7), Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF64748B))), if (action != null) ...[const SizedBox(height: 16), OutlinedButton.icon(onPressed: action, icon: const Icon(Icons.refresh), label: const Text('Try again'))]])));
}
