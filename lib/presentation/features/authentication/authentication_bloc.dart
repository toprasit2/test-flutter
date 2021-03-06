import 'package:appCRSM/config/storage.dart';
import 'dart:async';
import 'package:appCRSM/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    // app start
    if (event is AppStarted) {
      // var token = await _getToken();
      // if (token != '') {
      //   Storage().token = token;
      //   yield Authenticated();
      // } else {
      //   yield Unauthenticated();
      // }
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final name = await _userRepository.getUser();
        yield Authenticated(name);
      } else {
        yield Unauthenticated();
      }
    }

    if (event is LoggedIn) {
      // yield Loading();
      Storage().token = event.token;
      await _saveToken(event.token);
      final name = await _userRepository.getUser();
      yield Authenticated(name);
    }

    if (event is LoggedOut) {
      // yield Loading()
      Storage().token = '';
      await _deleteToken();
      await _userRepository.signOut();
      yield Unauthenticated();
    }
  }

  /// delete from keystore/keychain
  Future<void> _deleteToken() async {
    await Storage().secureStorage.delete(key: 'access_token');
  }

  /// write to keystore/keychain
  Future<void> _saveToken(String token) async {
    await Storage().secureStorage.write(key: 'access_token', value: token);
  }

  /// read to keystore/keychain
  Future<String> _getToken() async {
    return await Storage().secureStorage.read(key: 'access_token') ?? '';
  }
}
