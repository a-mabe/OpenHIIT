import 'package:flutter/material.dart';

class FABColumn extends StatelessWidget {
  // final void Function() bulk;
  // final void Function() create;

  const FABColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton.small(
          onPressed: () {},
          tooltip: 'Bulk export',
          heroTag: "export",
          child: const Icon(Icons.share),
        ),
        const SizedBox(
          height: 20,
        ),
        FloatingActionButton(
          key: const Key("create-timer"),
          onPressed: () {},
          tooltip: 'Create a new timer',
          heroTag: "create",
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}
