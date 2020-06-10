import 'package:appCRSM/config/routes.dart';
import 'package:appCRSM/presentation/features/authentication/authentication.dart';
import 'package:appCRSM/presentation/features/test_with_params/test_with_params_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomeScreen extends StatefulWidget {
  MyHomeScreen({Key key, this.title = "Home"}) : super(key: key);

  final String title;

  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  void _routeToTest() {
    Navigator.of(context).pushNamed(AppRoutes.test);
  }

  void _routeToTestWithParams() {
    Navigator.of(context).pushNamed(AppRoutes.test_with_params,
        arguments: TestWithParamsParameters(10));
  }

  void _routeToTestWebView() {
    Navigator.of(context).pushNamed(AppRoutes.test_web_view);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(
                LoggedOut(),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Hello World ${widget.title}",
            ),
            RaisedButton(
              onPressed: _routeToTest,
              child: Icon(Icons.add),
            ),
            RaisedButton(
              onPressed: _routeToTestWithParams,
              child: Text(
                'with params',
              ),
            ),
            RaisedButton(
              onPressed: _routeToTestWebView,
              child: Text(
                'web view',
              ),
            )
          ],
        ),
      ),
    );
  }
}
