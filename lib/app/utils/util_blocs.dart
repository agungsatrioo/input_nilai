import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'blocs/auth/util_authevent.dart';
import 'blocs/auth/util_authstate.dart';
import 'blocs/login/util_loginevent.dart';
import 'blocs/login/util_loginstate.dart';
import 'blocs/user_level/util_levelevent.dart';
import 'blocs/user_level/util_levelstate.dart';
import 'util_constants.dart';
import 'util_useragent.dart';
import 'util_users.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      await Future.delayed(Duration(seconds: 3));

      final bool hasToken = await userRepository.hasToken();

      if (hasToken) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await userRepository.writeUser(event.user);
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.deleteUser();
      yield AuthenticationUnauthenticated();
    }
  }
}

//End of AuthBloc

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        print("Getting login...");

        final token = await userRepository.authenticate(
          username: event.username,
          password: event.password,
        );

        print("The token is: $token");

        authenticationBloc.add(LoggedIn(user: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}

//end of login bloc
class UserLevelBloc extends Bloc<UserLevelEvent, UserLevelState> {
  UserAgent userAgent;

  UserLevelBloc({@required this.userAgent}) : assert(userAgent != null);

  UserLevelState get initialState => InitializingState();

  @override
  Stream<UserLevelState> mapEventToState(UserLevelEvent event) async* {
    final level = await userAgent.user_level;

    switch (level) {
      case APP_LEVEL_DOSEN:
        yield UserLevelDosen();
        break;
      case APP_LEVEL_MAHASISWA:
        yield UserLevelMahasiswa();
        break;
    }
  }
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}
