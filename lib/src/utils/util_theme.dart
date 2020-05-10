import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

import 'util_common.dart';

List<AppTheme> initAppThemes() => [
  AppTheme.light().copyWith(
          id: "siflab_default",
          description: "Tema Default",
      data: ThemeData(
          primaryColor: hexToColor("#275da7"),
          primaryColorDark: hexToColor("#275da7"),
          primaryColorLight: hexToColor("#306fbf"),
          scaffoldBackgroundColor: hexToColor("#F1F1F1"),
          backgroundColor: hexToColor("#F1F1F1"),
          colorScheme: ColorScheme(
              primary: Color(0xff275da7),
              primaryVariant: Color(0xff306fbf),
              secondary: hexToColor("#306fbf"),
              secondaryVariant: hexToColor("#f25c05"),
              surface: hexToColor("#F1F1F1"),
              background: hexToColor("#158cea"),
              error: hexToColor("#fc5342"),
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.white,
              onError: Colors.white,
              brightness: Brightness.light),
          textTheme: TextTheme(headline: TextStyle(fontSize: 18.0)),
          appBarTheme: AppBarTheme(
            elevation: 0.0,
            color: hexToColor("#F1F1F1"),
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: Colors.black),
            actionsIconTheme: IconThemeData(color: Colors.black),
          ),
          primaryIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.black),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontSize: 20.0)),
          accentTextTheme: TextTheme(
              title: TextStyle(color: Colors.white, fontSize: 12.0)),
          buttonTheme: ButtonThemeData(
              colorScheme: ColorScheme(
                  primary: hexToColor("#275da7"),
                  primaryVariant: hexToColor("#306fbf"),
                  secondary: hexToColor("#03a60f"),
                  secondaryVariant: hexToColor("#2ea64c"),
                  surface: hexToColor("#F1F1F1"),
                  background: hexToColor("#158cea"),
                  error: hexToColor("#fc5342"),
                  onPrimary: Colors.white,
                  onSecondary: Colors.white,
                  onSurface: Colors.black,
                  onBackground: Colors.white,
                  onError: Colors.white,
                  brightness: Brightness.light)
          )
      )
  ),
      AppTheme.dark(id: "siflab_dark")
    ];
