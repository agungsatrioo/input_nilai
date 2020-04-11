//This file is for placing menus which to be displayed at main page and more menu.
import 'package:flutter/widgets.dart';

abstract class Menu {
  String _name;

  Menu(this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}

class MenuHeader implements Menu {
  @override
  String _name;

  @override
  String name;

  MenuHeader(this.name);
}

class HomeMenu implements Menu {
  String _description;
  var _icon;
  var _route;
  Color _color;

  @override
  String _name;

  @override
  String name;

  HomeMenu(this.name, this._description, this._icon, this._route, this._color);

  Color get color => _color;

  set color(Color value) {
    _color = value;
  }

  get route => _route;

  set route(value) {
    _route = value;
  }

  get icon => _icon;

  set icon(var value) {
    _icon = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }
}

class MoreMenuItem extends HomeMenu {
  MenuHeader _group;

  MoreMenuItem(String name, String description, Icon icon, var route,
      Color color, MenuHeader group)
      : super(name, description, icon, route, color) {
    this._group = group;
  }

  MenuHeader get group => _group;

  set group(MenuHeader value) {
    _group = value;
  }
}
