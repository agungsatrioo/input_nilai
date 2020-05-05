import 'package:flutter/widgets.dart';
import 'package:theme_provider/theme_provider.dart';

class DefaultViewWidget extends StatelessWidget {
  String title, message;

  DefaultViewWidget({
    @required this.title,
    this.message = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, textAlign: TextAlign.center,
                style: ThemeProvider.themeOf(context).data.textTheme.subtitle,),
              Text(message, textAlign: TextAlign.center,
                style: ThemeProvider.themeOf(context).data.textTheme.caption,),
            ]
          ),
        ),
      );
  }
}