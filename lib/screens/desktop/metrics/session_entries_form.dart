import 'package:athlete_hub/helpers/imports.dart';

class DesktopSessionEntriesController {
  final GlobalKey<SessionEntriesMobileState> _formKey =
      GlobalKey<SessionEntriesMobileState>();

  GlobalKey<SessionEntriesMobileState> get formKey => _formKey;

  Map<String, dynamic>? buildValidatedPayload() {
    return _formKey.currentState?.buildValidatedPayload();
  }
}

class SessionEntriesDesktop extends StatelessWidget {
  final String sessionId;
  final Users athlete;
  final Set<ErgometricsEntryCategory>? selectedCategories;
  final bool showSaveButton;
  final DesktopSessionEntriesController? controller;

  const SessionEntriesDesktop({
    super.key,
    required this.sessionId,
    required this.athlete,
    this.selectedCategories,
    this.showSaveButton = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF071224),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      padding: const EdgeInsets.all(14),
      child: SessionEntriesMobile(
        key: controller?.formKey,
        sessionId: sessionId,
        athlete: athlete,
        selectedCategories: selectedCategories,
        showSaveButton: showSaveButton,
      ),
    );
  }
}
