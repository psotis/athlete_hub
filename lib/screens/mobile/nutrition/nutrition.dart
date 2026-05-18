import 'package:athlete_hub/helpers/imports.dart';

class NutritionMobile extends StatefulWidget {
  const NutritionMobile({super.key});

  @override
  State<NutritionMobile> createState() => _NutritionMobileState();
}

class _NutritionMobileState extends State<NutritionMobile> {
  final List<_NutritionProgram> _programs = [];
  final List<Users> _customers = [];

  bool _isLoadingCustomers = false;
  String? _customersError;

  Users? get _currentUser => context.currentUser;
  Users? get _currentUserRead => context.currentUserRead;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final user = _currentUserRead;
    if (user == null) return;

    if (user.isCustomer) {
      setState(() {
        _programs.addAll([
          _NutritionProgram(
            athleteId: user.id,
            athleteName: user.fullName,
            monthLabel: DateFormat('MMMM yyyy').format(DateTime.now()),
            title: 'Monthly Nutrition Program',
            pdfName:
                'nutrition_program_${DateFormat('MM_yyyy').format(DateTime.now())}.pdf',
            notes:
                'Your nutritionist can attach your monthly PDF program here. This mobile view is ready for that handoff.',
          ),
        ]);
      });
      return;
    }

    if (user.isNutritionist) {
      await _loadCustomers();
    }
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoadingCustomers = true;
      _customersError = null;
    });

    try {
      final response = await UserService().getCustomers();

      if (!mounted) return;

      setState(() {
        _customers
          ..clear()
          ..addAll(response.data ?? []);
        _isLoadingCustomers = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingCustomers = false;
        _customersError = e.toString();
      });
    }
  }

  List<_NutritionProgram> get _customerPrograms {
    final user = _currentUser;
    if (user == null) return const [];

    return _programs.where((program) => program.athleteId == user.id).toList();
  }

  Future<void> _handleAddProgramTap() async {
    if (_isLoadingCustomers) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Loading athletes, please wait...')),
      );
      return;
    }

    if (_customers.isEmpty && _customersError == null) {
      await _loadCustomers();
    }

    if (_customersError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load athletes yet. Try again first.'),
        ),
      );
      return;
    }

    if (_customers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No athletes available to assign a program'),
        ),
      );
      return;
    }

    await _openProgramForm();
  }

  Future<void> _openProgramForm() async {
    if (_customers.isEmpty) return;

    Users selectedAthlete = _customers.first;
    final monthCtrl = TextEditingController(
      text: DateFormat('MMMM yyyy').format(DateTime.now()),
    );
    final titleCtrl = TextEditingController(text: 'Monthly Nutrition Program');
    final pdfNameCtrl = TextEditingController(text: 'nutrition_program.pdf');
    final pdfUrlCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    final created = await showModalBottomSheet<_NutritionProgram>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B1730),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            18,
            16,
            MediaQuery.of(context).viewInsets.bottom + 18,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add Monthly Program',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add one PDF-based nutrition program for an athlete and month.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(173),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Athlete',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    _AthletePickerField(
                      athlete: selectedAthlete,
                      onTap: () async {
                        final picked = await showModalBottomSheet<Users>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: const Color(0xFF0B1730),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(28),
                            ),
                          ),
                          builder: (_) =>
                              _AthletePickerSheet(customers: _customers),
                        );

                        if (picked == null) return;

                        setModalState(() {
                          selectedAthlete = picked;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    _NutritionField(
                      controller: monthCtrl,
                      label: 'Month',
                      hint: 'April 2026',
                    ),
                    const SizedBox(height: 12),
                    _NutritionField(
                      controller: titleCtrl,
                      label: 'Program Title',
                      hint: 'Monthly Nutrition Program',
                    ),
                    const SizedBox(height: 12),
                    _NutritionField(
                      controller: pdfNameCtrl,
                      label: 'PDF Name',
                      hint: 'athlete_april_program.pdf',
                    ),
                    const SizedBox(height: 12),
                    _NutritionField(
                      controller: pdfUrlCtrl,
                      label: 'PDF URL',
                      hint: 'https://...',
                    ),
                    const SizedBox(height: 12),
                    _NutritionField(
                      controller: notesCtrl,
                      label: 'Notes',
                      hint: 'Optional notes for the athlete',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            _NutritionProgram(
                              athleteId: selectedAthlete.id,
                              athleteName: selectedAthlete.fullName,
                              monthLabel: monthCtrl.text.trim().isEmpty
                                  ? DateFormat(
                                      'MMMM yyyy',
                                    ).format(DateTime.now())
                                  : monthCtrl.text.trim(),
                              title: titleCtrl.text.trim().isEmpty
                                  ? 'Monthly Nutrition Program'
                                  : titleCtrl.text.trim(),
                              pdfName: pdfNameCtrl.text.trim().isEmpty
                                  ? 'nutrition_program.pdf'
                                  : pdfNameCtrl.text.trim(),
                              pdfUrl: pdfUrlCtrl.text.trim().isEmpty
                                  ? null
                                  : pdfUrlCtrl.text.trim(),
                              notes: notesCtrl.text.trim().isEmpty
                                  ? null
                                  : notesCtrl.text.trim(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D6EFD),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text('Save Program'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    monthCtrl.dispose();
    titleCtrl.dispose();
    pdfNameCtrl.dispose();
    pdfUrlCtrl.dispose();
    notesCtrl.dispose();

    if (created == null || !mounted) return;

    setState(() {
      _programs.insert(0, created);
    });
  }

  Future<void> _openPdf(_NutritionProgram program) async {
    final url = program.pdfUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No PDF URL has been added for this program yet'),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid PDF URL')));
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final user = _currentUser;

    if (user == null) {
      return const SizedBox.shrink();
    }

    if (user.isNutritionist) {
      return _NutritionistNutritionView(
        programs: _programs,
        customers: _customers,
        isLoadingCustomers: _isLoadingCustomers,
        customersError: _customersError,
        onRetry: _loadCustomers,
        onAddProgram: _handleAddProgramTap,
        onOpenProgram: _openPdf,
      );
    }

    if (user.isCustomer) {
      return _CustomerNutritionView(
        programs: _customerPrograms,
        onOpenProgram: _openPdf,
      );
    }

    return const _NutritionFallbackView();
  }
}

