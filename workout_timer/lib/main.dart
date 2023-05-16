import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'create_workout/create_workout.dart';
import 'workout_type/workout_type.dart';
import 'database/database_manager.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const WorkoutTimer());
}

class WorkoutTimer extends StatelessWidget {
  const WorkoutTimer({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Workout>> workouts =
      DatabaseManager().lists(DatabaseManager().initDB());

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
  // final List<Workout> workouts = [Workout.empty()];

  void createWorkoutPage() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateWorkout()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: createWorkoutPage,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ),
    //   body: FutureBuilder<List<Workout>>(
    //     future: workouts,
    //     builder: (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
    //       List<Widget> children;
    //       // If data was loaded successfully...
    //       if (snapshot.hasData) {
    //         children = <Widget>[
    //           ListView.separated(
    //             scrollDirection: Axis.vertical,
    //             shrinkWrap: true,
    //             padding: const EdgeInsets.all(0),
    //             itemCount: snapshot.data!.length,
    //             itemBuilder: (BuildContext context, int index) {
    //               return Container(
    //                 height: 100,
    //                 color: Colors.amber[colorCodes[index]],
    //                 child: Column(children: [
    //                   Text(snapshot.data![index].title),
    //                   Text(snapshot.data![index].exercises),
    //                   Text(snapshot.data![index].exerciseTime.toString()),
    //                   Text(snapshot.data![index].restTime.toString()),
    //                   Text(snapshot.data![index].halfTime.toString())
    //                 ]),
    //               );
    //             },
    //             separatorBuilder: (BuildContext context, int index) =>
    //                 const Divider(),
    //           ),
    //           // floatingActionButton: FloatingActionButton(
    //           //   onPressed: createWorkoutPage,
    //           //   tooltip: 'Increment',
    //           //   child: const Icon(Icons.add),
    //           // ),
    //           // const Icon(
    //           //   Icons.check_circle_outline,
    //           //   color: Colors.green,
    //           //   size: 60,
    //           // ),
    //           // Padding(
    //           //   padding: const EdgeInsets.only(top: 16),
    //           //   child: Text('Result: ${snapshot.data}'),
    //           // ),
    //         ];
    //       }
    //       // If there was an error loading the data...
    //       else if (snapshot.hasError) {
    //         children = <Widget>[
    //           const Icon(
    //             Icons.error_outline,
    //             color: Colors.red,
    //             size: 60,
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 16),
    //             child: Text('Error: ${snapshot.error}'),
    //           ),
    //         ];
    //       }
    //       // If the data is still being fetched...
    //       else {
    //         children = const <Widget>[
    //           SizedBox(
    //             width: 60,
    //             height: 60,
    //             child: CircularProgressIndicator(),
    //           ),
    //           Padding(
    //             padding: EdgeInsets.only(top: 16),
    //             child: Text('Awaiting result...'),
    //           ),
    //         ];
    //       }
    //       return Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: children,
    //         ),
    //       );
    //     },
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Workout>>(
          future: workouts,
          builder:
              (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
            List<Widget> children;
            children = <Widget>[
              ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 100,
                    color: Colors.amber[colorCodes[index]],
                    child: const Column(children: [
                      Text("weee"),
                    ]),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ];
            return ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 100,
                  color: Colors.amber[colorCodes[index]],
                  child: const Column(children: [
                    Text("weee"),
                  ]),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          }

          // body: Center(
          //   // Center is a layout widget. It takes a single child and positions it
          //   // in the middle of the parent.
          //   child: ListView.separated(
          //     padding: const EdgeInsets.all(8),
          //     itemCount: 2,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Container(
          //         height: 100,
          //         color: Colors.amber[colorCodes[index]],
          //         child: const Column(children: [
          //           Text("weee"),
          //         ]),
          //       );
          //     },
          //     separatorBuilder: (BuildContext context, int index) =>
          //         const Divider(),
          //   ),
          // ),
          // This trailing comma makes auto-formatting nicer for build methods.
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: createWorkoutPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
