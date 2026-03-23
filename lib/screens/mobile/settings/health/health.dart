import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/blocs/medical/medical_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class HealthMobile extends StatefulWidget {
  const HealthMobile({super.key});

  @override
  State<HealthMobile> createState() => _HealthMobileState();
}

class _HealthMobileState extends State<HealthMobile> {
  String? athleteId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Medical History',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: athleteId == null ? null : () => _showMedicalForm(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: state.data.isEmpty
                        ? const Center(child: Text('No medical history found'))
                        : ListView.separated(
                            itemCount: state.data.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final med = state.data[index];

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    title: Text(med.title ?? '-'),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 6),
                                        Text(_medicalTypeLabel(med.itemType)),
                                        const SizedBox(height: 4),
                                        Text(med.description ?? '-'),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Start: ${med.startDate?.toIso8601String().split('T').first ?? '-'}',
                                        ),
                                        Text(
                                          'End: ${med.endDate?.toIso8601String().split('T').first ?? '-'}',
                                        ),
                                        Text(
                                          'Active: ${med.isActive == true ? 'Yes' : 'No'}',
                                        ),
                                      ],
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: athleteId == null
                                              ? null
                                              : () => _showMedicalForm(
                                                  context,
                                                  medical: med,
                                                ),
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () => _confirmDelete(
                                            context,
                                            med.athleteId,
                                            med.id,
                                          ),
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
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
