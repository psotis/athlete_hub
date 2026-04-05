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
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.sports_gymnastics, size: 28)),
                Tab(icon: Icon(Icons.person, size: 28)),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              StartSessionMobile(users: users),
              GetCustomerMobile(users: users),
            ],
          ),
        ),
      ),
    );
  }
}
