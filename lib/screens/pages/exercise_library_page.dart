import 'package:athlete_hub/helpers/imports.dart';

class ExerciseLibraryPage extends StatefulWidget {
  const ExerciseLibraryPage({super.key});

  @override
  State<ExerciseLibraryPage> createState() => _ExerciseLibraryPageState();
}

class _ExerciseLibraryPageState extends State<ExerciseLibraryPage> {
  final repository = ExerciseRepository();
  final searchController = TextEditingController();
  List<ExerciseCategory> categories = [];
  List<ExerciseMuscleGroup> groups = [];
  List<Exercise> exercises = [];
  int section = 2;
  String search = '';
  bool loading = true;
  String? error;

  bool get canManage {
    final user = context.currentUserRead;
    return user?.isAdmin == true || user?.isTrainer == true;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(load);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> load() async {
    if (!canManage) {
      setState(() {
        loading = false;
        error = 'Exercise library access is limited to trainers and admins.';
      });
      return;
    }
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final values = await Future.wait([
        repository.getCategories(),
        repository.getMuscleGroups(),
        repository.getExercises(),
      ]);
      categories = values[0] as List<ExerciseCategory>;
      groups = values[1] as List<ExerciseMuscleGroup>;
      exercises = values[2] as List<Exercise>;
    } catch (e) {
      error = e.toString();
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 700;
    return Scaffold(
      backgroundColor: mobile
          ? const Color(0xFF06142B)
          : const Color(0xFFF3F7FB),
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: const Text(
          'Exercise library',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF071A36),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: canManage && !loading
          ? FloatingActionButton.extended(
              onPressed: _addCurrent,
              icon: const Icon(Icons.add_rounded),
              label: Text(['Category', 'Muscle group', 'Exercise'][section]),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: Padding(
              padding: EdgeInsets.all(mobile ? 14 : 24),
              child: Column(
                children: [
                  _sectionControl(mobile),
                  const SizedBox(height: 14),
                  TextField(
                    controller: searchController,
                    onChanged: (value) => setState(() => search = value),
                    style: TextStyle(
                      color: mobile ? Colors.white : const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Search ${['categories', 'muscle groups', 'exercises'][section]}',
                      hintStyle: TextStyle(
                        color: mobile
                            ? Colors.white54
                            : const Color(0xFF64748B),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: mobile
                            ? Colors.white70
                            : const Color(0xFF475569),
                      ),
                      filled: true,
                      fillColor: mobile
                          ? Colors.white.withAlpha(18)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(child: _content(mobile)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionControl(bool mobile) {
    if (mobile) {
      return DropdownButtonFormField<int>(
        key: ValueKey(section),
        initialValue: section,
        dropdownColor: const Color(0xFF10284A),
        iconEnabledColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withAlpha(18),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white24),
          ),
        ),
        items: const [
          DropdownMenuItem(
            value: 0,
            child: _SectionLabel(
              icon: Icons.category_outlined,
              text: 'Categories',
            ),
          ),
          DropdownMenuItem(
            value: 1,
            child: _SectionLabel(
              icon: Icons.account_tree_outlined,
              text: 'Groups',
            ),
          ),
          DropdownMenuItem(
            value: 2,
            child: _SectionLabel(
              icon: Icons.fitness_center_rounded,
              text: 'Exercises',
            ),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          _selectSection(value);
        },
      );
    }

    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(
          value: 0,
          icon: Icon(Icons.category_outlined),
          label: Text('Categories'),
        ),
        ButtonSegment(
          value: 1,
          icon: Icon(Icons.account_tree_outlined),
          label: Text('Groups'),
        ),
        ButtonSegment(
          value: 2,
          icon: Icon(Icons.fitness_center_rounded),
          label: Text('Exercises'),
        ),
      ],
      selected: {section},
      showSelectedIcon: false,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : const Color(0xFF334155),
        ),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Color(0xFF0D6EFD)
              : Colors.white,
        ),
      ),
      onSelectionChanged: (value) => _selectSection(value.first),
    );
  }

  void _selectSection(int value) => setState(() {
    section = value;
    search = '';
    searchController.clear();
  });

  Widget _content(bool mobile) {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return _LibraryMessage(message: error!, onRetry: load, dark: mobile);
    }
    final query = search.trim().toLowerCase();
    if (section == 0) {
      final shown = categories
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
      return _list(
        shown.map(
          (item) => _LibraryRow(
            title: item.name,
            subtitle: item.description ?? 'No description',
            dark: mobile,
            onEdit: () => _editCategory(item),
            onDelete: () => _delete(
              'category',
              item.name,
              () => repository.deleteCategory(item.id),
            ),
          ),
        ),
        mobile,
      );
    }
    if (section == 1) {
      final shown = groups.where((item) {
        final category = item.category?.name ?? '';
        return item.name.toLowerCase().contains(query) ||
            category.toLowerCase().contains(query);
      }).toList();
      return _list(
        shown.map(
          (item) => _LibraryRow(
            title: item.name,
            subtitle:
                '${item.category?.name ?? 'Category'} • ${item.description ?? 'No description'}',
            dark: mobile,
            onEdit: () => _editGroup(item),
            onDelete: () => _delete(
              'muscle group',
              item.name,
              () => repository.deleteMuscleGroup(item.id),
            ),
          ),
        ),
        mobile,
      );
    }
    final shown = exercises.where((item) {
      final group = item.muscleGroup?.name ?? '';
      final category = item.muscleGroup?.category?.name ?? '';
      return item.name.toLowerCase().contains(query) ||
          group.toLowerCase().contains(query) ||
          category.toLowerCase().contains(query);
    }).toList();
    return _list(
      shown.map(
        (item) => _LibraryRow(
          title: item.name,
          subtitle:
              '${item.muscleGroup?.category?.name ?? ''} / ${item.muscleGroup?.name ?? ''}\n${item.description ?? 'No description'}',
          dark: mobile,
          onTap: () => showExerciseInfo(context, item),
          onEdit: () => _editExercise(item),
          onDelete: () => _delete(
            'exercise',
            item.name,
            () => repository.deleteExercise(item.id),
          ),
        ),
      ),
      mobile,
    );
  }

  Widget _list(Iterable<Widget> rows, bool mobile) {
    final values = rows.toList();
    if (values.isEmpty) {
      return _LibraryMessage(
        message: search.isEmpty
            ? 'Nothing has been added here yet.'
            : 'No results match your search.',
        dark: mobile,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: values.length,
      separatorBuilder: (_, _) => const SizedBox(height: 9),
      itemBuilder: (_, index) => values[index],
    );
  }

  void _addCurrent() {
    if (section == 0) _editCategory();
    if (section == 1) _editGroup();
    if (section == 2) _editExercise();
  }

  Future<void> _editCategory([ExerciseCategory? category]) async {
    final result = await _textDialog(
      title: category == null ? 'New category' : 'Edit category',
      name: category?.name,
      description: category?.description,
    );
    if (result == null) return;
    await _save(
      () => repository.saveCategory(
        id: category?.id,
        name: result.$1,
        description: result.$2,
      ),
    );
  }

  Future<void> _editGroup([ExerciseMuscleGroup? group]) async {
    if (categories.isEmpty) {
      _notice('Create a category first.');
      return;
    }
    final result = await _groupDialog(group);
    if (result == null) return;
    await _save(
      () => repository.saveMuscleGroup(
        id: group?.id,
        categoryId: result.$1,
        name: result.$2,
        description: result.$3,
      ),
    );
  }

  Future<void> _editExercise([Exercise? exercise]) async {
    if (groups.isEmpty) {
      _notice('Create a muscle group first.');
      return;
    }
    final result = await _exerciseDialog(exercise);
    if (result == null) return;
    await _save(
      () => repository.saveExercise(
        id: exercise?.id,
        muscleGroupId: result.$1,
        name: result.$2,
        photoUrl: result.$3,
        videoUrl: result.$4,
        description: result.$5,
      ),
    );
  }

  Future<(String, String?)?> _textDialog({
    required String title,
    String? name,
    String? description,
  }) async {
    final nameController = TextEditingController(text: name);
    final descriptionController = TextEditingController(text: description);
    return showDialog<(String, String?)>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = nameController.text.trim();
              if (value.isEmpty) return;
              Navigator.pop(dialogContext, (
                value,
                _nullable(descriptionController.text),
              ));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<(String, String, String?)?> _groupDialog([
    ExerciseMuscleGroup? group,
  ]) async {
    final name = TextEditingController(text: group?.name);
    final description = TextEditingController(text: group?.description);
    var categoryId = group?.categoryId ?? categories.first.id;
    return showDialog<(String, String, String?)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setLocal) => AlertDialog(
          title: Text(group == null ? 'New muscle group' : 'Edit muscle group'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: categoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(item.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setLocal(() => categoryId = value ?? categoryId),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: description,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty) return;
                Navigator.pop(dialogContext, (
                  categoryId,
                  name.text.trim(),
                  _nullable(description.text),
                ));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<(String, String, String?, String?, String?)?> _exerciseDialog([
    Exercise? exercise,
  ]) async {
    final name = TextEditingController(text: exercise?.name);
    final photo = TextEditingController(text: exercise?.photoUrl);
    final video = TextEditingController(text: exercise?.videoUrl);
    final description = TextEditingController(text: exercise?.description);
    var groupId = exercise?.muscleGroupId ?? groups.first.id;
    return showDialog<(String, String, String?, String?, String?)>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setLocal) => AlertDialog(
          title: Text(exercise == null ? 'New exercise' : 'Edit exercise'),
          content: SizedBox(
            width: 520,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: groupId,
                    decoration: const InputDecoration(
                      labelText: 'Muscle group',
                    ),
                    items: groups
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.id,
                            child: Text(
                              '${item.category?.name ?? ''} / ${item.name}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setLocal(() => groupId = value ?? groupId),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: photo,
                    decoration: const InputDecoration(labelText: 'Photo URL'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: video,
                    decoration: const InputDecoration(labelText: 'Video URL'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: description,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (name.text.trim().isEmpty) return;
                Navigator.pop(dialogContext, (
                  groupId,
                  name.text.trim(),
                  _nullable(photo.text),
                  _nullable(video.text),
                  _nullable(description.text),
                ));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _delete(
    String type,
    String name,
    Future<void> Function() action,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete $type?'),
        content: Text('$name will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await action();
      await load();
    } catch (e) {
      if (mounted) _notice(e.toString());
    }
  }

  Future<void> _save(Future<Object?> Function() action) async {
    try {
      await action();
      await load();
    } catch (e) {
      if (mounted) _notice(e.toString());
    }
  }

  void _notice(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _nullable(String value) => value.trim().isEmpty ? null : value.trim();
}

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SectionLabel({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20, color: Colors.white),
      const SizedBox(width: 10),
      Text(text),
    ],
  );
}

class _LibraryRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool dark;
  final VoidCallback? onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LibraryRow({
    required this.title,
    required this.subtitle,
    required this.dark,
    this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: dark ? Colors.white.withAlpha(18) : Colors.white,
    borderRadius: BorderRadius.circular(8),
    child: ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: dark ? Colors.white24 : const Color(0xFFE2E8F0),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      title: Text(
        title,
        style: TextStyle(
          color: dark ? Colors.white : const Color(0xFF0F172A),
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          subtitle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: dark ? Colors.white70 : const Color(0xFF64748B),
          ),
        ),
      ),
      trailing: dark
          ? PopupMenuButton<_LibraryAction>(
              tooltip: 'Exercise actions',
              color: Colors.white,
              icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
              onSelected: (action) {
                if (action == _LibraryAction.edit) onEdit();
                if (action == _LibraryAction.delete) onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: _LibraryAction.edit,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.edit_outlined),
                    title: Text(
                      'Edit',
                      style: TextStyle(color: Color(0xFF0F172A)),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: _LibraryAction.delete,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFDC2626),
                    ),
                    title: Text(
                      'Delete',
                      style: TextStyle(color: Color(0xFF0F172A)),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF334155),
                  ),
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
    ),
  );
}

enum _LibraryAction { edit, delete }

class _LibraryMessage extends StatelessWidget {
  final String message;
  final bool dark;
  final VoidCallback? onRetry;
  const _LibraryMessage({
    required this.message,
    required this.dark,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.fitness_center_rounded,
          size: 42,
          color: dark ? const Color(0xFF6EE7FF) : const Color(0xFF0D6EFD),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: dark ? Colors.white70 : const Color(0xFF64748B),
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try again'),
          ),
        ],
      ],
    ),
  );
}
