import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_api_sqlite/src/class/appbar.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/ui/order/saved_order.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: Constant.lightTheme,
        child: Builder(builder: (context) {
          return const Scaffold(
            appBar: MyAppBar(backArrow: true),
            body: SavedOrder(),
          );
        }));
  }
}
