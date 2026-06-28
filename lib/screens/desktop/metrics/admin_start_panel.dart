import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/blocs/session/session_state.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/screens/desktop/metrics/session_entries_workspace.dart';
import 'package:athlete_hub/utils/dialogs/dialog.dart';

class DesktopAdminMetricsStartPanel extends StatefulWidget {
  final List<Users> users;

  const DesktopAdminMetricsStartPanel({super.key, required this.users});

  @override
  State<DesktopAdminMetricsStartPanel> createState() =>
      _DesktopAdminMetricsStartPanelState();
}

class _DesktopAdminMetricsStartPanelState
    extends State<DesktopAdminMetricsStartPanel> {
  bool _isBatchStarting = false;
  String? _selectedOptionKey;

  List<_DesktopSessionStarterOption> get _options {
    final athletes = widget.users
        .map((user) => _DesktopSessionStarterOption.athlete(user))
        .toList();

    final teams = <_DesktopSessionStarterOption>[];
    final grouped = <String, List<Users>>{};

    for (final user in widget.users) {
      final team = user.team?.trim();
      if (team == null || team.isEmpty) continue;
      grouped.putIfAbsent(team, () => []).add(user);
    }

    final sortedTeams = grouped.keys.toList()..sort();
    for (final team in sortedTeams) {
      teams.add(_DesktopSessionStarterOption.team(team, grouped[team]!));
    }

    return [...athletes, ...teams];
  }

  Future<void> _startSingleAthleteSession(Users user) async {
    IotDialog.show(
      context,
      title: 'Caution',
      content: Text(
        'Are you sure you want to start a session for ${user.fullName}?',
      ),
      cancelText: 'No',
      confirmText: 'Yes',
      onConfirm: () {
        context.read<SessionCubit>().startSession(
          user,
          context.currentUserRead!.id,
        );
      },
    );
  }

  Future<void> _handleTeamOption(_DesktopSessionStarterOption option) async {
    final selections = await _showTeamSelectionSheet(option);
    if (!mounted || selections == null || selections.isEmpty) return;

    setState(() => _isBatchStarting = true);

    final repository = context.read<SessionRepository>();
    final createdConfigs = <BatchSessionAthleteConfig>[];

    try {
      for (final selection in selections) {
        final session = await repository.startSession(
          selection.athlete.id,
          context.currentUserRead!.id,
        );

        createdConfigs.add(
          BatchSessionAthleteConfig(
            athlete: selection.athlete,
            sessionId: session.id,
            categories: selection.categories,
          ),
        );
      }

      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DesktopTeamBatchSessionPage(
            teamName: option.teamName!,
            configs: createdConfigs,
          ),
        ),
      );
    } catch (e) {
      for (final config in createdConfigs) {
        try {
          await repository.deleteSession(config.sessionId);
        } catch (_) {}
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team session setup failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isBatchStarting = false);
      }
    }
  }

  Future<List<_DesktopTeamAthleteSelection>?> _showTeamSelectionSheet(
    _DesktopSessionStarterOption option,
  ) {
    final selections = option.members
        .map(
          (user) => _DesktopTeamAthleteSelection(
            athlete: user,
            isSelected: false,
            categories: <ErgometricsEntryCategory>{},
          ),
        )
        .toList();

    return showDialog<List<_DesktopTeamAthleteSelection>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(option.teamName ?? 'Select team athletes'),
              content: SizedBox(
                width: 760,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: selections.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final selection = selections[index];

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              value: selection.isSelected,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                selection.athlete.fullName,
                                style: const TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: (selection.athlete.sport ?? '').isEmpty
                                  ? null
                                  : Text(
                                      selection.athlete.sport!,
                                      style: const TextStyle(
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                              onChanged: (value) {
                                setModalState(() {
                                  selection.isSelected = value ?? false;
                                  if (selection.isSelected &&
                                      selection.categories.isEmpty) {
                                    selection.categories = ErgometricsEntryCategory
                                        .values
                                        .toSet();
                                  }
                                });
                              },
                            ),
                            if (selection.isSelected) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ErgometricsEntryCategory.values
                                    .map((category) {
                                      final isSelected = selection.categories
                                          .contains(category);

                                      return FilterChip(
                                        label: Text(category.label),
                                        selected: isSelected,
                                        onSelected: (value) {
                                          setModalState(() {
                                            if (value) {
                                              selection.categories.add(category);
                                            } else {
                                              selection.categories.remove(
                                                category,
                                              );
                                            }
                                          });
                                        },
                                      );
                                    })
                                    .toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final selected = selections
                        .where((item) => item.isSelected)
                        .toList();

                    if (selected.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Select at least one athlete'),
                        ),
                      );
                      return;
                    }

                    final hasEmptyCategorySelection = selected.any(
                      (item) => item.categories.isEmpty,
                    );

                    if (hasEmptyCategorySelection) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Choose at least one ergometric for every selected athlete',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(dialogContext, selected);
                  },
                  child: const Text('Continue'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _onOptionSelected(String? value) async {
    if (value == null) return;

    setState(() {
      _selectedOptionKey = value;
    });

    final option = _options.firstWhere((element) => element.key == value);

    if (option.isTeam) {
      await _handleTeamOption(option);
      return;
    }

    await _startSingleAthleteSession(option.athlete!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isBatchStarting)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(),
          ),
        DropdownButtonFormField<String>(
          value: _selectedOptionKey,
          style: const TextStyle(color: Color(0xFF0F172A)),
          decoration: const InputDecoration(
            labelText: 'Select athlete or team',
            labelStyle: TextStyle(color: Color(0xFF475569)),
            floatingLabelStyle: TextStyle(color: Color(0xFF334155)),
          ),
          items: _options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option.key,
                  child: Text(
                    option.displayLabel,
                    style: const TextStyle(color: Color(0xFF0F172A)),
                  ),
                ),
              )
              .toList(),
          onChanged: _isBatchStarting ? null : _onOptionSelected,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              if (state.status == SessionStatus.failure) {
                return Center(child: Text(state.errorMessage ?? '-'));
              }

              if (state.status == SessionStatus.success) {
                return DesktopSessionEntriesWorkspace(
                  sessionId: state.session.id,
                  athlete: state.selectedUser!,
                );
              }

              return const Center(
                child: Text('Waiting to start a session...'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DesktopSessionStarterOption {
  final String key;
  final Users? athlete;
  final String? teamName;
  final List<Users> members;

  const _DesktopSessionStarterOption._({
    required this.key,
    this.athlete,
    this.teamName,
    this.members = const [],
  });

  factory _DesktopSessionStarterOption.athlete(Users user) {
    return _DesktopSessionStarterOption._(
      key: 'athlete:${user.id}',
      athlete: user,
    );
  }

  factory _DesktopSessionStarterOption.team(String teamName, List<Users> members) {
    return _DesktopSessionStarterOption._(
      key: 'team:$teamName',
      teamName: teamName,
      members: members,
    );
  }

  bool get isTeam => teamName != null;

  String get displayLabel {
    if (isTeam) {
      return 'Team: $teamName (${members.length} athletes)';
    }

    final team = athlete?.team?.trim();
    if (team == null || team.isEmpty) return athlete?.fullName ?? '';
    return '${athlete?.fullName} - $team';
  }
}

class _DesktopTeamAthleteSelection {
  final Users athlete;
  bool isSelected;
  Set<ErgometricsEntryCategory> categories;

  _DesktopTeamAthleteSelection({
    required this.athlete,
    required this.isSelected,
    required this.categories,
  });
}
