import 'package:athlete_hub/blocs/auth/auth_bloc.dart';
import 'package:athlete_hub/blocs/medical/medical_cubit.dart';
import 'package:athlete_hub/blocs/medical/medical_state.dart';
import 'package:athlete_hub/blocs/profile_cubit/profile_cubit.dart';
import 'package:athlete_hub/blocs/profile_cubit/profile_state.dart';
import 'package:athlete_hub/helpers/imports.dart';

class ProfileDesktop extends StatefulWidget {
  final Users? selectedUser;

  const ProfileDesktop({super.key, this.selectedUser});

  @override
  State<ProfileDesktop> createState() => _ProfileDesktopState();
}

class _ProfileDesktopState extends State<ProfileDesktop> {
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

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(
                medical == null
                    ? 'Add Medical History'
                    : 'Edit Medical History',
              ),
              content: SizedBox(
                width: 520,
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
                        onChanged: (value) {
                          setModalState(() {
                            itemType = value ?? 1;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Medical Type',
                        ),
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
                        value: isActive,
                        onChanged: (value) {
                          setModalState(() {
                            isActive = value;
                          });
                        },
                        title: const Text('Is Active'),
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
    await context.read<MedicalCubit>().deleteMedical(
      athleteId: athleteId,
      id: id,
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully')),
              );
            } else if (state is ProfileUpdateFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
        BlocListener<MedicalCubit, MedicalState>(
          listener: (context, state) {
            if (state.actionMessage != null &&
                state.actionMessage!.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.actionMessage!)));
              context.read<MedicalCubit>().clearActionState();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F7FB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: const Color(0xFF0F172A),
          title: Text(_isAdminViewingAthlete ? 'Athlete Profile' : 'Profile'),
          actions: [
            if (!_isEditing)
              IconButton(
                onPressed: () => setState(() => _isEditing = true),
                icon: const Icon(Icons.edit_outlined),
              ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DesktopSurfaceCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: const Color(0xFFDBEAFE),
                            child: Text(
                              user.firstName.isNotEmpty
                                  ? user.firstName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D4ED8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isAdminViewingAthlete
                                      ? user.fullName
                                      : 'My Profile',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: const Color(0xFF0F172A),
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _isAdminViewingAthlete
                                      ? 'View the full athlete profile, edit details and manage medical history below.'
                                      : 'Update your personal and sports information from a proper desktop profile screen.',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: const Color(0xFF475569),
                                        height: 1.45,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: user.isActive
                                  ? const Color(0xFFDCFCE7)
                                  : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              user.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: user.isActive
                                    ? const Color(0xFF166534)
                                    : const Color(0xFFB91C1C),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: DesktopSurfaceCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const DesktopSectionTitle(
                                  title: 'Personal Information',
                                  subtitle:
                                      'Keep the core profile fields up to date.',
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _DesktopProfileField(
                                        controller: _firstNameCtrl,
                                        label: 'First name',
                                        enabled: _isEditing,
                                        validator: (value) =>
                                            (value == null ||
                                                value.trim().isEmpty)
                                            ? 'Required'
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _DesktopProfileField(
                                        controller: _lastNameCtrl,
                                        label: 'Last name',
                                        enabled: _isEditing,
                                        validator: (value) =>
                                            (value == null ||
                                                value.trim().isEmpty)
                                            ? 'Required'
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _DesktopProfileField(
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
                                _DesktopProfileField(
                                  controller: _phoneCtrl,
                                  label: 'Phone',
                                  enabled: _isEditing,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: _isEditing ? _pickBirthDate : null,
                                  child: AbsorbPointer(
                                    child: _DesktopProfileField(
                                      controller: _birthDateCtrl,
                                      label: 'Birth date',
                                      enabled: _isEditing,
                                      suffixIcon: const Icon(
                                        Icons.calendar_today_outlined,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _DesktopProfileField(
                                        controller: _sportCtrl,
                                        label: 'Sport',
                                        enabled: _isEditing,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _DesktopProfileField(
                                        controller: _teamCtrl,
                                        label: 'Team',
                                        enabled: _isEditing,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, state) {
                                    final isSaving =
                                        state is ProfileUpdateLoading;

                                    return Row(
                                      children: [
                                        if (_isEditing) ...[
                                          OutlinedButton(
                                            onPressed: isSaving
                                                ? null
                                                : () {
                                                    _fillControllers(user);
                                                    setState(() {
                                                      _isEditing = false;
                                                    });
                                                  },
                                            child: const Text('Cancel'),
                                          ),
                                          const SizedBox(width: 12),
                                          ElevatedButton(
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
                                                          firstName:
                                                              _firstNameCtrl
                                                                  .text
                                                                  .trim(),
                                                          lastName:
                                                              _lastNameCtrl.text
                                                                  .trim(),
                                                          email: _emailCtrl.text
                                                              .trim(),
                                                          phone:
                                                              _phoneCtrl.text
                                                                  .trim()
                                                                  .isEmpty
                                                              ? null
                                                              : _phoneCtrl.text
                                                                    .trim(),
                                                          sport:
                                                              _sportCtrl.text
                                                                  .trim()
                                                                  .isEmpty
                                                              ? null
                                                              : _sportCtrl.text
                                                                    .trim(),
                                                          team:
                                                              _teamCtrl.text
                                                                  .trim()
                                                                  .isEmpty
                                                              ? null
                                                              : _teamCtrl.text
                                                                    .trim(),
                                                          birthDate:
                                                              _selectedBirthDate,
                                                        );
                                                  },
                                            child: isSaving
                                                ? const SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : const Text('Save changes'),
                                          ),
                                        ] else
                                          FilledButton.icon(
                                            onPressed: () => setState(() {
                                              _isEditing = true;
                                            }),
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                            ),
                                            label: const Text('Edit profile'),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: DesktopSurfaceCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const DesktopSectionTitle(
                                  title: 'Account Snapshot',
                                  subtitle:
                                      'Quick profile context for desktop.',
                                ),
                                const SizedBox(height: 18),
                                _DesktopInfoLine(
                                  label: 'Role',
                                  value: _roleLabel(user),
                                ),
                                _DesktopInfoLine(
                                  label: 'User ID',
                                  value: user.id,
                                ),
                                _DesktopInfoLine(
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
                        ),
                      ],
                    ),
                    if (_isAdminViewingAthlete) ...[
                      const SizedBox(height: 20),
                      DesktopSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  child: DesktopSectionTitle(
                                    title: 'Medical History',
                                    subtitle:
                                        'Review, add and edit athlete medical history.',
                                  ),
                                ),
                                FilledButton.icon(
                                  onPressed: _athleteId == null
                                      ? null
                                      : () => _showMedicalForm(),
                                  icon: const Icon(Icons.add_rounded),
                                  label: const Text('Add item'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            BlocBuilder<MedicalCubit, MedicalState>(
                              builder: (context, state) {
                                if (state.status == MedicalStatus.loading) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                if (state.status == MedicalStatus.failure) {
                                  return Text(
                                    state.errorMessage ??
                                        'Something went wrong',
                                  );
                                }

                                if (state.data.isEmpty) {
                                  return const Text('No medical history found');
                                }

                                return Column(
                                  children: state.data.map((med) {
                                    return Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(18),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                          0xFF0F172A,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () =>
                                                    _showMedicalForm(
                                                      medical: med,
                                                    ),
                                                icon: const Icon(Icons.edit),
                                              ),
                                              IconButton(
                                                onPressed: _athleteId == null
                                                    ? null
                                                    : () =>
                                                          _confirmDeleteMedical(
                                                            _athleteId!,
                                                            med.id,
                                                          ),
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Color(0xFFB91C1C),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            _medicalTypeLabel(med.itemType),
                                            style: const TextStyle(
                                              color: Color(0xFF1D4ED8),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(med.description ?? '-'),
                                          const SizedBox(height: 8),
                                          Wrap(
                                            spacing: 16,
                                            runSpacing: 8,
                                            children: [
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopProfileField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const _DesktopProfileField({
    required this.controller,
    required this.label,
    required this.enabled,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(labelText: label, suffixIcon: suffixIcon),
    );
  }
}

class _DesktopInfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _DesktopInfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
