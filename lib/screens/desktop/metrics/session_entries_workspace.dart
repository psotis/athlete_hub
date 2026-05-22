import 'package:athlete_hub/helpers/imports.dart';
import 'package:athlete_hub/screens/desktop/metrics/session_entries_form.dart';

class DesktopSessionEntriesWorkspace extends StatelessWidget {
  final String sessionId;
  final Users athlete;

  const DesktopSessionEntriesWorkspace({
    super.key,
    required this.sessionId,
    required this.athlete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DesktopSurfaceCard(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.sports_gymnastics_rounded,
                  color: Color(0xFF1D4ED8),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      athlete.fullName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: const Color(0xFF0F172A),
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Complete this ergometric session from a desktop workspace without leaving the admin metrics area.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF475569),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: DesktopSurfaceCard(
            padding: const EdgeInsets.all(18),
            child: SessionEntriesDesktop(
              sessionId: sessionId,
              athlete: athlete,
            ),
          ),
        ),
      ],
    );
  }
}

class DesktopTeamBatchSessionPage extends StatefulWidget {
  final String teamName;
  final List<BatchSessionAthleteConfig> configs;

  const DesktopTeamBatchSessionPage({
    super.key,
    required this.teamName,
    required this.configs,
  });

  @override
  State<DesktopTeamBatchSessionPage> createState() =>
      _DesktopTeamBatchSessionPageState();
}

class _DesktopTeamBatchSessionPageState extends State<DesktopTeamBatchSessionPage>
    with SingleTickerProviderStateMixin {
  late final List<DesktopSessionEntriesController> _controllers;
  late final TabController _tabController;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.configs.length,
      (_) => DesktopSessionEntriesController(),
    );
    _tabController = TabController(length: widget.configs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _rollbackSessions() async {
    final repository = context.read<SessionRepository>();
    for (final config in widget.configs) {
      try {
        await repository.deleteSession(config.sessionId);
      } catch (_) {}
    }
  }

  Future<void> _submitAll() async {
    setState(() => _isSending = true);

    try {
      final payloads = <Map<String, dynamic>>[];
      for (final controller in _controllers) {
        final payload = controller.buildValidatedPayload();
        if (payload == null) {
          setState(() => _isSending = false);
          return;
        }
        payloads.add(payload);
      }

      final service = SessionService();
      for (final payload in payloads) {
        await service.bulkCreateSessionEntries(payload);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All team sessions saved successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      await _rollbackSessions();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Batch save failed. Sessions rolled back: $e')),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
        title: Text(widget.teamName),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DesktopSurfaceCard(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.teamName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: const Color(0xFF0F172A),
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fill the selected ergometrics for each athlete and send them together when the batch is ready.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: const Color(0xFF475569),
                                height: 1.45,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  FilledButton.icon(
                    onPressed: _isSending ? null : _submitAll,
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                    label: const Text('Send all'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              padding: const EdgeInsets.all(8),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  gradient: LinearGradient(
                    colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
                  ),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF475569),
                dividerColor: Colors.transparent,
                tabs: widget.configs
                    .map((config) => Tab(text: config.athlete.fullName))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(widget.configs.length, (index) {
                  final config = widget.configs[index];
                  return DesktopSurfaceCard(
                    child: SessionEntriesDesktop(
                      controller: _controllers[index],
                      sessionId: config.sessionId,
                      athlete: config.athlete,
                      selectedCategories: config.categories,
                      showSaveButton: false,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
