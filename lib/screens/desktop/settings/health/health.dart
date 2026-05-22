import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/blocs/medical/medical_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class HealthDesktop extends StatefulWidget {
  const HealthDesktop({super.key});

  @override
  State<HealthDesktop> createState() => _HealthDesktopState();
}

class _HealthDesktopState extends State<HealthDesktop> {
  String? _athleteId;
  Users? _athlete;

  @override
  void initState() {
    super.initState();
    final user = context.currentUserRead;
    _athlete = user;
    _athleteId = user?.id;

    if (_athleteId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<MedicalCubit>().getMedicalPerUser(_athleteId!);
      });
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

  Future<void> _showMedicalForm({MedicalHistory? medical}) async {
    if (_athleteId == null) return;

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
    var isActive = medical?.isActive ?? true;
    var itemType = medical?.itemType ?? 1;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(
                medical == null ? 'Add Medical History' : 'Edit Medical History',
              ),
              content: SizedBox(
                width: 560,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<int>(
                        value: itemType,
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Injury')),
                          DropdownMenuItem(value: 2, child: Text('Surgery')),
                          DropdownMenuItem(value: 3, child: Text('Condition')),
                          DropdownMenuItem(value: 4, child: Text('Medication')),
                          DropdownMenuItem(value: 5, child: Text('Other')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Medical type',
                        ),
                        onChanged: (value) {
                          setModalState(() {
                            itemType = value ?? 1;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: startDateController,
                        decoration: const InputDecoration(
                          labelText: 'Start Date (YYYY-MM-DD)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: endDateController,
                        decoration: const InputDecoration(
                          labelText: 'End Date (YYYY-MM-DD)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Is active'),
                        value: isActive,
                        onChanged: (value) {
                          setModalState(() {
                            isActive = value;
                          });
                        },
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
                ElevatedButton(
                  onPressed: () async {
                    if (medical == null) {
                      await context.read<MedicalCubit>().createMedical(
                        athleteId: _athleteId!,
                        itemType: itemType,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        startDate: startDateController.text.trim(),
                        endDate: endDateController.text.trim().isEmpty
                            ? null
                            : endDateController.text.trim(),
                        isActive: isActive,
                      );
                    } else {
                      await context.read<MedicalCubit>().updateMedical(
                        id: medical.id,
                        athleteId: _athleteId!,
                        itemType: itemType,
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        startDate: startDateController.text.trim(),
                        endDate: endDateController.text.trim().isEmpty
                            ? null
                            : endDateController.text.trim(),
                        isActive: isActive,
                      );
                    }

                    if (context.mounted) {
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: Text(medical == null ? 'Create' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(String id) async {
    if (_athleteId == null) return;

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

    if (!confirmed || !mounted) return;
    await context.read<MedicalCubit>().deleteMedical(
      athleteId: _athleteId!,
      id: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_athlete == null) {
      return const Center(child: Text('No user found'));
    }

    return BlocListener<MedicalCubit, MedicalState>(
      listener: (context, state) {
        if (state.actionMessage != null && state.actionMessage!.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
          context.read<MedicalCubit>().clearActionState();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DesktopSurfaceCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.favorite_outline_rounded,
                      color: Color(0xFF1D4ED8),
                      size: 34,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Health',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFF0F172A),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => _showMedicalForm(),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add item'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DesktopSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<MedicalCubit, MedicalState>(
                    builder: (context, state) {
                      if (state.status == MedicalStatus.loading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (state.status == MedicalStatus.failure) {
                        return Text(
                          state.errorMessage ?? 'Something went wrong',
                          style: const TextStyle(color: Color(0xFF0F172A)),
                        );
                      }

                      if (state.data.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('No medical history found'),
                        );
                      }

                      return Column(
                        children: state.data.map((item) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title ?? '-',
                                        style: const TextStyle(
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _showMedicalForm(
                                        medical: item,
                                      ),
                                      icon: const Icon(Icons.edit_outlined),
                                    ),
                                    IconButton(
                                      onPressed: () => _confirmDelete(item.id),
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: Color(0xFFB91C1C),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _medicalTypeLabel(item.itemType),
                                  style: const TextStyle(
                                    color: Color(0xFF1D4ED8),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.description ?? '-',
                                  style: const TextStyle(
                                    color: Color(0xFF475569),
                                    height: 1.45,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 8,
                                  children: [
                                    Text(
                                      'Start: ${item.startDate?.toIso8601String().split('T').first ?? '-'}',
                                    ),
                                    Text(
                                      'End: ${item.endDate?.toIso8601String().split('T').first ?? '-'}',
                                    ),
                                    Text(
                                      'Active: ${item.isActive == true ? 'Yes' : 'No'}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
