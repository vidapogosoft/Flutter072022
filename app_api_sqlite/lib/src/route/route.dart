import 'package:flutter/material.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:app_api_sqlite/src/ui/config/config.dart';
import 'package:app_api_sqlite/src/ui/dispo/dispo_item.dart';
import 'package:app_api_sqlite/src/ui/home/home.dart';
import 'package:app_api_sqlite/src/ui/order/order_detail.dart';
import 'package:app_api_sqlite/src/ui/order/orders.dart';

class MyRoute {
  static const begin = Offset(1.0, 0.0);
  static const end = Offset.zero;
  static const curve = Curves.easeInOut;

  static var tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  static Route productDispo(BuildContext context, int idDispo) {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: Constant.durationTransition),
      pageBuilder: (context, animation, secondaryAnimation) =>
          DispoItem(idDispo: idDispo),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route orderDetail(BuildContext context) {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: Constant.durationTransition),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const OrderDetail(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route orders(BuildContext context) {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: Constant.durationTransition),
      pageBuilder: (context, animation, secondaryAnimation) => const Orders(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route config(BuildContext context) {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: Constant.durationTransition),
      pageBuilder: (context, animation, secondaryAnimation) => const Config(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  static Route home(BuildContext context) {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: Constant.durationTransition),
      pageBuilder: (context, animation, secondaryAnimation) => const Home(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
