import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../models/menus.dart';
import 'widget_homemenu_item.dart';

class HomeCardMenus extends StatelessWidget {
  final List<HomeMenu> menuList;

  HomeCardMenus(this.menuList);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: MediaQuery.of(context).size.height / 650,
              shrinkWrap: true,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: menuList.map((item) {
                return Material(
                  color: ThemeProvider.themeOf(context)
                      .data
                      .scaffoldBackgroundColor,
                  child: InkWell(
                    child: HomeMenuItem(item),
                    onTap: () {
                      if (item.route != null) {
                        if (item.route is StatelessWidget ||
                            item.route is StatefulWidget)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ThemeConsumer(child: item.route)));
                        else if (item.route is Function) item.route();
                      }
                    },
                    onLongPress: () => Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(item.description))),
                  ),
                );
              }).toList()),
        ));
  }
}
