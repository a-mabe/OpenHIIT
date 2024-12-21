import 'package:flutter/material.dart';

class VolumeBar extends StatelessWidget {
  final double volume;
  final Function(double) onVolumeChanged;

  const VolumeBar(
      {super.key, required this.volume, required this.onVolumeChanged});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      right: 20.0,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Slider(
            value: volume,
            min: 0.0,
            max: 1.0,
            onChanged: onVolumeChanged,
          ),
        ),
      ),
    );
  }
}
