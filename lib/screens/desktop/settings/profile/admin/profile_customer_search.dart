import 'package:athlete_hub/helpers/imports.dart';

class ProfileCustomerSearchDesktopPage extends StatefulWidget {
  const ProfileCustomerSearchDesktopPage({super.key});

  @override
  State<ProfileCustomerSearchDesktopPage> createState() =>
      _ProfileCustomerSearchDesktopPageState();
}

class _ProfileCustomerSearchDesktopPageState
    extends State<ProfileCustomerSearchDesktopPage> {
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
      MaterialPageRoute(builder: (_) => ProfileDesktop(selectedUser: user)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _filteredUsers;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF0F172A),
        title: const Text('Select Athlete'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DesktopSurfaceCard(
                  child: DesktopSectionTitle(
                    title: 'Athletes',
                    subtitle:
                        'Search by athlete name, phone, email, team or sport and open the full desktop profile.',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Search athlete...',
                    prefixIcon: Icon(Icons.search),
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
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(22),
                              onTap: () => _openProfile(user),
                              child: DesktopSurfaceCard(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xFFDBEAFE),
                                      child: Text(
                                        user.firstName.isNotEmpty
                                            ? user.firstName[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          color: Color(0xFF1D4ED8),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.fullName,
                                            style: const TextStyle(
                                              color: Color(0xFF0F172A),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            [
                                              user.email,
                                              if ((user.team ?? '')
                                                  .trim()
                                                  .isNotEmpty)
                                                user.team!,
                                              if ((user.sport ?? '')
                                                  .trim()
                                                  .isNotEmpty)
                                                user.sport!,
                                            ].join(' - '),
                                            style: const TextStyle(
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right_rounded),
                                  ],
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
      ),
    );
  }
}
