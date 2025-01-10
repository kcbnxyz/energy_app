import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({super.key});

  buildItems(BuildContext context) {
    return [
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.dark_mode),
        onTap: () {
          AdaptiveTheme.of(context).toggleThemeMode(useSystem: false);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var items = buildItems(context);
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: Drawer(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return items[index];
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 1);
                  },
                  itemCount: items.length),
            ],
          ),
        ),
      ),
    );
  }
}
