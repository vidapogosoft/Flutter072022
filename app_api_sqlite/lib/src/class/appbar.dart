import 'package:app_api_sqlite/src/class/alert.dart';
import 'package:app_api_sqlite/src/class/constant.dart';
import 'package:flutter/material.dart';
import 'package:app_api_sqlite/src/route/route.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool backArrow;
  const MyAppBar({Key? key, required this.backArrow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Constant.primaryColor,
      leading: backArrow
          ? IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: Constant.secondaryColor),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      title: Image.asset(
        "assets/images/logo.png",
        fit: BoxFit.cover,
        height: 40,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined,
              size: 26.0, color: Constant.secondaryColor),
          onPressed: () {
            Navigator.of(context).push(MyRoute.orders(context));
          },
        ),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MyRoute.config(context));
            },
            icon: const Icon(Icons.settings_rounded,
                color: Constant.secondaryColor)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void choiceAction(BuildContext context, String choice) {
    if (choice == Constant.logout) {
      Alert.logout(context);
    }
  }
}
