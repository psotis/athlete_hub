import 'package:athlete_hub/helpers/imports.dart';

class AdminMobile extends StatefulWidget {
  const AdminMobile({super.key});

  @override
  State<AdminMobile> createState() => _AdminMobileState();
}

class _AdminMobileState extends State<AdminMobile> {
  List<Users> users = [];
  bool isLoadingUsers = false;
  String? usersError;

  @override
  void initState() {
    super.initState();
    getCustomers();
  }

  Future<void> getCustomers() async {
    setState(() {
      isLoadingUsers = true;
      usersError = null;
    });

    try {
      final response = await UserService().getCustomers();

      if (!mounted) return;

      setState(() {
        users = response.data ?? [];
        isLoadingUsers = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingUsers = false;
        usersError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MobileGlowScaffold(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Column(
                  children: [
                    // const MobilePageHeader(
                    //   title: 'Admin Metrics',
                    //   subtitle:
                    //       'Start new ergometrics sessions or review athlete metrics from the same mobile workspace.',
                    // ),
                    const SizedBox(height: 14),
                    MobileGlassCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      child: const TabBar(
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          gradient: LinearGradient(
                            colors: [Color(0xFF173E8C), Color(0xFF0D6EFD)],
                          ),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        dividerColor: Colors.transparent,
                        tabs: [
                          Tab(
                            icon: Icon(Icons.sports_gymnastics, size: 24),
                            text: 'Start',
                          ),
                          Tab(
                            icon: Icon(Icons.person_search, size: 24),
                            text: 'Search',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoadingUsers
                    ? const Center(child: CircularProgressIndicator())
                    : usersError != null
                    ? Center(
                        child: Text(
                          usersError!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : TabBarView(
                        children: <Widget>[
                          StartSessionMobile(users: users),
                          GetCustomerMobile(users: users),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
