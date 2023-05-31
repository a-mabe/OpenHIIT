import 'package:flutter/material.dart';
import '../start_workout/workout.dart';
import '../workout_type/workout_type.dart';

class RouterHelper {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/workout':
        var workout = settings.arguments as Workout;
        return MaterialPageRoute(
            builder: (_) => CountDownTimer(
                  workout: workout,
                ));
      // case '/workout':
      //   return MaterialPageRoute(builder: (_) => CountDownTimer(workout: null,));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
