import 'package:appCRSM/data/repositories/user_repository.dart';
import 'package:appCRSM/presentation/features/authentication/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'sign_in.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  UserRepository _userRepository;
  final AuthenticationBloc authenticationBloc;

  SignInBloc({
    @required this.authenticationBloc,
    @required UserRepository userRepository,
  })  : assert(authenticationBloc != null),
        assert(userRepository != null),
        _userRepository = userRepository;

  @override
  SignInState get initialState => SignInInitialState();

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    // normal sign in
    // if (event is SignInPressed) {
    //   yield SignInProcessingState();
    //   try {
    //     var token = await userRepository.signIn(
    //       email: event.email,
    //       password: event.password,
    //     );
    //     authenticationBloc.add(LoggedIn(token));
    //     yield SignInFinishedState();
    //   } catch (error) {
    //     yield SignInErrorState(error);
    //   }
    // }

    // sign in with facebook
    // if (event is SignInPressedFacebook) {
    //   yield SignInProcessingState();
    //   try {
    //     await Future.delayed(
    //       Duration(milliseconds: 300),
    //     ); //TODO use real auth service

    //     yield SignInFinishedState();
    //   } catch (error) {
    //     yield SignInErrorState(error);
    //   }
    // }

    // sign in with google
    if (event is SignInPressedGoogle) {
      yield SignInProcessingState();
      try {
        // await Future.delayed(
        //   Duration(milliseconds: 1000),
        // ); //TODO use real auth service
        final token = await _userRepository.signInWithGoogle();
        authenticationBloc.add(LoggedIn(token));
        yield SignInFinishedState();
      } catch (error) {
        yield SignInErrorState(error);
      }
    }
  }
}
