import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/util_blocs.dart';
import '../../utils/util_users.dart';
import '../forms/form_login.dart';

class LoginPageBloc extends StatelessWidget {
  final UserRepository userRepository;

  LoginPageBloc({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: BlocProvider(
                create: (context) {
                  return LoginBloc(
                    authenticationBloc:
                        BlocProvider.of<AuthenticationBloc>(context),
                    userRepository: userRepository,
                  );
                },
                child: LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
