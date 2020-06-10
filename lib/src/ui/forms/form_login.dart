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

  _showHelpDosen(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isDismissible: true,
      builder: (context) {
        return Container(
            padding: EdgeInsets.all(10.0),
            child: Wrap(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Bantuan untuk login sebagai dosen", style: Theme.of(context).textTheme.headline6,),

                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Jika Anda sebagai dosen mengalami kesulitan ketika masuk ke dalam sistem, harap coba cara-cara berikut:\n\n- Tambahkan prefiks \"id_dosen~\", \"nip~\", \"nik~\", atau \"nidn~\" (tanpa tanda kutip) sebelum ID Dosen/NIP/NIK/NIDN (~ adalah tanda alis).\nContoh: Dosen dengan NIP 7701 dapat masuk ke sistem dengan mengetikkan \"nip~7701\" (tanpa tanda kutip) di kotak teks identitas.\n\n- Jika masalah masih berlanjut, harap hubungi administrator SIPADANG untuk penjelasan lebih lanjut."),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: MyButton.primary(
                              caption: "OK",
                              onTap: () => Navigator.of(context).pop(true))),
                    ],
                  ),
                )
              ],
            ));
      },
    );
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
              mainAxisSize: MainAxisSize.min,
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
                  padding:
                      EdgeInsets.only(bottom: 4, left: 4, right: 4, top: 8),
                  child: SingleChildBooleanWidget(
                      boolean: state is LoginLoading,
                      ifTrue: CircularProgressIndicator(),
                      ifFalse: MyButton.primary(
                          buttonWidth: double.infinity,
                          caption: "Login",
                          onTap: () => _onLoginButtonPressed())),
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 4, left: 4, right: 4),
                    child: Visibility(
                        visible: !(state is LoginLoading),
                        child: MyButton.flatPrimary(
                            buttonWidth: double.infinity,
                            caption: "Bantuan Login Sebagai Dosen?",
                            onTap: () => _showHelpDosen(context)))),
              ],
            ),
          );
        },
      ),
    );
  }
}
