import 'package:flutter/material.dart';
import 'package:openhiit/core/models/interval_display_model.dart';

class IntervalListTile extends StatelessWidget {
  final IntervalDisplayModel interval;
  final Color backgroundColor;
  final bool editing;
  final TextEditingController nameController;
  final ValueChanged<String>? onNameChanged; // callback for text changes

  IntervalListTile({
    super.key,
    required this.interval,
    required this.backgroundColor,
    this.editing = false,
    this.onNameChanged,
    TextEditingController? nameController,
  }) : nameController = nameController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    final isActive = interval.activeIndex != 0;

    return Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor, // background color of the tile
            borderRadius: BorderRadius.circular(12), // round the corners
          ),
          child: ListTile(
            leading: SizedBox(
              width: textScaler.scale(40), // reserve space
              child: isActive
                  ? Text(
                      interval.activeIndex.toString(),
                      style: TextStyle(
                          fontSize: textScaler.scale(24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )
                  : null,
            ),
            title: editing && isActive
                ? TextFormField(
                    controller: nameController,
                    onChanged: onNameChanged,
                    style: TextStyle(
                        fontSize: (24 - (interval.name.length * 0.5))
                            .clamp(12, 24) // don’t shrink below 12, max 24
                            .toDouble(),
                        color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(51, 0, 0, 0),
                      suffix: const Icon(
                        Icons.edit,
                        size: 20,
                        color: Colors.white70,
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        minWidth: 25,
                        minHeight: 0,
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  )
                : Text(
                    interval.name,
                    style: TextStyle(
                        fontSize: textScaler.scale(24), color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
            trailing: Text(
              '${interval.seconds}s',
              style: TextStyle(
                  fontSize: textScaler.scale(24), color: Colors.white),
            ),
          ),
        ));
  }
}
