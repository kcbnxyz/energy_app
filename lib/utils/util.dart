import 'package:energy_app/routing/main_router.dart';
import 'package:flutter/material.dart';

void Function(String message) errorMessageSnackBar(
    {Duration duration = const Duration(milliseconds: 3000)}) {
  return (String message) {
    SnackBar snackbar = SnackBar(
      duration: duration,
      content: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(message)),
        ],
      ),
      behavior: SnackBarBehavior.floating,
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);

    Future.delayed(duration).then((value) {
      // ignore: invalid_use_of_protected_member
      scaffoldMessengerKey.currentState?.setState(() {});
    });
  };
}
