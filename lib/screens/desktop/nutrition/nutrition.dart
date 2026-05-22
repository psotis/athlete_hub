import 'package:athlete_hub/helpers/imports.dart';

class NutritionDesktop extends StatefulWidget {
  const NutritionDesktop({super.key});

  @override
  State<NutritionDesktop> createState() => _NutritionDesktopState();
}

class _NutritionDesktopState extends State<NutritionDesktop> {
  final List<_DesktopNutritionProgram> _programs = [];
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
        _programs.add(
          _DesktopNutritionProgram(
            athleteId: user.id,
            athleteName: user.fullName,
            monthLabel: DateFormat('MMMM yyyy').format(DateTime.now()),
            title: 'Monthly Nutrition Program',
            pdfName:
                'nutrition_program_${DateFormat('MM_yyyy').format(DateTime.now())}.pdf',
            notes:
                'Your nutritionist or admin can attach your monthly nutrition PDF here.',
          ),
        );
      });
      return;
    }

    if (user.isNutritionist || user.isAdmin) {
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

  List<_DesktopNutritionProgram> get _customerPrograms {
    final user = _currentUser;
    if (user == null) return const [];
    return _programs.where((program) => program.athleteId == user.id).toList();
  }

  Future<void> _handleAddProgram() async {
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

    final created = await showDialog<_DesktopNutritionProgram>(
      context: context,
      builder: (context) {
        return _DesktopNutritionProgramDialog(customers: _customers);
      },
    );

    if (created == null || !mounted) return;
    setState(() {
      _programs.insert(0, created);
    });
  }

  Future<void> _openPdf(_DesktopNutritionProgram program) async {
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

    final canManage = user.isNutritionist || user.isAdmin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DesktopSurfaceCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  canManage
                      ? 'Monthly nutrition programs'
                      : 'Your nutrition program',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (canManage)
                FilledButton.icon(
                  onPressed: _handleAddProgram,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add program'),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBEAFE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Athlete view',
                    style: TextStyle(
                      color: Color(0xFF1D4ED8),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (canManage)
          _DesktopNutritionManagerView(
            programs: _programs,
            isLoadingCustomers: _isLoadingCustomers,
            customersError: _customersError,
            onRetry: _loadCustomers,
            onOpenProgram: _openPdf,
          )
        else
          _DesktopNutritionCustomerView(
            programs: _customerPrograms,
            onOpenProgram: _openPdf,
          ),
      ],
    );
  }
}

class _DesktopNutritionManagerView extends StatelessWidget {
  final List<_DesktopNutritionProgram> programs;
  final bool isLoadingCustomers;
  final String? customersError;
  final Future<void> Function() onRetry;
  final Future<void> Function(_DesktopNutritionProgram program) onOpenProgram;

