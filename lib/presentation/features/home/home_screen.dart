import 'package:app/config/routes.dart';
import 'package:app/presentation/features/test_with_params/test_with_params_screen.dart';
import 'package:flutter/material.dart';

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
    Navigator.of(context)
        .pushNamed(AppRoutes.test_with_params, arguments: TestWithParamsParameters(10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Hello World",
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
            )
          ],
        ),
      ),
    );
  }
}
