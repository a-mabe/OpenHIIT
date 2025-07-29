import 'package:flutter/material.dart';

class CreateTimer extends StatefulWidget {
  const CreateTimer({super.key});

  @override
  CreateTimerState createState() => CreateTimerState();
}

class CreateTimerState extends State<CreateTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Timer'),
      ),
      body: const Center(
        child: Text('Create Timer Page'),
      ),
    );
  }
}
