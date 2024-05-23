part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class UseAbilityGameEvent extends GameEvent {}

class UserMoving extends GameEvent {
  final int newUserPosition;

  UserMoving(this.newUserPosition);
}

class ContinueGameEvent extends GameEvent {
  final double? jackpotCoefficient;
  final Artifact? artifact;

  ContinueGameEvent({this.jackpotCoefficient, this.artifact});
}

class InitGameEvent extends GameEvent {}

class FinishGameEvent extends GameEvent {}

class RestartGameEvent extends GameEvent {}

class ChangePersonEvent extends GameEvent {
  final PlayerSkin playerSkin;

  ChangePersonEvent(this.playerSkin);
}

class _UpdateTimerGameEvent extends GameEvent {}
