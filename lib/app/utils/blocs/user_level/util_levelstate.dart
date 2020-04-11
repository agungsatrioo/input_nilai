import 'package:equatable/equatable.dart';

abstract class UserLevelState extends Equatable {
  const UserLevelState();

  @override
  List<Object> get props => [];
}

class InitializingState extends UserLevelState {}

class UserLevelDosen extends UserLevelState {}

class UserLevelMahasiswa extends UserLevelState {}
