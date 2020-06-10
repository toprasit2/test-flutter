import 'package:app/config/routes.dart';
import 'package:app/data/repositories/user_repository.dart';
import 'package:app/presentation/features/authentication/authentication.dart';
import 'package:app/presentation/features/home/home.dart';
import 'package:app/presentation/features/sign_in/sign_in.dart';
import 'package:app/presentation/features/splash/splash.dart';
import 'package:app/presentation/features/test_with_params/test_with_params.dart';
import 'package:app/presentation/features/test/test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  final UserRepository userRepository = UserRepository();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiRepositoryProvider(
        providers: [
          RepositoryProvider<UserRepository>(
            create: (context) => UserRepository(),
          ),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider<AuthenticationBloc>(
              create: (context) => AuthenticationBloc(
                  userRepository:
                      RepositoryProvider.of<UserRepository>(context))
                ..add(AppStarted())),
        ], child: MyApp())),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRSM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: _registerRoutes(),
      onGenerateRoute: _registerRoutesWithParameters,
    );
  }

  Map<String, WidgetBuilder> _registerRoutes() {
    return <String, WidgetBuilder>{
      AppRoutes.home: (context) => MyHomeScreen(),
      // AppRoutes.test: (context) => TestScreen(title: 'TEST Page')
      AppRoutes.test: (context) => _authGuard(TestScreen(title: 'READY AUTH')),
    };
  }

  Route _registerRoutesWithParameters(RouteSettings settings) {
    if (settings.name == AppRoutes.test_with_params) {
      final TestWithParamsParameters args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) {
          return TestWithParamsScreen(
            title: 'TEST Params Page',
            parameters: args,
          );
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          return MyHomeScreen();
        },
      );
    }
  }

  BlocBuilder<AuthenticationBloc, AuthenticationState> _authGuard(widget) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is Authenticated) {
        return widget;
      } else if (state is Unauthenticated) {
        return _buildSignInBloc();
      } else {
        return SplashScreen();
      }
    });
  }

  BlocProvider<SignInBloc> _buildSignInBloc() {
    return BlocProvider<SignInBloc>(
      create: (context) => SignInBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: SignInScreen(),
    );
  }
}
