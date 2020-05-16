import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import '../../../models/menus.dart';
import 'widget_homemenu_item.dart';

class HomeMenuGridListWidget extends StatelessWidget {
  final List<HomeMenuItem> menuList;

  HomeMenuGridListWidget({
    @required this.menuList
  });

  VoidCallback openContainer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4), 
        itemCount: menuList.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          HomeMenuItem item = menuList[position];

          return Material(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .scaffoldBackgroundColor,
                    child: InkWell(
                      child: HomeMenuItemWidget(item),
                      onTap: () {
                        print(item.route);
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
        }
      ),
    );
  }

}