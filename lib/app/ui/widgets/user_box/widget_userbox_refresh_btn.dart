import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

Widget UserBoxRefreshButton({
  @required BuildContext context,
  @required Function() onTap,
}) =>
    Material(
      color: ThemeProvider.themeOf(context).data.primaryColor,
      child: InkWell(
        child: Icon(
          LineIcons.refresh,
          size: 24,
          color: ThemeProvider.themeOf(context).data.primaryIconTheme.color,
        ),
        onTap: onTap,
      ),
    );

Widget UserBoxCircularProgress(BuildContext context) => SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
            ThemeProvider.themeOf(context).data.primaryIconTheme.color),
      ),
    );
