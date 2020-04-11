import 'package:equatable/equatable.dart';
import 'package:input_nilai/app/models/model_session.dart';
import 'package:meta/meta.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final User user;

  const LoggedIn({@required this.user});

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoggedIn { token: ${user.identity} }';
}

class LoggedOut extends AuthenticationEvent {}
