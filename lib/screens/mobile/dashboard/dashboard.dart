import 'package:athlete_hub/helpers/imports.dart';

class DashboardMobile extends StatefulWidget {
  const DashboardMobile({super.key});

  @override
  State<DashboardMobile> createState() => _DashboardMobileState();
}

class _DashboardMobileState extends State<DashboardMobile> {
  PageController? pageController;
  int _selectedIndex = 0;

  final screens = [
    HomePage(),
    CalendarPage(),
    MetricsPage(),
    MetricsPage(),
    SettingsPage(),
  ];

  void onpageChange(int page) {
    setState(() {
      _selectedIndex = page;
    });
  }

  void ontabTap({int page = 0}) {
    onpageChange(page);
    pageController?.animateToPage(
      _selectedIndex,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onpageChange,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
            ontabTap(page: _selectedIndex);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.calendar),
            label: 'Training plan',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.database),
            label: 'Metrics',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.nutritionix),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
