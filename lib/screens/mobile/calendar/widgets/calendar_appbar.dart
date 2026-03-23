import 'package:athlete_hub/helpers/imports.dart';

class CalendarAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CalendarAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 100,
      titleSpacing: 0,
      title: CalendarTimeline(
        initialDate: DateTime(2020, 4, 20),
        firstDate: DateTime(2019, 1, 15),
        lastDate: DateTime(2040, 11, 20),
        // ignore: avoid_print
        onDateSelected: (date) => print(date),
        leftMargin: 20,
        monthColor: Colors.blueGrey,
        dayColor: Colors.teal[200],
        activeDayColor: Colors.white,
        activeBackgroundDayColor: Colors.redAccent[100],
        selectableDayPredicate: (date) => date.day != 23,
        locale: 'en_ISO',
      ),
    );
  }
}
