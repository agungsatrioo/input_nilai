import 'package:flutter/widgets.dart';

class WidgetFromTypeBuilder extends StatelessWidget {
  var object;
  Map<Type, Widget> children;

  WidgetFromTypeBuilder(
      {@required object, @required Map<Type, Widget> children});

  @override
  Widget build(BuildContext context) {
    print("Build");

    print(children);

    children.removeWhere((key, value) => object != key);

    print(children);

    if (children.isNotEmpty) {
      return children[0];
    } else {
      return Container();
    }
  }
}
