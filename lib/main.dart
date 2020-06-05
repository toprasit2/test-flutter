import 'package:app/config/routes.dart';
import 'package:app/presentation/features/home/home.dart';
import 'package:app/presentation/features/test/test.dart';
import 'package:app/presentation/features/test_with_params/test_with_params.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
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
      AppRoutes.test: (context) => TestScreen(title: 'TEST Page')
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
}
