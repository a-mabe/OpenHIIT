import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CreateWorkout extends StatelessWidget {
  const CreateWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: const Center(
        child: ChooseNumber(),
      ),
    );
  }
}

class ChooseNumber extends StatefulWidget {
  const ChooseNumber({super.key});

  @override
  ChooseNumberState createState() => ChooseNumberState();
}

class ChooseNumberState extends State<ChooseNumber> {
  int _currentIntValue = 10;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Text('Select number of exercises:',
            style: Theme.of(context).textTheme.titleLarge),
        NumberPicker(
          value: _currentIntValue,
          minValue: 0,
          maxValue: 50,
          step: 1,
          haptics: true,
          onChanged: (value) => setState(() => _currentIntValue = value),
        ),
        // const SizedBox(height: 32),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       icon: const Icon(Icons.remove),
        //       onPressed: () => setState(() {
        //         final newValue = _currentIntValue - 10;
        //         _currentIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //     Text('Current int value: $_currentIntValue'),
        //     IconButton(
        //       icon: const Icon(Icons.add),
        //       onPressed: () => setState(() {
        //         final newValue = _currentIntValue + 20;
        //         _currentIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //   ],
        // ),
        // const Divider(color: Colors.grey, height: 32),
        // const SizedBox(height: 16),
        // Text('Horizontal', style: Theme.of(context).textTheme.titleLarge),
        // NumberPicker(
        //   value: _currentHorizontalIntValue,
        //   minValue: 0,
        //   maxValue: 100,
        //   step: 10,
        //   itemHeight: 100,
        //   axis: Axis.horizontal,
        //   onChanged: (value) =>
        //       setState(() => _currentHorizontalIntValue = value),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(16),
        //     border: Border.all(color: Colors.black26),
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       icon: const Icon(Icons.remove),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue - 10;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //     Text('Current horizontal int value: $_currentHorizontalIntValue'),
        //     IconButton(
        //       icon: const Icon(Icons.add),
        //       onPressed: () => setState(() {
        //         final newValue = _currentHorizontalIntValue + 20;
        //         _currentHorizontalIntValue = newValue.clamp(0, 100);
        //       }),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

// class CreateWorkout extends StatelessWidget {
//   const CreateWorkout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Second Route'),
//       ),
//       body: Center(
//           child: 

//         // child: ElevatedButton(
//         //   onPressed: () {
//         //     Navigator.pop(context);
//         //   },
//         //   child: const Text('Go back!'),
//         // ),
//       ),
//     );
//   }
// }
