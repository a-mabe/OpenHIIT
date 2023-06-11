import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../database/database_manager.dart';
import '../workout_type/workout_type.dart';
import 'workout.dart';

class ViewWorkout extends StatelessWidget {
  ViewWorkout({super.key});

  Future<Database> database = DatabaseManager().initDB();

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Show Snackbar',
            onPressed: () async {
              await DatabaseManager()
                  .deleteList(workoutArgument.id, database)
                  .then((value) {
                Navigator.pop(context);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              print(workoutArgument);
            },
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: Colors.red,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, "/workout",
                      //     arguments: workoutArgument);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StartWorkout(),
                          settings: RouteSettings(
                            arguments: workoutArgument,
                          ),
                        ),
                      );
                    },
                    child: Ink(
                        height: 80.0,
                        width: MediaQuery.of(context).size.width * 0.25,
                        color: Colors.green,
                        child: const Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                            ),
                            Text("Start")
                          ],
                        ))),
                  ),
                ),
                // Container(

                //   decoration: const BoxDecoration(
                //     color: Color(0xff7c94b6),
                //   ),
                // )
                // Container(
                //   color: Color.fromARGB(255, 23, 178, 189),
                //   height: 4.0,
                // ),
              ],
            )

            // Container(
            //   color: Color.fromARGB(255, 23, 178, 189),
            //   height: 4.0,
            // ),
            ),
        // PreferredSize(
        //   preferredSize: const Size.fromHeight(80.0),
        //   child: Row(
        //     children: <Widget>[
        //       Expanded(
        //         flex: 1,
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.25,
        //           color: Colors.greenAccent,
        //         ),
        //       ),
        //       Expanded(
        //         flex: 1,
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.25,
        //           color: Colors.yellow,
        //         ),
        //       ),
        //       Expanded(
        //         flex: 1,
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.25,
        //           color: Colors.purple,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
      body: const Center(
        child: ViewWorkoutExercises(),
      ),
    );
  }
}

class ViewWorkoutExercises extends StatefulWidget {
  const ViewWorkoutExercises({super.key});

  @override
  ViewWorkoutExercisesState createState() => ViewWorkoutExercisesState();
}

class ViewWorkoutExercisesState extends State<ViewWorkoutExercises> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    Workout workoutArgument =
        ModalRoute.of(context)!.settings.arguments as Workout;

    List<dynamic> exercises = jsonDecode(workoutArgument.exercises);

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: exercises.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: (index % 2 == 0) ? Colors.grey[50] : Colors.grey[100],
          child: Center(child: Text(exercises[index])),
        );
      },
    );
  }
}

// class GridBuilder extends StatefulWidget {
//   const GridBuilder({
//     super.key,
//     required this.selectedList,
//     required this.isSelectionMode,
//     required this.onSelectionChange,
//   });

//   final bool isSelectionMode;
//   final Function(bool)? onSelectionChange;
//   final List<bool> selectedList;

//   @override
//   GridBuilderState createState() => GridBuilderState();
// }

// class GridBuilderState extends State<GridBuilder> {
//   void _toggle(int index) {
//     if (widget.isSelectionMode) {
//       setState(() {
//         widget.selectedList[index] = !widget.selectedList[index];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//         itemCount: widget.selectedList.length,
//         gridDelegate:
//             const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//         itemBuilder: (_, int index) {
//           return InkWell(
//             onTap: () => _toggle(index),
//             onLongPress: () {
//               if (!widget.isSelectionMode) {
//                 setState(() {
//                   widget.selectedList[index] = true;
//                 });
//                 widget.onSelectionChange!(true);
//               }
//             },
//             child: GridTile(
//                 child: Container(
//               child: widget.isSelectionMode
//                   ? Checkbox(
//                       onChanged: (bool? x) => _toggle(index),
//                       value: widget.selectedList[index])
//                   : const Icon(Icons.image),
//             )),
//           );
//         });
//   }
// }

// class ListBuilder extends StatefulWidget {
//   const ListBuilder({
//     super.key,
//     required this.selectedList,
//     required this.isSelectionMode,
//     required this.onSelectionChange,
//   });

//   final bool isSelectionMode;
//   final List<bool> selectedList;
//   final Function(bool)? onSelectionChange;

//   @override
//   State<ListBuilder> createState() => _ListBuilderState();
// }

// class _ListBuilderState extends State<ListBuilder> {
//   void _toggle(int index) {
//     if (widget.isSelectionMode) {
//       setState(() {
//         widget.selectedList[index] = !widget.selectedList[index];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: widget.selectedList.length,
//         itemBuilder: (_, int index) {
//           return ListTile(
//               onTap: () => _toggle(index),
//               onLongPress: () {
//                 if (!widget.isSelectionMode) {
//                   setState(() {
//                     widget.selectedList[index] = true;
//                   });
//                   widget.onSelectionChange!(true);
//                 }
//               },
//               trailing: widget.isSelectionMode
//                   ? Checkbox(
//                       value: widget.selectedList[index],
//                       onChanged: (bool? x) => _toggle(index),
//                     )
//                   : const SizedBox.shrink(),
//               title: Text('item $index'));
//         });
//   }
// }
