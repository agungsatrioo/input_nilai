import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';

import '../../utils/blocs/login/util_loginevent.dart';
import '../../utils/blocs/login/util_loginstate.dart';
import '../../utils/util_blocs.dart';
import '../widgets/widget_boolean_builder.dart';
import '../widgets/widget_buttons.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true, logout = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error.replaceFirst("Exception:", "")}'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is LoginLoading) {}
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset("assets/images/icon.png", scale: 5),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Sistem Penilaian Sidang FISIP UIN Bandung"),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "NIM/NIK/NIP/NIDN/ID Dosen",
                      icon: const Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: const Icon(LineIcons.user),
                      ),
                    ),
                    validator: (val) {
                      if (val.length < 1)
                        return "NIM/NIK/NIP/NIDN/ID Dosen jangan dikosongkan.";
                      else
                        return null;
                    },
                    controller: _usernameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Kata Sandi",
                      icon: const Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: const Icon(LineIcons.lock),
                      ),
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildBooleanWidget(
                    boolean: state is LoginLoading, 
                    ifTrue: CircularProgressIndicator(), 
                    ifFalse: MyButton.primary(
                      buttonWidth: double.infinity,
                      caption: "Login", 
                      onTap: () => _onLoginButtonPressed()
                    )
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
