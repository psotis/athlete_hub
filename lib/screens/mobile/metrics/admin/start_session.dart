// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 5,
        children: [
          Text(
            'Pick a customer to start a session',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              final selectedId =
                  widget.users.any((e) => e.id == state.selectedUser?.id)
                  ? state.selectedUser?.id
                  : null;

              if (state.status == SessionStatus.failure) {
                return Text(state.errorMessage!);
              }

              return IotDropdown2<String>(
                buttonWidth: MediaQuery.of(context).size.width * .9,
                value: selectedId,
                hintText: 'Select athlete',
                enableSearch: true,
                searchHintText: 'Search athlete...',
                itemAsString: (id) {
                  try {
                    return widget.users.firstWhere((e) => e.id == id).fullName;
                  } catch (_) {
                    return '';
                  }
                },
                items: widget.users.map((e) {
                  return DropdownMenuItem<String>(
                    value: e.id,
                    child: Text(e.fullName),
                  );
                }).toList(),
                onChanged: (value) {
                  IotDialog.show(
                    context,
                    title: 'Caution',
                    content: Text(
                      'Are you sure you want to start a session for ${widget.users.firstWhere((e) => e.id == value).fullName}',
                    ),
                    cancelText: 'No',
                    confirmText: 'Yes ',
                    onConfirm: () {
                      if (value == null) return;
                      final selectedUser = widget.users.firstWhere(
                        (e) => e.id == value,
                      );
                      context.read<SessionCubit>().startSession(
                        selectedUser,
                        context.currentUserRead!.id,
                      );
                    },
                  );
                },
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
              return Text('Waiting to start....');
            },
          ),
        ],
      ),
    );
  }
}
