// import 'dart:convert';

// import 'package:background_hiit_timer/models/interval_type.dart';
// import 'package:openhiit/data/timer_type.dart';
// import 'package:openhiit/data/workout_type.dart';
// import 'package:openhiit/providers/workout_provider.dart';
// import 'package:openhiit/utils/database/database_manager.dart';
// import 'package:openhiit/utils/import_export/local_file_util.dart';
// import 'package:path/path.dart';
// import 'package:provider/provider.dart';

// class WorkoutTypeMigration {
//   Future migrateToInterval(Workout workout, bool update) async {
//     DatabaseManager dbManager = DatabaseManager();
//     List<IntervalType> intervals = [];
//     List<String> exercises =
//         workout.exercises != "" ? jsonDecode(workout.exercises) : [];
//     int currentIndex = 0; // Track the index of each interval

//     logger.d("Exercises: $exercises");

//     // Add get ready interval if time is non-zero
//     if (workout.getReadyTime > 0) {
//       intervals.add(IntervalType(
//         id: "${workout.id}_get_ready",
//         workoutId: workout.id,
//         time: workout.getReadyTime,
//         name: "Get Ready",
//         color: workout.colorInt,
//         intervalIndex: currentIndex++,
//         startSound: "",
//         countdownSound: workout.countdownSound,
//         halfwaySound: "",
//         endSound: "",
//       ));
//     }

//     // Add warmup interval if time is non-zero
//     if (workout.warmupTime > 0) {
//       intervals.add(IntervalType(
//         id: "${workout.id}_warmup",
//         workoutId: workout.id,
//         time: workout.warmupTime,
//         name: "Warmup",
//         color: workout.colorInt,
//         intervalIndex: currentIndex++,
//         startSound: workout.workSound, // Warmup uses work sound
//         countdownSound: workout.countdownSound,
//         halfwaySound: "",
//         endSound: "",
//       ));
//     }

//     logger.d(workout.iterations);

//     // Loop for each iteration
//     int iteration = 0;
//     do {
//       int exerciseIndex = 0;
//       for (int i = 0; i < workout.numExercises; i++) {
//         // Add work interval
//         if (workout.workTime > 0) {
//           intervals.add(IntervalType(
//             id: "${workout.id}_work_${iteration}_$i",
//             workoutId: workout.id,
//             time: workout.workTime,
//             name: (exercises.isEmpty || exerciseIndex > exercises.length)
//                 ? "Work"
//                 : exercises[exerciseIndex++],
//             color: workout.colorInt,
//             intervalIndex: currentIndex++,
//             startSound: workout.workSound,
//             countdownSound: workout.countdownSound,
//             halfwaySound: workout.halfwaySound,
//             endSound: workout.completeSound,
//           ));
//         }

//         // Add rest interval
//         if (workout.restTime > 0) {
//           intervals.add(IntervalType(
//             id: "${workout.id}_rest_${iteration}_$i",
//             workoutId: workout.id,
//             time: workout.restTime,
//             name: "Rest",
//             color: workout.colorInt,
//             intervalIndex: currentIndex++,
//             startSound: workout.restSound,
//             countdownSound: workout.countdownSound,
//             halfwaySound: "",
//             endSound: "",
//           ));
//         }
//       }

//       // Add break interval if time is non-zero, but only between iterations
//       if (workout.breakTime > 0 && iteration < workout.iterations - 1) {
//         intervals.add(IntervalType(
//           id: "${workout.id}_break_$iteration",
//           workoutId: workout.id,
//           time: workout.breakTime,
//           name: "Break",
//           color: workout.colorInt,
//           intervalIndex: currentIndex++,
//           startSound: workout.restSound,
//           countdownSound: workout.countdownSound,
//           halfwaySound: "",
//           endSound: "",
//         ));
//       }

//       iteration++;
//     } while (iteration < workout.iterations);

//     // Add cooldown interval if time is non-zero
//     if (workout.cooldownTime > 0) {
//       intervals.add(IntervalType(
//         id: "${workout.id}_cooldown",
//         workoutId: workout.id,
//         time: workout.cooldownTime,
//         name: "Cooldown",
//         color: workout.colorInt,
//         intervalIndex: currentIndex++,
//         startSound: workout.restSound, // Cooldown uses rest sound
//         countdownSound: workout.countdownSound,
//         halfwaySound: "",
//         endSound: workout.completeSound,
//       ));
//     }

//     logger.d("Migrating workout to intervals: ${workout.title}");
//     for (var interval in intervals) {
//       logger.d(interval);
//     }

//     if (update) {
//       dbManager.updateIntervals(intervals);
//     } else {
//       dbManager.insertIntervals(intervals);
//     }
//   }

//   Future migrateToTimer(Workout workout, bool update) async {
//     DatabaseManager dbManager = DatabaseManager();

//     int totalIntervals = workout.iterations > 0
//         ? workout.numExercises * workout.iterations
//         : workout.numExercises;
//     int totalTime = calculateTotalTime(workout);
//     TimerType timer = TimerType(
//         id: workout.id,
//         name: workout.title,
//         timerIndex: workout.workoutIndex,
//         color: workout.colorInt,
//         intervals: totalIntervals,
//         workIntervals: workout.numExercises,
//         totalTime: totalTime);

//     logger.d("Migrating workout to timer: ${workout.title}");
//     logger.d(timer);

//     if (update) {
//       dbManager.updateTimer(timer);
//     } else {
//       List<TimerType> existingTimers = await dbManager.getTimers();
//       for (var existingTimer in existingTimers) {
//         existingTimer.timerIndex += 1;
//         dbManager.updateTimer(existingTimer);
//       }
//       dbManager.insertTimer(timer);
//     }
//   }

//   int calculateTotalTime(Workout workout) {
//     int totalTime = 0;

//     // Add get ready time
//     totalTime += workout.getReadyTime;

//     // Add warmup time
//     totalTime += workout.warmupTime;

//     // Add work and rest time for each iteration
//     int iteration = 0;
//     do {
//       for (int i = 0; i < workout.numExercises; i++) {
//         totalTime += workout.workTime;
//         totalTime += workout.restTime;
//       }

//       // Add break time if not last iteration
//       if (iteration < workout.iterations - 1) {
//         totalTime += workout.breakTime;
//       }

//       iteration++;
//     } while (iteration < workout.iterations);

//     // Add cooldown time
//     totalTime += workout.cooldownTime;

//     return totalTime;
//   }
// }