class _AthletePickerField extends StatelessWidget {
  final Users athlete;
  final VoidCallback onTap;

  const _AthletePickerField({required this.athlete, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withAlpha(15),
          border: Border.all(color: Colors.white.withAlpha(26)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected athlete',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withAlpha(184),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    athlete.team?.trim().isNotEmpty == true
                        ? '${athlete.fullName} - ${athlete.team}'
                        : athlete.fullName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.expand_more_rounded, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _AthletePickerSheet extends StatefulWidget {
  final List<Users> customers;

  const _AthletePickerSheet({required this.customers});

  @override
  State<_AthletePickerSheet> createState() => _AthletePickerSheetState();
}

class _AthletePickerSheetState extends State<_AthletePickerSheet> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Users> get _filteredCustomers {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) return widget.customers;

    return widget.customers.where((user) {
      return user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          (user.team ?? '').toLowerCase().contains(query) ||
          (user.sport ?? '').toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCustomers = _filteredCustomers;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        18,
        16,
        MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick Athlete',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search by athlete name, team, sport or email.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withAlpha(173),
              ),
            ),
            const SizedBox(height: 16),
            MobileSearchField(
              controller: _searchCtrl,
              hintText: 'Search athlete...',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredCustomers.isEmpty
                  ? const Center(
                      child: Text(
                        'No athletes found',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filteredCustomers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final user = filteredCustomers[index];

                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => Navigator.pop(context, user),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withAlpha(15),
                              border: Border.all(
                                color: Colors.white.withAlpha(26),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(
                                      0xFF6EE7FF,
                                    ).withAlpha(31),
                                  ),
                                  child: Center(
                                    child: Text(
                                      user.firstName.isNotEmpty
                                          ? user.firstName[0].toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        [
                                          if ((user.team ?? '')
                                              .trim()
                                              .isNotEmpty)
                                            user.team!,
                                          if ((user.sport ?? '')
                                              .trim()
                                              .isNotEmpty)
                                            user.sport!,
                                          user.email,
                                        ].join(' - '),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.white.withAlpha(
                                                173,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white70,
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
    );
  }
}

class _CustomerNutritionView extends StatelessWidget {
  final List<_NutritionProgram> programs;
  final ValueChanged<_NutritionProgram> onOpenProgram;

  const _CustomerNutritionView({
    required this.programs,
    required this.onOpenProgram,
  });

  @override
  Widget build(BuildContext context) {
    final latest = programs.isEmpty ? null : programs.first;

    return MobileGlowScaffold(
      child: MobilePageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobilePageHeader(
              title: 'Nutrition Program',
              subtitle: latest == null
                  ? 'Your nutritionist can assign your monthly PDF plan here.'
                  : 'Your latest monthly nutrition program is ready below.',
              trailing: const MobileTopIconButton(
                icon: Icons.restaurant_menu_rounded,
              ),
            ),
            const SizedBox(height: 18),
            if (latest == null)
              const MobileInfoCard(
                title: 'No Program Yet',
                subtitle:
                    'Once your nutritionist uploads your monthly PDF plan, you will be able to open it from here.',
                icon: Icons.picture_as_pdf_outlined,
              )
            else
              _ProgramCard(
                program: latest,
                primaryLabel: 'Open PDF',
                onPrimaryTap: () => onOpenProgram(latest),
              ),
            if (programs.length > 1) ...[
              const SizedBox(height: 18),
              const MobileSectionTitle(
                title: 'Previous Programs',
                subtitle: 'Keep your older monthly plans close by.',
              ),
              const SizedBox(height: 12),
              ...programs
                  .skip(1)
                  .map(
                    (program) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ProgramCard(
                        program: program,
                        primaryLabel: 'Open PDF',
                        onPrimaryTap: () => onOpenProgram(program),
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NutritionistNutritionView extends StatelessWidget {
  final List<_NutritionProgram> programs;
  final List<Users> customers;
  final bool isLoadingCustomers;
  final String? customersError;
  final Future<void> Function() onRetry;
  final Future<void> Function() onAddProgram;
  final ValueChanged<_NutritionProgram> onOpenProgram;

  const _NutritionistNutritionView({
    required this.programs,
    required this.customers,
    required this.isLoadingCustomers,
    required this.customersError,
    required this.onRetry,
    required this.onAddProgram,
    required this.onOpenProgram,
  });

  @override
  Widget build(BuildContext context) {
    return MobileGlowScaffold(
      child: MobilePageScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobilePageHeader(
              title: 'Nutrition Hub',
              subtitle:
                  'Create one monthly PDF program per athlete and keep the handoff simple.',
              trailing: MobileTopIconButton(
                icon: Icons.add_rounded,
                onTap: onAddProgram,
              ),
            ),
            const SizedBox(height: 18),
            if (isLoadingCustomers)
              const Center(child: CircularProgressIndicator())
            else if (customersError != null)
              MobileInfoCard(
                title: 'Could Not Load Athletes',
                subtitle: customersError!,
                icon: Icons.error_outline_rounded,
                onTap: () => onRetry(),
              )
            else ...[
              MobileInfoCard(
                title: 'Athletes Ready',
                subtitle: customers.isEmpty
                    ? 'No athletes are available yet.'
                    : '${customers.length} athletes are available for monthly nutrition programs.',
                icon: Icons.groups_2_outlined,
                trailing: Text(
                  '${customers.length}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              MobileInfoCard(
                title: 'PDF-Based Flow',
                subtitle:
                    'This keeps the nutrition workflow simple: attach one monthly PDF program, then let the athlete open it from mobile.',
                icon: Icons.picture_as_pdf_outlined,
                onTap: onAddProgram,
              ),
              const SizedBox(height: 18),
              const MobileSectionTitle(
                title: 'Monthly Programs',
                subtitle: 'Latest plans you prepared for your athletes.',
              ),
              const SizedBox(height: 12),
              if (programs.isEmpty)
                const MobileInfoCard(
                  title: 'No Programs Added',
                  subtitle:
                      'Tap the plus button above to add the first monthly PDF program.',
                  icon: Icons.note_add_outlined,
                )
              else
                ...programs.map(
                  (program) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ProgramCard(
                      program: program,
                      primaryLabel: 'Open PDF',
                      secondaryLabel: 'Assigned',
                      onPrimaryTap: () => onOpenProgram(program),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NutritionFallbackView extends StatelessWidget {
  const _NutritionFallbackView();

  @override
  Widget build(BuildContext context) {
    return MobileGlowScaffold(
      child: MobilePageScrollView(
        child: const MobileInfoCard(
          title: 'Nutrition',
          subtitle:
              'This mobile nutrition flow is currently designed for customers and nutritionists.',
          icon: Icons.info_outline_rounded,
        ),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final _NutritionProgram program;
  final String primaryLabel;
  final String? secondaryLabel;
  final VoidCallback onPrimaryTap;

  const _ProgramCard({
    required this.program,
    required this.primaryLabel,
    required this.onPrimaryTap,
    this.secondaryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return MobileGlassCard(
      borderRadius: BorderRadius.circular(26),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: const Color(0xFF6EE7FF).withAlpha(31),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Color(0xFF7DEBFF),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.monthLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withAlpha(173),
                      ),
                    ),
                    if (program.athleteName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        program.athleteName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withAlpha(158),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _ProgramMetaRow(label: 'PDF', value: program.pdfName),
          if ((program.notes ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _ProgramMetaRow(label: 'Notes', value: program.notes!),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onPrimaryTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(primaryLabel),
                ),
              ),
              if (secondaryLabel != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withAlpha(15),
                    border: Border.all(color: Colors.white.withAlpha(26)),
                  ),
                  child: Text(
                    secondaryLabel!,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgramMetaRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProgramMetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withAlpha(158),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _NutritionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  const _NutritionField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withAlpha(117)),
        labelStyle: TextStyle(color: Colors.white.withAlpha(184)),
        filled: true,
        fillColor: Colors.white.withAlpha(15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withAlpha(26)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFF7DEBFF)),
        ),
      ),
    );
  }
}

class _NutritionProgram {
  final String athleteId;
  final String athleteName;
  final String monthLabel;
  final String title;
  final String pdfName;
  final String? pdfUrl;
  final String? notes;

  const _NutritionProgram({
    required this.athleteId,
    required this.athleteName,
    required this.monthLabel,
    required this.title,
    required this.pdfName,
    this.pdfUrl,
    this.notes,
  });
}
