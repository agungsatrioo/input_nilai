import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

List<AppTheme> initAppThemes() => [
      AppTheme.light().copyWith(
          id: "siflab_default",
          description: "Tema Default",
          data: ThemeData.from(
                  colorScheme: ColorScheme(
                      primary: Color(0xff275da7),
                      primaryVariant: Color(0xff306fbf),
                      secondary: Color(0xff306fbf),
                      secondaryVariant: Color(0xff306fbf),
                      surface: Color(0xffF1F1F1),
                      background: Color(0xffF1F1F1),
                      error: Color(0xfffc5342),
                      onPrimary: Colors.white,
                      onSecondary: Colors.white,
                      onSurface: Colors.black,
                      onBackground: Colors.black,
                      onError: Colors.white,
                      brightness: Brightness.light))
              .copyWith(
            primaryIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.black),
            secondaryHeaderColor: Color(0xff306fbf),
            primaryTextTheme: TextTheme(
                headline6: TextStyle(color: Colors.black, fontSize: 20.0)),
            appBarTheme: AppBarTheme(
              elevation: 0.0,
              color: Color(0xffF1F1F1),
              brightness: Brightness.light,
              iconTheme: IconThemeData(color: Colors.black),
              actionsIconTheme: IconThemeData(color: Colors.black),
            ),
          )),
      AppTheme.dark().copyWith(
          id: "siflab_dark",
          description: "Tema Gelap",
          data: ThemeData.from(
                  colorScheme: ColorScheme(
                      primary: Color(0xff275da7),
                      primaryVariant: Color(0xff306fbf),
                      secondary: Color(0xff306fbf),
                      secondaryVariant: Color(0xff306fbf),
                      surface: Color(0xff424242),
                      background: Color(0xff212121),
                      error: Color(0xfffc5342),
                      onPrimary: Colors.white,
                      onSecondary: Colors.white,
                      onSurface: Colors.white,
                      onBackground: Colors.white,
                      onError: Colors.white,
                      brightness: Brightness.dark))
              .copyWith(
            primaryIconTheme: IconThemeData(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            secondaryHeaderColor: Color(0xff306fbf),
            primaryTextTheme: TextTheme(
                headline6: TextStyle(color: Colors.white, fontSize: 20.0)),
            appBarTheme: AppBarTheme(
              elevation: 0.0,
              color: Color(0xff212121),
              brightness: Brightness.dark,
              iconTheme: IconThemeData(color: Colors.white),
              actionsIconTheme: IconThemeData(color: Colors.white),
            ),
          ))
    ];
