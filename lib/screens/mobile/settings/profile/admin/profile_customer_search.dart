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
          (user.phone ?? '').toLowerCase().contains(query) ||
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

    return MobileGlowScaffold(
      appBar: const MobileScreenAppBar(title: 'Select Athlete'),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MobilePageHeader(
                title: 'Athletes',
                subtitle:
                    'Search by athlete name, phone, email, team or sport and open the full profile.',
              ),
              const SizedBox(height: 16),
              MobileSearchField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                hintText: 'Search athlete...',
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : filteredUsers.isEmpty
                    ? const Center(
                        child: Text(
                          'No athletes found',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredUsers.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];

                          return MobileGlassCard(
                            borderRadius: BorderRadius.circular(22),
                            padding: EdgeInsets.zero,
                            child: ListTile(
                              onTap: () => _openProfile(user),
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color(0xFF6EE7FF).withAlpha(41),
                                child: Text(
                                  user.firstName.isNotEmpty
                                      ? user.firstName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                user.fullName,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                [
                                  user.email,
                                  if ((user.team ?? '').trim().isNotEmpty)
                                    user.team!,
                                ].join(' - '),
                                style: TextStyle(
                                  color: Colors.white.withAlpha(173),
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                                color: Colors.white70,
                              ),
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
