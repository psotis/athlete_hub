import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/blocs/medical/medical_state.dart';
import 'package:athlete_hub/blocs/profile_cubit/profile_state.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/utils/snackbars/snackbar.dart';

class ProfileMobile extends StatefulWidget {
  final Users? selectedUser;

  const ProfileMobile({super.key, this.selectedUser});

  @override
  State<ProfileMobile> createState() => _ProfileMobileState();
}

class _ProfileMobileState extends State<ProfileMobile> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _sportCtrl;
  late final TextEditingController _teamCtrl;
  late final TextEditingController _birthDateCtrl;

  bool _isEditing = false;
  DateTime? _selectedBirthDate;
  Users? _profileUser;

  bool get _isAdminViewingAthlete =>
      context.isAdmin && widget.selectedUser != null;

  String? get _athleteId => (_profileUser ?? widget.selectedUser)?.id;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _sportCtrl = TextEditingController();
    _teamCtrl = TextEditingController();
    _birthDateCtrl = TextEditingController();
    _profileUser = widget.selectedUser;
    if (widget.selectedUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<MedicalCubit>().getMedicalPerUser(widget.selectedUser!.id);
      });
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _sportCtrl.dispose();
    _teamCtrl.dispose();
    _birthDateCtrl.dispose();
    super.dispose();
  }

  void _fillControllers(Users user) {
    _firstNameCtrl.text = user.firstName;
    _lastNameCtrl.text = user.lastName;
    _emailCtrl.text = user.email;
    _phoneCtrl.text = user.phone ?? '';
    _sportCtrl.text = user.sport ?? '';
    _teamCtrl.text = user.team ?? '';
    _selectedBirthDate = user.birthDate;
    _birthDateCtrl.text = _formatDate(user.birthDate);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initialDate =
        _selectedBirthDate ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateCtrl.text = _formatDate(picked);
      });
    }
  }

  void _startEditing(Users user) {
    _fillControllers(user);
    setState(() => _isEditing = true);
  }

  void _cancelEditing(Users user) {
    _fillControllers(user);
    setState(() => _isEditing = false);
  }

  String _roleLabel(Users user) {
    if (user.isAdmin) return 'Admin';
    if (user.isNutritionist) return 'Nutritionist';
    if (user.isTrainer) return 'Trainer';
    return 'Customer';
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

  Future<void> _confirmDeleteMedical(String athleteId, String id) async {
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
    await context.read<MedicalCubit>().deleteMedical(athleteId: athleteId, id: id);
  }

  Future<void> _showMedicalForm({MedicalHistory? medical}) async {
    final athleteId = _athleteId;
    if (athleteId == null) return;

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
                      onChanged: (value) {
                        setModalState(() {
                          itemType = value ?? 1;
                        });
                      },
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('Injury')),
                        DropdownMenuItem(value: 2, child: Text('Surgery')),
                        DropdownMenuItem(value: 3, child: Text('Condition')),
                        DropdownMenuItem(value: 4, child: Text('Medication')),
                        DropdownMenuItem(value: 5, child: Text('Other')),
                      ],
                    ),
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
                        onPressed: () async {
                          if (medical == null) {
                            await context.read<MedicalCubit>().createMedical(
                              athleteId: athleteId,
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
                              athleteId: athleteId,
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
    final currentUser = context.currentUser;
    final user = _profileUser ?? currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isEditing && _firstNameCtrl.text.isEmpty) {
      _fillControllers(user);
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccess) {
              final isCurrentUser = currentUser?.id == state.user.id;
              if (isCurrentUser) {
                context.read<AuthBloc>().add(AuthUserUpdated(state.user));
              }

              setState(() {
                _profileUser = state.user;
                _isEditing = false;
              });
              IotSnackbar.show(context, 'Profile updated successfully');
            } else if (state is ProfileUpdateFailure) {
              IotSnackbar.show(context, state.message);
            }
          },
        ),
        BlocListener<MedicalCubit, MedicalState>(
          listener: (context, state) {
            if (state.actionMessage != null && state.actionMessage!.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
              context.read<MedicalCubit>().clearActionState();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(_isAdminViewingAthlete ? 'Athlete Profile' : 'Profile'),
          centerTitle: true,
          actions: [
            if (!_isEditing)
              IconButton(
                onPressed: () => _startEditing(user),
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileHeader(
                    fullName: user.fullName,
                    email: user.email,
                    role: _roleLabel(user),
                    isActive: user.isActive,
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    title: 'Personal Information',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ProfileField(
                                controller: _firstNameCtrl,
                                label: 'First name',
                                enabled: _isEditing,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ProfileField(
                                controller: _lastNameCtrl,
                                label: 'Last name',
                                enabled: _isEditing,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          controller: _emailCtrl,
                          label: 'Email',
                          enabled: _isEditing,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            if (!value.contains('@')) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          controller: _phoneCtrl,
                          label: 'Phone',
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _birthDateCtrl,
                          readOnly: true,
                          enabled: _isEditing,
                          onTap: _isEditing ? _pickBirthDate : null,
                          decoration: const InputDecoration(
                            labelText: 'Birth date',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    title: 'Sports Information',
                    child: Column(
                      children: [
                        ProfileField(
                          controller: _sportCtrl,
                          label: 'Sport',
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 12),
                        ProfileField(
                          controller: _teamCtrl,
                          label: 'Team',
                          enabled: _isEditing,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    title: 'Account Info',
                    child: Column(
                      children: [
                        InfoRow(label: 'User ID', value: user.id),
                        const SizedBox(height: 10),
                        InfoRow(
                          label: 'User Type',
                          value: user.userType.toString(),
                        ),
                        const SizedBox(height: 10),
                        InfoRow(
                          label: 'Birth Date',
                          value:
                              user.birthDate
                                  ?.toIso8601String()
                                  .split('T')
                                  .first ??
                              '-',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_isEditing)
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        final isSaving = state is ProfileUpdateLoading;

                        return Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: isSaving
                                    ? null
                                    : () => _cancelEditing(user),
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isSaving
                                    ? null
                                    : () {
                                        if (!(_formKey.currentState
                                                ?.validate() ??
                                            false)) {
                                          return;
                                        }

                                        context
                                            .read<ProfileCubit>()
                                            .updateProfile(
                                              userId: user.id,
                                              firstName: _firstNameCtrl.text
                                                  .trim(),
                                              lastName: _lastNameCtrl.text
                                                  .trim(),
                                              email: _emailCtrl.text.trim(),
                                              phone:
                                                  _phoneCtrl.text.trim().isEmpty
                                                  ? null
                                                  : _phoneCtrl.text.trim(),
                                              sport:
                                                  _sportCtrl.text.trim().isEmpty
                                                  ? null
                                                  : _sportCtrl.text.trim(),
                                              team:
                                                  _teamCtrl.text.trim().isEmpty
                                                  ? null
                                                  : _teamCtrl.text.trim(),
                                              birthDate: _selectedBirthDate,
                                            );
                                      },
                                child: isSaving
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text('Save'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  if (_isAdminViewingAthlete) ...[
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Medical History',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: _athleteId == null
                              ? null
                              : () => _showMedicalForm(),
                          icon: const Icon(Icons.add),
                          tooltip: 'Add medical history',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<MedicalCubit, MedicalState>(
                      builder: (context, state) {
                        if (state.status == MedicalStatus.loading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state.status == MedicalStatus.failure) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              state.errorMessage ?? 'Something went wrong',
                            ),
                          );
                        }

                        if (state.data.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text('No medical history found'),
                          );
                        }

                        return Column(
                          children: state.data.map((med) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Card(
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
                                          onPressed: () =>
                                              _showMedicalForm(medical: med),
                                          icon: const Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: _athleteId == null
                                              ? null
                                              : () => _confirmDeleteMedical(
                                                  _athleteId!,
                                                  med.id,
                                                ),
                                          icon: const Icon(Icons.delete),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
