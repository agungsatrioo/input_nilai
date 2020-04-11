import 'package:equatable/equatable.dart';

abstract class UserLevelEvent extends Equatable {
  const UserLevelEvent();

  @override
  List<Object> get props => [];
}

class InitLevelEvent extends UserLevelEvent {}
