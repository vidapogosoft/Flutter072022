import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/class/appbar.dart';
import 'package:app_api_sqlite/src/db/dispo_item_db.dart';
import 'package:app_api_sqlite/src/ui/dispo/dispo.dart';
import 'package:app_api_sqlite/src/ui/dispo/dispo_test.dart';
import 'package:app_api_sqlite/src/ui/dispo/out_of_item.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String date = '';

  @override
  void initState() {
    _dateWasUpdated();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _dateWasUpdated() async {
    String creationDate = await DispoItemDB.dateWasUpdated();
    if (creationDate != '') {
      setState(() {
        date = creationDate;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = [
    const Dispo(),
    const OutOfProduct(),
    const DispoTest(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Constant.lightTheme,
      child: Scaffold(
        backgroundColor: Constant.backgroundColor,
        appBar: const MyAppBar(backArrow: false),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomSheet: _selectedIndex == 0
            ? Container(
                color: Constant.primaryColor,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                child: Text('Fecha de actualización: $date',
                    textAlign: TextAlign.center))
            : null,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Constant.primaryColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.hourglass_empty),
              label: 'Agotados',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.business_center_rounded), label: 'Prueba'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
