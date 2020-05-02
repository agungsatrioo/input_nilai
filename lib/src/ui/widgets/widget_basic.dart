import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/utils/util_colors.dart';

Widget center_text(String text) {
  return Center(
    child: Text(text),
  );
}

Widget loading() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator()),
          Text("Harap tunggu...")
        ],
      ),
    );

Widget caption_text(BuildContext context, String text) =>
    Text(text, style: TextStyle(color: Theme.of(context).colorScheme.primary));

class SystemPadding extends StatelessWidget {
  final Widget child;

  SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        duration: const Duration(milliseconds: 300), child: child);
  }
}

Widget textWithCaption(BuildContext context, String caption, String content) =>
    Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          caption_text(context, caption),
          SizedBox(height: 4),
          Text(
            content,
            style: Theme.of(context).textTheme.title,
          ),
        ],
      ),
    );

Widget textCaptionWithIcon(
        {@required BuildContext context,
        @required IconData icon,
        @required String caption,
        @required String content,
        Color circleColor = colorGreenStd,
        Color iconColor = Colors.white}) =>
    Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: makeRoundedIcon(
                icon: icon,
                size: 36,
                circleColor: circleColor,
                iconColor: iconColor),
          ),
          Expanded(child: textWithCaption(context, caption, content))
        ],
      ),
    );

Widget makeRoundedIcon(
        {@required IconData icon,
        @required double size,
        Color circleColor = colorGreenStd,
        Color iconColor = Colors.white}) =>
    Container(
        decoration: new BoxDecoration(
          color: circleColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, size: size, color: iconColor)));

Widget makeTextField(
        {@required String labelText,
        @required IconData icon,
        @required Function(String) onChange,
        TextEditingController controller,
        String value = "",
        TextInputType textInputType = TextInputType.text,
        int maxLines = 1}) =>
    TextFormField(
        keyboardType: textInputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          icon: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Icon(icon),
          ),
        ),
        controller: controller,
        initialValue: value,
        validator: (val) {
          if (val.length < 1)
            return "$labelText jangan dikosongkan.";
          else
            return null;
        },
        onChanged: (val) => onChange(val));

Widget makeTextTableStyle(BuildContext context,
        {@required String caption,
        @required String content,
        TextStyle leftTextStyle = const TextStyle(),
        TextStyle rightTextStyle = const TextStyle(),
        int leftFlex = 5,
        int rightFlex = 5}) =>
    Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: leftFlex,
            child: Text(caption,
                style: TextStyle(color: Theme.of(context).colorScheme.primary)
                    .merge(leftTextStyle)),
          ),
          Expanded(
            flex: rightFlex,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                content,
                textAlign: TextAlign.right,
                style: rightTextStyle,
              ),
            ),
          )
        ],
      ),
    );

Widget captionWithIcon({@required String caption, @required IconData icon}) =>
    Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            icon,
            size: 36,
          ),
        ),
        Text(caption)
      ],
    );
