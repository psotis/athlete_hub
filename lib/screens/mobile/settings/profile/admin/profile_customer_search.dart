import 'package:athlete_hub/helpers/imports.dart';

class ProfileCustomerSearchPage extends StatefulWidget {
  const ProfileCustomerSearchPage({super.key});

  @override
  State<ProfileCustomerSearchPage> createState() =>
      _ProfileCustomerSearchPageState();
}

class _ProfileCustomerSearchPageState extends State<ProfileCustomerSearchPage> {
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
      return user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          (user.team ?? '').toLowerCase().contains(query) ||
          (user.sport ?? '').toLowerCase().contains(query);
    }).toList();
  }

  void _openProfile(Users user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileMobile(selectedUser: user)),
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
                              onTap: () => _openProfile(user),
                              leading: CircleAvatar(
                                child: Text(
                                  user.firstName.isNotEmpty
                                      ? user.firstName[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              title: Text(user.fullName),
                              subtitle: Text(
                                [
                                  user.email,
                                  if ((user.team ?? '').trim().isNotEmpty)
                                    user.team!,
                                ].join(' • '),
                              ),
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
