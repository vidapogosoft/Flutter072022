import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/ui/order/history_order.dart';
import 'package:app_api_sqlite/src/ui/order/saved_order.dart';
import 'package:app_api_sqlite/src/route/route.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Orders> with SingleTickerProviderStateMixin {
  static const List<Tab> _myTabs = <Tab>[
    Tab(
        child: Text('Guardados',
            style: TextStyle(color: Constant.secondaryColor))),
    Tab(
        child: Text('Historial',
            style: TextStyle(color: Constant.secondaryColor))),
  ];

  final PageController _pageController = PageController();
  late TabController _tabController;
  bool isPageCanChange = true;

  final List<Widget> _listPages = [
    const SavedOrder(),
    const HistoryOrder(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _myTabs.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onPageChange(index: _tabController.index, fromTab: true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _onPageChange({required int index, required bool fromTab}) async {
    if (fromTab) {
      isPageCanChange = false;
      await _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 400), curve: Curves.ease);
      isPageCanChange = true;
    } else {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Constant.lightTheme,
      child: Scaffold(
        backgroundColor: Constant.backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Constant.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Constant.secondaryColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Pedidos',
            style: TextStyle(color: Constant.secondaryColor),
          ),
          centerTitle: false,
          bottom: TabBar(
            controller: _tabController,
            tabs: _myTabs,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MyRoute.config(context));
                },
                icon: const Icon(Icons.settings_rounded,
                    color: Constant.secondaryColor)),
          ],
        ),
        body: PageView(
          controller: _pageController,
          children: _listPages,
          onPageChanged: (page) async {
            if (isPageCanChange) {
              _onPageChange(index: page, fromTab: false);
            }
          },
        ),
      ),
    );
  }
}
