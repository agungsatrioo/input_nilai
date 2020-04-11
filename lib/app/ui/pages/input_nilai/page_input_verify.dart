import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:input_nilai/app/utils/util_constants.dart';
import 'package:input_nilai/app/utils/util_useragent.dart';
import 'package:line_icons/line_icons.dart';

class InputVerifyPage extends StatefulWidget {
  String message;

  InputVerifyPage({this.message});

  @override
  State<StatefulWidget> createState() => _InputVerifyPageState(this.message);
}

class _InputVerifyPageState extends State<InputVerifyPage> {
  String message;
  final _passwordController = TextEditingController();

  final _passKey = GlobalKey<FormState>();

  bool _obscureText = true, logout = false;
  UserAgent _ua;
  bool _isVerifying = false;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _InputVerifyPageState(this.message);

  @override
  void initState() {
    super.initState();

    _ua = UserAgent();
  }

  login(BuildContext scaffoldContext) async {
    toggleVerifying();

    await _ua.user_id.then((val) {
      _ua
          .login(APP_REST_URL + "auth", val, _passwordController.value.text)
          .then((response) async {
        toggleVerifying();
        Navigator.of(context).pop(true);
      }).catchError((onError) {
        toggleVerifying();
        print("Salah login");

        Scaffold.of(scaffoldContext).showSnackBar(SnackBar(
          content: Text('${onError.toString().replaceFirst("Exception:", "")}'),
          backgroundColor: Colors.red,
        ));
      });
    });
  }

  toggleVerifying() {
    setState(() {
      _isVerifying = !_isVerifying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Builder(
          builder: (ctx) => AppBar(
            title: Text("Verifikasi identitas Anda"),
            actions: <Widget>[
              IconButton(
                icon: _isVerifying
                    ? SizedBox(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                        height: 24.0,
                        width: 24.0,
                      )
                    : Icon(LineIcons.check),
                onPressed: () {
                  if (!_isVerifying && _passKey.currentState.validate())
                    login(ctx);
                },
              )
            ],
            elevation: 0,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "$message. Harap masukkan kata sandi untuk membuktikan bahwa ini memang Anda."),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
