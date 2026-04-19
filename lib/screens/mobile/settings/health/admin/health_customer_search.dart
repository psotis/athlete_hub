import 'package:athlete_hub/helpers/imports.dart';

class HealthCustomerSearchPage extends StatefulWidget {
  const HealthCustomerSearchPage({super.key});

  @override
  State<HealthCustomerSearchPage> createState() =>
      _HealthCustomerSearchPageState();
}

class _HealthCustomerSearchPageState extends State<HealthCustomerSearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<Users> _users = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await UserService().getCustomers();

      if (!mounted) return;

      setState(() {
        _users = response.data ?? [];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  List<Users> get _filteredUsers {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) return _users;

    return _users.where((user) {
      final fullName = user.fullName.toLowerCase();
      final email = user.email.toLowerCase();
      final sport = (user.sport ?? '').toLowerCase();
      final team = (user.team ?? '').toLowerCase();

      return fullName.contains(query) ||
          email.contains(query) ||
          sport.contains(query) ||
          team.contains(query);
    }).toList();
  }

  void _openHealth(Users user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HealthMobile(selectedAthlete: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filteredUsers;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text('Select Athlete'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search athlete...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!))
                    : filteredUsers.isEmpty
                    ? const Center(child: Text('No athletes found'))
                    : ListView.separated(
                        itemCount: filteredUsers.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];

                          return Card(
                            child: ListTile(
                              onTap: () => _openHealth(user),
                              leading: CircleAvatar(
                                child: Text(
                                  user.firstName.isNotEmpty
                                      ? user.firstName[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              title: Text(user.fullName),
                              subtitle: Text(user.email),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
