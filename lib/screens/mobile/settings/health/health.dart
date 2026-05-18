import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/blocs/medical/medical_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class HealthMobile extends StatefulWidget {
  final Users? selectedAthlete;

  const HealthMobile({super.key, this.selectedAthlete});

  @override
  State<HealthMobile> createState() => _HealthMobileState();
}

class _HealthMobileState extends State<HealthMobile> {
  String? athleteId;
  Users? athlete;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    athlete = widget.selectedAthlete;

    final authState = context.read<AuthBloc>().state;
    if (athlete != null) {
      athleteId = athlete!.id;
      context.read<MedicalCubit>().getMedicalPerUser(athlete!.id);
      return;
    }

    if (authState is AuthAuthenticated) {
      athlete = authState.user;
      athleteId = authState.user.id;
      context.read<MedicalCubit>().getMedicalPerUser(authState.user.id);
    }
  }

  String _medicalTypeLabel(int? type) {
    switch (type) {
      case 1:
        return 'Injury';
      case 2:
        return 'Surgery';
      case 3:
        return 'Condition';
      case 4:
        return 'Medication';
      case 5:
        return 'Other';
      default:
        return 'Unknown';
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    String athleteId,
    String id,
  ) async {
    final confirmed =
        await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete medical history'),
            content: const Text('Are you sure you want to delete this item?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;
    if (!mounted) return;

    final delete = context.read<MedicalCubit>();

    await delete.deleteMedical(athleteId: athleteId, id: id);
  }

  Future<void> _showMedicalForm(
    BuildContext context, {
    MedicalHistory? medical,
  }) async {
    final titleController = TextEditingController(text: medical?.title ?? '');
    final descriptionController = TextEditingController(
      text: medical?.description ?? '',
    );
    final startDateController = TextEditingController(
      text: medical?.startDate?.toIso8601String().split('T').first ?? '',
    );
    final endDateController = TextEditingController(
      text: medical?.endDate?.toIso8601String().split('T').first ?? '',
    );

    bool isActive = medical?.isActive ?? true;
    int itemType = medical?.itemType ?? 1;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medical == null
                          ? 'Add Medical History'
                          : 'Edit Medical History',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Medical Type',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),
                    IotDropdown2(
                      value: itemType,
                      onChanged: (p0) {
                        setModalState(() {
                          itemType = p0 ?? 1;
                        });
                      },
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Injury')),
                        DropdownMenuItem(value: 2, child: Text('Surgery')),
                        DropdownMenuItem(value: 3, child: Text('Condition')),
                        DropdownMenuItem(value: 4, child: Text('Medication')),
                        DropdownMenuItem(value: 5, child: Text('Other')),
                      ],
                    ),
                    // DropdownButtonFormField<int>(
                    //   value: itemType,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Medical Type',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: const [
                    //     DropdownMenuItem(value: 1, child: Text('Injury')),
                    //     DropdownMenuItem(value: 2, child: Text('Surgery')),
                    //     DropdownMenuItem(value: 3, child: Text('Condition')),
                    //     DropdownMenuItem(value: 4, child: Text('Medication')),
                    //     DropdownMenuItem(value: 5, child: Text('Other')),
                    //   ],
                    //   onChanged: (value) {
                    //     setModalState(() {
                    //       itemType = value ?? 1;
                    //     });
                    //   },
                    // ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: startDateController,
                      decoration: const InputDecoration(
                        labelText: 'Start Date (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: endDateController,
                      decoration: const InputDecoration(
                        labelText: 'End Date (YYYY-MM-DD)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isActive,
                      onChanged: (value) {
                        setModalState(() {
                          isActive = value;
                        });
                      },
                      title: const Text('Is Active'),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: athleteId == null
                            ? null
                            : () async {
                                if (medical == null) {
                                  await context
                                      .read<MedicalCubit>()
                                      .createMedical(
                                        athleteId: athleteId!,
                                        itemType: itemType,
                                        title: titleController.text.trim(),
                                        description: descriptionController.text
                                            .trim(),
                                        startDate: startDateController.text
                                            .trim(),
                                        endDate:
                                            endDateController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : endDateController.text.trim(),
                                        isActive: isActive,
                                      );
                                } else {
                                  await context
                                      .read<MedicalCubit>()
                                      .updateMedical(
                                        id: medical.id,
                                        athleteId: athleteId!,
                                        itemType: itemType,
                                        title: titleController.text.trim(),
                                        description: descriptionController.text
                                            .trim(),
                                        startDate: startDateController.text
                                            .trim(),
                                        endDate:
                                            endDateController.text
                                                .trim()
                                                .isEmpty
                                            ? null
                                            : endDateController.text.trim(),
                                        isActive: isActive,
                                      );
                                }

                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                        child: Text(medical == null ? 'Create' : 'Update'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MobileGlowScaffold(
      appBar: MobileScreenAppBar(
        title: athlete == null ? 'Medical History' : athlete!.fullName,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: athleteId == null ? null : () => _showMedicalForm(context),
        child: const Icon(Icons.add),
      ),
      child: SafeArea(
        child: BlocConsumer<MedicalCubit, MedicalState>(
          listener: (context, state) {
            if (state.actionMessage != null &&
                state.actionMessage!.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
              context.read<MedicalCubit>().clearActionState();
            }
          },
          builder: (context, state) {
            if (state.status == MedicalStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == MedicalStatus.failure) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }

            if (state.status == MedicalStatus.initial) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (athlete != null) ...[
                    MobilePageHeader(
                      title: athlete!.fullName,
                      subtitle:
                          'Full athlete details appear first, with medical history directly below.',
                    ),
                    const SizedBox(height: 12),
                    _AthleteDetailsCard(user: athlete!),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: state.data.isEmpty
                        ? const Center(child: Text('No medical history found'))
                        : ListView.separated(
                            itemCount: state.data.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final med = state.data[index];

                              return MobileGlassCard(
                                borderRadius: BorderRadius.circular(22),
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            med.title ?? '-',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: athleteId == null
                                              ? null
                                              : () => _showMedicalForm(
                                                  context,
                                                  medical: med,
                                                ),
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Color(0xFF7DEBFF),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _confirmDelete(
                                            context,
                                            med.athleteId,
                                            med.id,
                                          ),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFFF87171),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _HealthText(
                                      text: _medicalTypeLabel(med.itemType),
                                      strong: true,
                                    ),
                                    const SizedBox(height: 6),
                                    _HealthText(text: med.description ?? '-'),
                                    const SizedBox(height: 8),
                                    _HealthText(
                                      text:
                                          'Start: ${med.startDate?.toIso8601String().split('T').first ?? '-'}',
                                    ),
                                    _HealthText(
                                      text:
                                          'End: ${med.endDate?.toIso8601String().split('T').first ?? '-'}',
                                    ),
                                    _HealthText(
                                      text:
                                          'Active: ${med.isActive == true ? 'Yes' : 'No'}',
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AthleteDetailsCard extends StatelessWidget {
  final Users user;

  const _AthleteDetailsCard({required this.user});

  String _roleLabel() {
    if (user.isAdmin) return 'Admin';
    if (user.isNutritionist) return 'Nutritionist';
    if (user.isTrainer) return 'Trainer';
    return 'Customer';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MobileGlassCard(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user.fullName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _DetailRow(label: 'Email', value: user.email),
          _DetailRow(
            label: 'Phone',
            value: user.phone?.trim().isNotEmpty == true ? user.phone! : '-',
          ),
          _DetailRow(label: 'Role', value: _roleLabel()),
          _DetailRow(label: 'Birth Date', value: _formatDate(user.birthDate)),
          _DetailRow(
            label: 'Sport',
            value: user.sport?.trim().isNotEmpty == true ? user.sport! : '-',
          ),
          _DetailRow(
            label: 'Team',
            value: user.team?.trim().isNotEmpty == true ? user.team! : '-',
          ),
          _DetailRow(
            label: 'Status',
            value: user.isActive ? 'Active' : 'Inactive',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withAlpha(158),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthText extends StatelessWidget {
  final String text;
  final bool strong;

  const _HealthText({
    required this.text,
    this.strong = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: strong ? Colors.white : Colors.white.withAlpha(184),
        fontWeight: strong ? FontWeight.w600 : FontWeight.w400,
        height: 1.35,
      ),
    );
  }
}
