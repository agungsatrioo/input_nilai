import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:theme_provider/theme_provider.dart';

import 'src/ui/pages/page_ganti_password.dart';
import 'src/ui/pages/page_home.dart';
import 'src/ui/pages/page_login.dart';
import 'src/ui/pages/page_splash.dart';
import 'src/ui/widgets/widget_loading.dart';
import 'src/utils/blocs/auth/util_authevent.dart';
import 'src/utils/blocs/auth/util_authstate.dart';
import 'src/utils/util_blocs.dart';
import 'src/utils/util_theme.dart';
import 'src/utils/util_users.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();

  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(userRepository: userRepository)
          ..add(AppStarted());
      },
      child: Phoenix(child: MyApp(userRepository: userRepository)),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key key, @required this.userRepository}) : super(key: key) {
    initializeDateFormatting("id");
  }

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: initAppThemes(),
        child: ThemeConsumer(
            child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data.copyWith(
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: <TargetPlatform, PageTransitionsBuilder>{
                      TargetPlatform.android: ZoomPageTransitionsBuilder(),
                    },
                  ),
                ),
            title: 'Input Nilai',
            home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: ThemeProvider.themeOf(themeContext).data.appBarTheme.brightness,
              ),
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                // ignore: missing_return
                builder: (context, state) {
                  if (state is AuthenticationUninitialized) {
                    return SplashPage();
                  }
                  if (state is AuthenticationAuthenticated) {
                    return HomePage();
                  }
                  if (state is AuthenticationFirstTime) {
                    return GantiPasswordPage();
                  }
                  if (state is AuthenticationUnauthenticated) {
                    return LoginPageBloc(userRepository: userRepository);
                  }
                  if (state is AuthenticationLoading) {
                    return LoadingPage();
                  }
                },
              ),
            ),
          ),
        )));
  }
}