  const _DesktopNutritionManagerView({
    required this.programs,
    required this.isLoadingCustomers,
    required this.customersError,
    required this.onRetry,
    required this.onOpenProgram,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DesktopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoadingCustomers)
                  const Center(child: CircularProgressIndicator())
                else if (customersError != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customersError!),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: onRetry,
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                else if (programs.isEmpty)
                  const Text('No nutrition programs added yet')
                else
                  ...programs.map(
                    (program) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DesktopNutritionProgramCard(
                        program: program,
                        onOpen: () => onOpenProgram(program),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopNutritionCustomerView extends StatelessWidget {
  final List<_DesktopNutritionProgram> programs;
  final Future<void> Function(_DesktopNutritionProgram program) onOpenProgram;

  const _DesktopNutritionCustomerView({
    required this.programs,
    required this.onOpenProgram,
  });

  @override
  Widget build(BuildContext context) {
    return DesktopSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (programs.isEmpty)
            const Text('No nutrition program assigned yet')
          else
            ...programs.map(
              (program) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DesktopNutritionProgramCard(
                  program: program,
                  onOpen: () => onOpenProgram(program),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DesktopNutritionProgramDialog extends StatefulWidget {
  final List<Users> customers;

  const _DesktopNutritionProgramDialog({required this.customers});

  @override
  State<_DesktopNutritionProgramDialog> createState() =>
      _DesktopNutritionProgramDialogState();
}

class _DesktopNutritionProgramDialogState
    extends State<_DesktopNutritionProgramDialog> {
  late Users _selectedAthlete;
  late final TextEditingController _searchCtrl;
  late final TextEditingController _monthCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _pdfNameCtrl;
  late final TextEditingController _pdfUrlCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _selectedAthlete = widget.customers.first;
    _searchCtrl = TextEditingController();
    _monthCtrl = TextEditingController(
      text: DateFormat('MMMM yyyy').format(DateTime.now()),
    );
    _titleCtrl = TextEditingController(text: 'Monthly Nutrition Program');
    _pdfNameCtrl = TextEditingController(text: 'nutrition_program.pdf');
    _pdfUrlCtrl = TextEditingController();
    _notesCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _monthCtrl.dispose();
    _titleCtrl.dispose();
    _pdfNameCtrl.dispose();
    _pdfUrlCtrl.dispose();
    _notesCtrl.dispose();
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

    return AlertDialog(
      title: const Text('Add Monthly Program'),
      content: SizedBox(
        width: 860,
        height: 460,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search athlete',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredCustomers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final athlete = filteredCustomers[index];
                        final selected = athlete.id == _selectedAthlete.id;

                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() {
                              _selectedAthlete = athlete;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFDBEAFE)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF93C5FD)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  athlete.fullName,
                                  style: const TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  athlete.email,
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                  ),
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
            const SizedBox(width: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _DesktopNutritionFormField(
                      controller: _monthCtrl,
                      label: 'Month',
                    ),
                    const SizedBox(height: 12),
                    _DesktopNutritionFormField(
                      controller: _titleCtrl,
                      label: 'Program title',
                    ),
                    const SizedBox(height: 12),
                    _DesktopNutritionFormField(
                      controller: _pdfNameCtrl,
                      label: 'PDF name',
                    ),
                    const SizedBox(height: 12),
                    _DesktopNutritionFormField(
                      controller: _pdfUrlCtrl,
                      label: 'PDF URL',
                    ),
                    const SizedBox(height: 12),
                    _DesktopNutritionFormField(
                      controller: _notesCtrl,
                      label: 'Notes',
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              _DesktopNutritionProgram(
                athleteId: _selectedAthlete.id,
                athleteName: _selectedAthlete.fullName,
                monthLabel: _monthCtrl.text.trim(),
                title: _titleCtrl.text.trim(),
                pdfName: _pdfNameCtrl.text.trim(),
                pdfUrl: _pdfUrlCtrl.text.trim().isEmpty
                    ? null
                    : _pdfUrlCtrl.text.trim(),
                notes: _notesCtrl.text.trim().isEmpty
                    ? null
                    : _notesCtrl.text.trim(),
              ),
            );
          },
          child: const Text('Save Program'),
        ),
      ],
    );
  }
}

class _DesktopNutritionProgramCard extends StatelessWidget {
  final _DesktopNutritionProgram program;
  final VoidCallback onOpen;

  const _DesktopNutritionProgramCard({
    required this.program,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.picture_as_pdf_outlined,
              color: Color(0xFF1D4ED8),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${program.athleteName} - ${program.monthLabel}',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 8),
                Text(
                  program.pdfName,
                  style: const TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if ((program.notes ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    program.notes!,
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: onOpen,
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Open PDF'),
          ),
        ],
      ),
    );
  }
}

class _DesktopNutritionFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const _DesktopNutritionFormField({
    required this.controller,
    required this.label,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _DesktopNutritionProgram {
  final String athleteId;
  final String athleteName;
  final String monthLabel;
  final String title;
  final String pdfName;
  final String? pdfUrl;
  final String? notes;

  const _DesktopNutritionProgram({
    required this.athleteId,
    required this.athleteName,
    required this.monthLabel,
    required this.title,
    required this.pdfName,
    this.pdfUrl,
    this.notes,
  });
}
