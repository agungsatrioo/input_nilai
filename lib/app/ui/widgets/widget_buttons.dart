import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

class MyButton extends StatelessWidget {
  String caption;
  Function() onTap;
  Color buttonColor;
  Color textColor;
  double fontSize = 16.0;
  double buttonWidth = 88.0;
  double buttonHeight = 48.0;
  int _buttonType;
  bool _isOutline;

  static const _BUTTON_TYPE_ERROR = 1;
  static const _BUTTON_TYPE_PRIMARY = 2;
  static const _BUTTON_TYPE_SECONDARY = 3;
  static const _BUTTON_TYPE_FLAT = 4;
  static const _BUTTON_TYPE_FLAT_PRIMARY = 5;
  static const _BUTTON_TYPE_FLAT_SECONDARY = 6;
  static const _BUTTON_TYPE_FLAT_ERROR = 7;
  static const _BUTTON_TYPE_FLAT_CUSTOM = 8;

  MyButton.error(
      {@required this.caption,
      this.buttonWidth = 88.0,
      this.buttonHeight = 48.0,
      @required this.onTap}) {
    this._buttonType = 1;
    this._isOutline = false;
  }

  MyButton.primary(
      {@required this.caption,
      this.buttonWidth = 88.0,
      this.buttonHeight = 48.0,
      @required this.onTap}) {
    this._buttonType = 2;
    this._isOutline = false;
  }

  MyButton.secondary(
      {@required this.caption,
      this.buttonWidth = 88.0,
      this.buttonHeight = 48.0,
      @required this.onTap}) {
    this._buttonType = 3;
    this._isOutline = false;
  }

  MyButton.flat(
      {@required this.caption,
      this.buttonWidth = 88.0,
      this.buttonHeight = 48.0,
      @required this.onTap}) {
    this._buttonType = 4;
    this._isOutline = true;
  }

  MyButton.flatPrimary(
      {@required this.caption,
      this.buttonWidth = 88.0,
      this.buttonHeight = 48.0,
      @required this.onTap}) {
    this._buttonType = 5;
    this._isOutline = true;
  }

  MyButton.flatSecondary(
      {@required this.caption,
      this.buttonWidth = 88.0,
      this.buttonHeight = 48.0,
      @required this.onTap}) {
    this._buttonType = 6;
    this._isOutline = true;
  }

  MyButton.flatError(
      {@required this.caption,
      this.buttonWidth = 88.0,
      this.buttonHeight = 48.0,
      @required this.onTap}) {
    this._buttonType = 7;
    this._isOutline = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget _buttonShape;
    AppTheme appTheme = ThemeProvider.themeOf(context);

    switch (_buttonType) {
      case _BUTTON_TYPE_ERROR:
        this.buttonColor = appTheme.data.colorScheme.error;
        this.textColor = appTheme.data.colorScheme.onError;
        break;
      case _BUTTON_TYPE_PRIMARY:
        this.buttonColor = appTheme.data.colorScheme.primary;
        this.textColor = appTheme.data.colorScheme.onPrimary;
        break;
      case _BUTTON_TYPE_SECONDARY:
        this.buttonColor = appTheme.data.buttonTheme.colorScheme.secondary;
        this.textColor = appTheme.data.buttonTheme.colorScheme.onSecondary;
        break;
      case _BUTTON_TYPE_FLAT:
        this.buttonColor = appTheme.data.buttonColor;
        this.textColor = appTheme.data.colorScheme.onSurface;
        break;
      case _BUTTON_TYPE_FLAT_ERROR:
        this.buttonColor = appTheme.data.colorScheme.error;
        this.textColor = appTheme.data.colorScheme.error;
        break;
      case _BUTTON_TYPE_FLAT_PRIMARY:
        this.buttonColor = appTheme.data.colorScheme.primary;
        this.textColor = appTheme.data.colorScheme.primary;
        break;
      case _BUTTON_TYPE_FLAT_SECONDARY:
        this.buttonColor = appTheme.data.buttonTheme.colorScheme.secondary;
        this.textColor = appTheme.data.buttonTheme.colorScheme.onSecondary;
        break;
    }

    if (_isOutline) {
      _buttonShape = OutlineButton(
        color: buttonColor,
        highlightedBorderColor: buttonColor,
        borderSide: BorderSide(color: buttonColor),
        child: Text(caption,
            style: TextStyle(fontSize: fontSize, color: textColor)),
        onPressed: onTap,
      );
    } else {
      _buttonShape = FlatButton(
        color: buttonColor,
        child: Text(caption,
            style: TextStyle(
                fontSize: fontSize,
                color: textColor ??
                    ThemeProvider.themeOf(context).data.colorScheme.onPrimary)),
        onPressed: onTap,
      );
    }

    return Padding(
        padding: EdgeInsets.all(8.0),
        child: ButtonTheme(
          minWidth: buttonWidth,
          height: buttonHeight,
          child: _buttonShape,
        ));
  }
}
