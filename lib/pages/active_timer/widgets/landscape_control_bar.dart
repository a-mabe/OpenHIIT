import 'package:flutter/material.dart';
import 'package:openhiit/pages/active_timer/widgets/volume_bar.dart';
import 'package:openhiit/utils/log/log.dart';
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
      color: widget.color,
      child: Center(
          child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  size: 35,
                  widget.changeVolume ? Icons.close : Icons.volume_up,
                  color: Colors.white,
                ),
                onPressed: widget.onAdjustVolume,
              ),
              IconButton(
                tooltip: 'Skip Previous',
                icon: const Icon(Icons.skip_previous,
                    size: 35, color: Colors.white),
                onPressed: widget.onSkipPrevious,
              ),
              IconButton(
                tooltip: 'Pause',
                icon: Icon(
                  size: 55,
                  widget.paused ? Icons.play_arrow : Icons.pause,
                  color: Colors.white,
                ),
                onPressed: widget.onTogglePlayPause,
              ),
              IconButton(
                tooltip: 'Skip Next',
                icon:
                    const Icon(Icons.skip_next, size: 30, color: Colors.white),
                onPressed: widget.onSkipNext,
              ),
              IconButton(
                tooltip: 'Restart',
                icon: const Icon(Icons.restart_alt,
                    size: 35, color: Colors.white),
                onPressed: () {
                  logger.d('Restarting timer');
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
