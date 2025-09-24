import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/features/run_timer/widgets/volume_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandscapeControlBar extends StatefulWidget {
  final VoidCallback onRestart;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onAdjustVolume;
  final VoidCallback onSkipNext;
  final VoidCallback onSkipPrevious;
  final bool paused;
  final bool changeVolume;
  final double volume;
  final Color color;

  const LandscapeControlBar({
    super.key,
    required this.onRestart,
    required this.onTogglePlayPause,
    required this.onAdjustVolume,
    required this.onSkipNext,
    required this.onSkipPrevious,
    required this.paused,
    required this.changeVolume,
    required this.volume,
    required this.color,
  });

  @override
  LandscapeControlBarState createState() => LandscapeControlBarState();
}

class LandscapeControlBarState extends State<LandscapeControlBar> {
  double _currentSliderValue = .8;

  @override
  void initState() {
    super.initState();
    _loadVolume();
  }

  Future<void> _loadVolume() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentSliderValue = (prefs.getDouble('volume') ?? 80) / 100;
    });
  }

  Future<void> _saveVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('volume', value * 100);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(70, 0, 0, 0),
      child: Center(
          child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  key: const Key('volume'),
                  size: MediaQuery.of(context).size.width > 600 ? 50 : 35,
                  widget.changeVolume ? Icons.close : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: widget.onAdjustVolume,
              ),
              IconButton(
                key: const Key('skip_previous'),
                tooltip: 'Skip Previous',
                icon: Icon(Icons.skip_previous,
                    size: MediaQuery.of(context).size.width > 600 ? 45 : 30,
                    color: Colors.white),
                onPressed: widget.onSkipPrevious,
              ),
              IconButton(
                key: const Key('play_pause'),
                tooltip: 'Pause',
                icon: Icon(
                  size: MediaQuery.of(context).size.width > 600 ? 60 : 45,
                  widget.paused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                ),
                onPressed: widget.onTogglePlayPause,
              ),
              IconButton(
                key: const Key('skip_next'),
                tooltip: 'Skip Next',
                icon: Icon(Icons.skip_next,
                    size: MediaQuery.of(context).size.width > 600 ? 45 : 30,
                    color: Colors.white),
                onPressed: widget.onSkipNext,
              ),
              IconButton(
                key: const Key('restart'),
                tooltip: 'Restart',
                icon: Icon(Icons.restart_alt,
                    size: MediaQuery.of(context).size.width > 600 ? 50 : 35,
                    color: Colors.white),
                onPressed: () {
                  widget.onRestart();
                },
              ),
            ],
          ),
          if (widget.changeVolume)
            VolumeBar(
              volume: _currentSliderValue,
              onVolumeChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
                _saveVolume(value);
              },
            ),
        ],
      )),
    );
  }
}
