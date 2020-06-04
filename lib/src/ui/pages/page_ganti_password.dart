import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_nilai/src/ui/pages/page_home.dart';
import 'package:input_nilai/src/utils/blocs/auth/util_authevent.dart';
import 'package:input_nilai/src/utils/util_blocs.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/util_constants.dart';
import '../../utils/util_useragent.dart';
import '../widgets/widget_boolean_builder.dart';

class GantiPasswordPage extends StatefulWidget {
  GantiPasswordPage();

  @override
  State<StatefulWidget> createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
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

  @override
  void initState() {
    super.initState();

    _ua = UserAgent();
  }

  login(BuildContext scaffoldContext) async {
    toggleVerifying();

    await _ua.user.then((val) {
      _ua
          .changePassword("${val.userIdentity}",
              _passwordController.value.text, val.token)
          .then((response) async {
        toggleVerifying();

        BlocProvider.of<AuthenticationBloc>(context)
                        .add(PasswordChanged());
                        
      }).catchError((onError) {
        toggleVerifying();

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
            title: Text("Ganti Kata Sandi Anda"),
            actions: <Widget>[
              IconButton(
                icon: SingleChildBooleanWidget(
                    boolean: _isVerifying,
                    ifTrue: SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                      height: 24.0,
                      width: 24.0,
                    ),
                    ifFalse: Icon(LineIcons.check)),
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
                  "Kelihatannya Anda baru pertama kali masuk ke aplikasi ini. Untuk keamanan Anda, silakan ganti kata sandi."),
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
