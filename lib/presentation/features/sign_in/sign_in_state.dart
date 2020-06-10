import 'package:equatable/equatable.dart';

abstract class SignInState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignInInitialState extends SignInState {}

class SignInProcessingState extends SignInState {}

class SignInErrorState extends SignInState {
  final Object error;

  SignInErrorState(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return '$error';
  }
}

class SignInFinishedState extends SignInState {}
