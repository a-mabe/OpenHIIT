// import 'package:flutter/material.dart';
// import 'package:openhiit/create_workout/constants/set_timings_constants.dart';

// class ExpansionRepeatTileClass extends StatefulWidget {
//   /// Vars

//   final Widget? trailingWidget;

//   const ExpansionRepeatTileClass({
//     this.trailingWidget,
//     super.key,
//   });

//   @override
//   ExpansionRepeatTileClassState createState() =>
//       ExpansionRepeatTileClassState();
// }

// class ExpansionRepeatTileClassState extends State<ExpansionRepeatTileClass> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       key: const Key('expansion-repeat-tile'),
//       maintainState: true,
//       title: const Text('Additional configuration'),
//       subtitle: const Text('Auto restart, warm-up, and more'),
//       leading: const Icon(Icons.tune),
//       children: <Widget>[
//         ListTile(
//           key: Key(additionalTimeTitlesKeys[0]),
//           title: Text(additionalTimeTitles[0]),
//           subtitle: Text(additionalTimeSubTitles[0]),
//           leading: const Icon(Icons.flag),
//           trailing: widget.trailingWidget,
//         ),
//         ListTile(
//           key: Key(additionalTimeTitlesKeys[1]),
//           title: Text(additionalTimeTitles[1]),
//           subtitle: Text(additionalTimeSubTitles[1]),
//           leading: const Icon(Icons.emoji_people),
//           trailing: widget.trailingWidget,
//         ),
//         ListTile(
//           key: Key(additionalTimeTitlesKeys[2]),
//           title: Text(additionalTimeTitles[2]),
//           subtitle: Text(additionalTimeSubTitles[2]),
//           leading: const Icon(Icons.ac_unit),
//           trailing: widget.trailingWidget,
//         ),
//         ListTile(
//           key: Key(additionalTimeTitlesKeys[3]),
//           title: Text(additionalTimeTitles[3]),
//           subtitle: Text(additionalTimeSubTitles[3]),
//         ),
//         ListTile(
//           key: Key(additionalTimeTitlesKeys[4]),
//           title: Text(additionalTimeTitles[4]),
//           subtitle: Text(additionalTimeSubTitles[4]),
//           leading: const Icon(Icons.replay),
//           trailing: widget.trailingWidget,
//         ),
//         ListTile(
//           key: Key(additionalTimeTitlesKeys[5]),
//           title: Text(additionalTimeTitles[5]),
//           subtitle: Text(additionalTimeSubTitles[5]),
//           leading: const Icon(Icons.block),
//           trailing: widget.trailingWidget,
//         ),
//       ],
//     );
//   }
// }
