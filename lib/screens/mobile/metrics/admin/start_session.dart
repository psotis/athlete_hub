import 'package:athlete_hub/blocs/exports.dart';
import 'package:athlete_hub/blocs/session/session_state.dart';
import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/utils/dialogs/dialog.dart';

class StartSessionMobile extends StatefulWidget {
  final List<Users> users;
  const StartSessionMobile({super.key, required this.users});

  @override
  State<StartSessionMobile> createState() => _StartSessionMobileState();
}

class _StartSessionMobileState extends State<StartSessionMobile> {
  bool _isBatchStarting = false;

  List<_SessionStarterOption> get _options {
    final athletes = widget.users
        .map((user) => _SessionStarterOption.athlete(user))
        .toList();

    final teams = <_SessionStarterOption>[];
    final grouped = <String, List<Users>>{};

    for (final user in widget.users) {
      final team = user.team?.trim();
      if (team == null || team.isEmpty) continue;
      grouped.putIfAbsent(team, () => []).add(user);
    }

    final sortedTeams = grouped.keys.toList()..sort();
    for (final team in sortedTeams) {
      teams.add(_SessionStarterOption.team(team, grouped[team]!));
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

  Future<void> _handleTeamOption(_SessionStarterOption option) async {
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
          builder: (_) => TeamBatchSessionPage(
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

  Future<List<_TeamAthleteSelection>?> _showTeamSelectionSheet(
    _SessionStarterOption option,
  ) {
    final selections = option.members
        .map(
          (user) => _TeamAthleteSelection(
            athlete: user,
            isSelected: false,
            categories: <ErgometricsEntryCategory>{},
          ),
        )
        .toList();

    return showModalBottomSheet<List<_TeamAthleteSelection>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      option.teamName ?? 'Select team athletes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose the athletes and the ergometrics you want to start for each one.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Flexible(
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
                                    title: Text(selection.athlete.fullName),
                                    subtitle:
                                        (selection.athlete.sport ?? '').isEmpty
                                        ? null
                                        : Text(selection.athlete.sport!),
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
                                            final isSelected = selection
                                                .categories
                                                .contains(category);

                                            return FilterChip(
                                              label: Text(category.label),
                                              selected: isSelected,
                                              onSelected: (value) {
                                                setModalState(() {
                                                  if (value) {
                                                    selection.categories.add(
                                                      category,
                                                    );
                                                  } else {
                                                    selection.categories
                                                        .remove(category);
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
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
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

                          Navigator.pop(context, selected);
                        },
                        child: const Text('Continue'),
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

  Future<void> _onOptionSelected(String? value) async {
    if (value == null) return;

    final option = _options.firstWhere((element) => element.key == value);

    if (option.isTeam) {
      await _handleTeamOption(option);
      return;
    }

    await _startSingleAthleteSession(option.athlete!);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 5,
        children: [
          Text(
            'Pick a customer or team to start a session',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (_isBatchStarting)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(),
            ),
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              final selectedId =
                  widget.users.any((e) => e.id == state.selectedUser?.id)
                  ? state.selectedUser?.id
                  : null;

              final currentValue = selectedId == null
                  ? null
                  : 'athlete:$selectedId';

              return IotDropdown2<String>(
                buttonWidth: MediaQuery.of(context).size.width * .9,
                value: currentValue,
                hintText: 'Select athlete or team',
                enableSearch: true,
                searchHintText: 'Search athlete or team...',
                itemAsString: (key) {
                  try {
                    return _options
                        .firstWhere((option) => option.key == key)
                        .displayLabel;
                  } catch (_) {
                    return '';
                  }
                },
                items: _options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option.key,
                    child: Text(
                      option.displayLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: _isBatchStarting ? null : _onOptionSelected,
              );
            },
          ),
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              if (state.status == SessionStatus.failure) {
                return Text(state.errorMessage!);
              }

              if (state.status == SessionStatus.success) {
                return Expanded(
                  child: SessionEntriesMobile(
                    sessionId: state.session.id,
                    athlete: state.selectedUser!,
                  ),
                );
              }
              return const Text('Waiting to start....');
            },
          ),
        ],
      ),
    );
  }
}

class _SessionStarterOption {
  final String key;
  final Users? athlete;
  final String? teamName;
  final List<Users> members;

  const _SessionStarterOption._({
    required this.key,
    this.athlete,
    this.teamName,
    this.members = const [],
  });

  factory _SessionStarterOption.athlete(Users user) {
    return _SessionStarterOption._(key: 'athlete:${user.id}', athlete: user);
  }

  factory _SessionStarterOption.team(String teamName, List<Users> members) {
    return _SessionStarterOption._(
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

class _TeamAthleteSelection {
  final Users athlete;
  bool isSelected;
  Set<ErgometricsEntryCategory> categories;

  _TeamAthleteSelection({
    required this.athlete,
    required this.isSelected,
    required this.categories,
  });
}
