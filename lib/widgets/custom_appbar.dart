import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(
    BuildContext context, String title, PreferredSizeWidget? tabBar) {
  return AppBar(
    toolbarHeight: 40,
    elevation: 0,
    shadowColor: Colors.transparent,
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(title),
    bottom: tabBar,
    actions: const [
      BurgerMenu(),
    ],
  );
}

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.menu,
      ),
      onPressed: () => Scaffold.of(context).openEndDrawer(),
    );
  }
}
