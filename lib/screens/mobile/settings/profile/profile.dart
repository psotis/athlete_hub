import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/blocs/profile_cubit/profile_state.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/utils/snackbars/snackbar.dart';

class ProfileMobile extends StatefulWidget {
  const ProfileMobile({super.key});

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

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isEditing && _firstNameCtrl.text.isEmpty) {
      _fillControllers(user);
    }

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccess) {
          context.read<AuthBloc>().add(AuthUserUpdated(state.user));
          setState(() => _isEditing = false);
          IotSnackbar.show(context, 'Profile updated successfully');
        } else if (state is ProfileUpdateFailure) {
          IotSnackbar.show(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text('Profile'),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
