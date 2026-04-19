import 'package:athlete_hub/helpers/imports.dart';

class BatchSessionAthleteConfig {
  final Users athlete;
  final String sessionId;
  final Set<ErgometricsEntryCategory> categories;

  const BatchSessionAthleteConfig({
    required this.athlete,
    required this.sessionId,
    required this.categories,
  });
}

class TeamBatchSessionPage extends StatefulWidget {
  final String teamName;
  final List<BatchSessionAthleteConfig> configs;

  const TeamBatchSessionPage({
    super.key,
    required this.teamName,
    required this.configs,
  });

  @override
  State<TeamBatchSessionPage> createState() => _TeamBatchSessionPageState();
}

class _TeamBatchSessionPageState extends State<TeamBatchSessionPage> {
  late final List<GlobalKey<SessionEntriesMobileState>> _formKeys;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _formKeys = List.generate(
      widget.configs.length,
      (_) => GlobalKey<SessionEntriesMobileState>(),
    );
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

      for (final key in _formKeys) {
        final payload = key.currentState?.buildValidatedPayload();
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.teamName),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Fill the selected ergometrics for each athlete, then send them all together.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: widget.configs.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final config = widget.configs[index];

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        height: 420,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              config.athlete.fullName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if ((config.athlete.team ?? '').trim().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Team: ${config.athlete.team}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: SessionEntriesMobile(
                                key: _formKeys[index],
                                sessionId: config.sessionId,
                                athlete: config.athlete,
                                selectedCategories: config.categories,
                                showSaveButton: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _submitAll,
                  child: _isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send all'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
