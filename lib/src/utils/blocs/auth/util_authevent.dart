import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../models/model_session.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final UserModel user;

  const LoggedIn({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoggedIn { token: ${user.token.substring(0, 7)} }';
}

class LoggedOut extends AuthenticationEvent {}

class PasswordChanged extends AuthenticationEvent {}
