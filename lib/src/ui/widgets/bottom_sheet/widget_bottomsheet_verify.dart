import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/src/utils/util_colors.dart';
import 'package:input_nilai/src/utils/util_constants.dart';
import 'package:input_nilai/src/utils/util_useragent.dart';
import 'package:line_icons/line_icons.dart';
import 'package:theme_provider/theme_provider.dart';

import '../widget_basic.dart';
import '../widget_buttons.dart';

Future<bool> showUserVerifyBottomSheet(BuildContext context,
    {@required Color yesColor,
    Color yesTextColor,
    @required Color noColor,
    Color noTextColor,
    Widget message = const Text("Masukkan kata sandi Anda untuk melanjutkan."),
    bool isDismissible = true}) async {
  String query = "";

  return showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Wrap(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 5.0, color: Colors.grey),
                    ),
                    height: 8,
                  ),
                  _PasswordWithToggle(
                    noColor:
                        ThemeProvider.themeOf(context).data.colorScheme.surface,
                    yesColor: colorGreenStd,
                    message: message,
                    noTextColor: ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .onSurface,
                    onVerifyResult: (val) {
                      print("Refresh jangan? ${val}");
                      Navigator.of(context).pop(val);
                    },
                  )
                ],
              ),
            ));
      });
}

class _PasswordWithToggle extends StatefulWidget {
  Function(bool) onVerifyResult;
  final Color yesColor, yesTextColor, noColor, noTextColor;
  final Widget message;

  _PasswordWithToggle(
      {@required this.yesColor,
      this.yesTextColor,
      @required this.noColor,
      this.noTextColor,
      this.message = const Text("Masukkan kata sandi Anda untuk melanjutkan."),
      @required this.onVerifyResult});

  @override
  State<StatefulWidget> createState() => _PasswordWithToggleState(
      yesColor: yesColor,
      noColor: noColor,
      yesTextColor: yesTextColor,
      noTextColor: noTextColor,
      message: message,
      onVerifyResult: onVerifyResult);
}

class _PasswordWithToggleState extends State<_PasswordWithToggle> {
  Function(bool) onVerifyResult;
  final Color yesColor, yesTextColor, noColor, noTextColor;
  Widget message;

  _PasswordWithToggleState(
      {@required this.yesColor,
      @required this.yesTextColor,
      @required this.noColor,
      @required this.noTextColor,
      @required this.message,
      @required this.onVerifyResult});

  final _passwordController = TextEditingController();

  final _passKey = GlobalKey<FormState>();

  bool _obscureText = true, wrongPass = false;
  UserAgent _ua;
  bool _isVerifying = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    _ua = UserAgent();
  }

  login() async {
    toggleVerifying();

    await _ua.user_id.then((val) {
      _ua
          .login(APP_REST_URL + "auth", val, _passwordController.value.text)
          .then((response) async {
        toggleVerifying();

        onVerifyResult(true);
      }).catchError((onError) {
        toggleVerifying();
        salahPassword();
      });
    });
  }

  toggleVerifying() {
    setState(() {
      _isVerifying = !_isVerifying;
    });
  }

  salahPassword() {
    setState(() {
      message = Text(
        "Kata sandi Anda salah. Silakan coba kembali.",
        style: TextStyle(
            color: ThemeProvider.themeOf(context).data.colorScheme.error),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 5.0), child: message),
          Form(
            key: _passKey,
            child: Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Kata Sandi",
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _obscureText ? LineIcons.eye : LineIcons.eye_slash,
                    ),
                    onPressed: () {
                      _toggle();
                    },
                  ),
                ),
                validator: (val) {
                  if (val.length < 1)
                    return "Kata sandi jangan dikosongkan.";
                  else if (val.length >= 1 && val.length < 3)
                    return "Kata sandi jangan terlalu pendek.";
                  else
                    return null;
                },
                obscureText: _obscureText,
                controller: _passwordController,
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _isVerifying
                  ? [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        child: CircularProgressIndicator(),
                      )
                    ]
                  : [
                      Expanded(
                          child: MyButton.secondary(
                              caption: "Konfirmasi", onTap: () {
                            if (_passKey.currentState.validate()) {
                              login();
                            }
                          })
                      ),
                      Expanded(
                          child: MyButton.flat(caption: "Batalkan", onTap: () {
                            onVerifyResult(false);
                          })
                      ),
                    ])
        ],
      ),
    );
  }

  Widget buixld(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Form(
            key: _passKey,
            child: TextFormField(
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Kata Sandi",
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _obscureText ? LineIcons.eye : LineIcons.eye_slash,
                  ),
                  onPressed: () {
                    _toggle();
                  },
                ),
              ),
              validator: (val) {
                if (val.length < 1)
                  return "Kata sandi jangan dikosongkan.";
                else if (val.length >= 1 && val.length < 3)
                  return "Kata sandi jangan terlalu pendek.";
                else
                  return null;
              },
              obscureText: _obscureText,
              controller: _passwordController,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: makeButton(context, "Konfirmasi",
                      buttonColor: yesColor,
                      textColor: yesTextColor, onTap: () {
                onVerifyResult(true);
              })),
              Expanded(
                  child: makeButton(context, "Batal",
                      buttonColor: noColor,
                      textColor: noTextColor,
                      onTap: onVerifyResult(false))),
            ],
          )
        ],
      ),
    );
  }
}
