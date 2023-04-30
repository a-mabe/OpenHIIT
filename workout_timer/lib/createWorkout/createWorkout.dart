import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import './setExercises.dart';

class CreateWorkout extends StatelessWidget {
  const CreateWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Workout'),
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
  // ignore: library_private_types_in_public_api
  _ChooseNumberState createState() => _ChooseNumberState();
}

class _ChooseNumberState extends State<ChooseNumber> {
  int _currentIntValue = 10;
  final _formKey = GlobalKey<FormState>();

  void submitNumExercises() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Exercises()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
            child: Text(
              "Name this workout:",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
            child: TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(40.0, 30.0, 40.0, 0.0),
            child: Text(
              "How many exercises?",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: NumberPicker(
              value: _currentIntValue,
              minValue: 1,
              maxValue: 50,
              step: 1,
              haptics: true,
              onChanged: (value) => setState(() => _currentIntValue = value),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => setState(() {
                    final newValue = _currentIntValue - 1;
                    _currentIntValue = newValue.clamp(1, 50);
                  }),
                ),
                Text('Current int value: $_currentIntValue'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() {
                    final newValue = _currentIntValue + 1;
                    _currentIntValue = newValue.clamp(1, 50);
                  }),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );

                    submitNumExercises();
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ),
        ],
      ),
    );

    // Column(
    //   children: <Widget>[
    //     TextFormField(
    //       // The validator receives the text that the user has entered.
    //       validator: (value) {
    //         if (value == null || value.isEmpty) {
    //           return 'Please enter a name for the workout';
    //         }
    //         return null;
    //       },
    //     ),
    //     const SizedBox(height: 16),
    //     Text('Select number of exercises:',
    //         style: Theme.of(context).textTheme.titleLarge),
    //     NumberPicker(
    //       value: _currentIntValue,
    //       minValue: 1,
    //       maxValue: 50,
    //       step: 1,
    //       haptics: true,
    //       onChanged: (value) => setState(() => _currentIntValue = value),
    //     ),
    //     TextButton(
    //       style: TextButton.styleFrom(
    //           foregroundColor: Colors.white,
    //           disabledForegroundColor: Colors.blue.withOpacity(0.38),
    //           backgroundColor: Colors.blue),
    //       onPressed: () {
    //         submitNumExercises();
    //       },
    //       child: const Text('Submit'),
    //     )
    //   ],
    // );
  }
}
