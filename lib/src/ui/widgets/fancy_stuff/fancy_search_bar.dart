import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

import 'widget_painter.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  String title;
  List<Widget> widgetList;

  MyAppBar(
      {Key key,
      @required this.title,
      @required this.onCancelSearch,
      @required this.onSearchQueryChanged,
      @required this.widgetList})
      : super(key: key);

  final VoidCallback onCancelSearch;
  final Function(String) onSearchQueryChanged;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState(this.title,
      this.widgetList, this.onCancelSearch, this.onSearchQueryChanged);
}

class _DefaultAppBarState extends State<MyAppBar>
    with SingleTickerProviderStateMixin {
  double rippleStartX, rippleStartY;
  bool isInSearchMode = false;
  AnimationController _controller;
  Animation _animation;

  final VoidCallback onCancelSearch;
  final Function(String) onSearchQueryChanged;

  String _title;
  final List<Widget> _widgetList;

  _DefaultAppBarState(this._title, this._widgetList, this.onCancelSearch,
      this.onSearchQueryChanged);

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    _controller.addStatusListener(animationStatusListener);
  }

  animationStatusListener(AnimationStatus animationStatus) {
    if (animationStatus == AnimationStatus.completed) {
      setState(() {
        isInSearchMode = true;
      });
    }
  }

  void onSearchTapUp(TapUpDetails details) {
    setState(() {
      rippleStartX = details.globalPosition.dx;
      rippleStartY = details.globalPosition.dy;
    });

    print("pointer location $rippleStartX, $rippleStartY");

    _controller.forward();
  }

  onSearchCanceled() {
    setState(() {
      isInSearchMode = false;
    });

    _controller.reverse();

    onSearchQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBar(title: Text(this._title),
            brightness: isInSearchMode ? Brightness.dark : Brightness.light,
            elevation: 0, actions: [
          ..._widgetList,
          GestureDetector(
            // ignore: missing_required_param
            child: IconButton(
              icon: Icon(LineIcons.search,
                  color: ThemeProvider.themeOf(context).data.iconTheme.color),
            ),
            onTapUp: onSearchTapUp,
          )
        ]),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: MyPainter(
                color: ThemeProvider
                    .themeOf(context)
                    .data
                    .colorScheme
                    .primary,
                containerHeight: widget.preferredSize.height,
                center: Offset(rippleStartX ?? 0, rippleStartY ?? 0),
                radius: _animation.value * MediaQuery.of(context).size.width,
                context: context,
              ),
            );
          },
        ),
        // search bar depending on whether src bar is in search mode or not
        isInSearchMode
            ? (SearchBar(
                onCancelSearch: onSearchCanceled,
                onSearchQueryChanged: onSearchQueryChanged,
              ))
            : (Container())
      ],
    );
  }
}

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  SearchBar({
    Key key,
    @required this.onCancelSearch,
    @required this.onSearchQueryChanged,
  }) : super(key: key);

  final VoidCallback onCancelSearch;
  final Function(String) onSearchQueryChanged;

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  String searchQuery = '';
  TextEditingController _searchFieldController = TextEditingController();

  clearSearchQuery() {
    _searchFieldController.clear();
    widget.onSearchQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(LineIcons.arrow_left, color: Colors.white),
                  onPressed: widget.onCancelSearch,
                ),
                Expanded(
                  child: TextField(
                    controller: _searchFieldController,
                    cursorColor: Colors.white,
                    autofocus: true,
                    style: Theme.of(context).textTheme.title.merge(TextStyle(
                        color: Colors.white, fontWeight: FontWeight.normal)),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Cari nama mahasiswa...",
                      hintStyle: Theme.of(context).textTheme.title.merge(
                          TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal)),
                      suffixIcon: InkWell(
                        child: Icon(LineIcons.close, color: Colors.white),
                        onTap: clearSearchQuery,
                      ),
                    ),
                    onChanged: widget.onSearchQueryChanged,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
