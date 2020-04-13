import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:input_nilai/app/ui/pages/page_login.dart';
import 'package:input_nilai/app/utils/util_theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:theme_provider/theme_provider.dart';

import 'app/ui/pages/page_home.dart';
import 'app/ui/pages/page_splash.dart';
import 'app/ui/widgets/widget_loading.dart';
import 'app/utils/blocs/auth/util_authevent.dart';
import 'app/utils/blocs/auth/util_authstate.dart';
import 'app/utils/util_blocs.dart';
import 'app/utils/util_users.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: Phoenix(child: App(userRepository: userRepository)),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key) {
    initializeDateFormatting("id");
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: initAppThemes(),
      child: MaterialApp(
        title: 'Input Nilai',
        home: ThemeConsumer(
          child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is AuthenticationUninitialized) {
                return SplashPage();
              }
              if (state is AuthenticationAuthenticated) {
                return HomePage();
              }
              if (state is AuthenticationUnauthenticated) {
                return LoginPageBloc(userRepository: userRepository);
              }
              if (state is AuthenticationLoading) {
                return LoadingIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}