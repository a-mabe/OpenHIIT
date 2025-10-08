import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_creation_provider/timer_creation_provider.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/core/utils/interval_calculation.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/start_save_toggle.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/tabs/editor_tab/editor_tab.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/tabs/general_tab/general_tab.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/tabs/sound_tab/sound_tab.dart';
import 'package:openhiit/features/run_timer/workout.dart';
import 'package:provider/provider.dart';
import 'package:unit_number_input/unit_number_input.dart';

class EditTimer extends StatefulWidget {
  final bool editing;

  const EditTimer({super.key, this.editing = false});

  @override
  State<EditTimer> createState() => _EditTimerState();
}

class _EditTimerState extends State<EditTimer> with TickerProviderStateMixin {
  late TabController _tabController;

  final nameController = TextEditingController();
  final activeIntervalsController = TextEditingController();
  Map<String, UnitNumberInputController> timeSettingsControllers = {};
  final List<TextEditingController> editorTabTextControllers = [];
  final formKey = GlobalKey<FormState>();

  late StartSaveState buttonState;

  bool controllersUpdated = false;

  final logger = Logger(
    printer: JsonLogPrinter('EditTimer'),
  );

  bool _isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // A common breakpoint for tablets is 600dp
    return size.shortestSide >= 600;
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      // Only trigger when the user finishes changing tabs
      if (_tabController.indexIsChanging == false) {
        if (_tabController.index == 2) {
          _onEditorTabAccessed();
        } else {
          setState(() {
            controllersUpdated = false;
          });
        }
      }
    });

    buttonState = widget.editing ? StartSaveState.start : StartSaveState.save;

    var timerCreationProvider = context.read<TimerCreationProvider>();
    final timer = timerCreationProvider.timer;
    final showMinutes = timer.showMinutes == 1;
    final ts = timer.timeSettings;

    nameController.text = timer.name;
    activeIntervalsController.text = timer.activeIntervals.toString();

    timeSettingsControllers = {
      'work': UnitNumberInputController(
        initialSeconds: ts.workTime,
        startInMinutesMode: showMinutes,
      ),
      'rest': UnitNumberInputController(
        initialSeconds: ts.restTime,
        startInMinutesMode: showMinutes,
      ),
      'get-ready': UnitNumberInputController(
        initialSeconds: ts.getReadyTime,
        startInMinutesMode: showMinutes,
      ),
      'warm-up': UnitNumberInputController(
        initialSeconds: ts.warmupTime,
        startInMinutesMode: showMinutes,
      ),
      'cool-down': UnitNumberInputController(
        initialSeconds: ts.cooldownTime,
        startInMinutesMode: showMinutes,
      ),
      'restarts': UnitNumberInputController(
        initialSeconds: ts.restarts,
        startInMinutesMode: false,
      ),
      'break': UnitNumberInputController(
        initialSeconds: ts.breakTime,
        startInMinutesMode: showMinutes,
      ),
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onEditorTabAccessed() {
    var timerCreationProvider = context.read<TimerCreationProvider>();
    final activities = timerCreationProvider.timer.activities;

    if (editorTabTextControllers.isEmpty) {
      // Add new controllers based on active intervals
      for (var i = 0; i < timerCreationProvider.timer.activeIntervals; i++) {
        final text = (i < activities.length && activities[i].trim().isNotEmpty)
            ? activities[i].trim()
            : 'Work';

        editorTabTextControllers.add(TextEditingController(text: text));
      }
    } else if (editorTabTextControllers.length <
        timerCreationProvider.timer.activeIntervals) {
      // Add more controllers if active intervals increased
      for (var i = editorTabTextControllers.length;
          i < timerCreationProvider.timer.activeIntervals;
          i++) {
        final text = (i < activities.length && activities[i].trim().isNotEmpty)
            ? activities[i].trim()
            : 'Work';

        editorTabTextControllers.add(TextEditingController(text: text));
      }
    } else if (editorTabTextControllers.length >
        timerCreationProvider.timer.activeIntervals) {
      // Remove controllers if active intervals decreased
      editorTabTextControllers
          .sublist(timerCreationProvider.timer.activeIntervals)
          .forEach((controller) => controller.dispose());
      editorTabTextControllers.removeRange(
          timerCreationProvider.timer.activeIntervals,
          editorTabTextControllers.length);
    }

    setState(() {
      controllersUpdated = true;
    });
  }

  void _handleSubmit() async {
    var timerCreationProvider = context.read<TimerCreationProvider>();
    var timerProvider = context.read<TimerProvider>();

    var intervals =
        await generateIntervalsFromTimer(timerCreationProvider.timer);

    if (buttonState == StartSaveState.start) {
      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RunTimer(
            timer: timerCreationProvider.timer,
            intervals: intervals,
          );
        }));
      }
    } else {
      if (!formKey.currentState!.validate()) return;

      if (widget.editing) {
        await timerProvider.updateTimer(timerCreationProvider.timer);
      } else {
        await timerProvider.pushTimer(timerCreationProvider.timer);
      }
      logger.i(
          "Timer ${widget.editing ? 'updated' : 'created'}: ${timerCreationProvider.timer.name}");
      setButtonState(StartSaveState.start);
    }
  }

  ValueChanged<bool> get unitNumberInputState => (bool state) {
        for (var controller in timeSettingsControllers.values) {
          controller.toggleMode();
        }
      };

  ValueChanged<StartSaveState> get setButtonState => (StartSaveState state) {
        if (buttonState != state) {
          setState(() {
            buttonState = state;
          });
        }
      };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isTablet = _isTablet(context);

        if (isLandscape || isTablet) {
          return _buildLandscapeLayout();
        } else {
          return _buildPortraitLayout();
        }
      },
    );
  }

  Widget _buildTabView() {
    return Form(
        key: formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            GeneralTab(
              nameController: nameController,
              activeIntervalsController: activeIntervalsController,
              timeSettingsControllers: timeSettingsControllers,
              editing: widget.editing,
              onEdited: setButtonState,
              onUnitToggle: unitNumberInputState,
            ),
            SoundTab(
              onEdited: setButtonState,
            ),
            EditorTab(
              controllers: editorTabTextControllers,
              onEdited: setButtonState,
              controllersUpdated: controllersUpdated,
              setButtonState: setButtonState,
            ),
          ],
        ));
  }

  Widget _buildSubmitButton() {
    return StartSaveToggle(state: buttonState, onPressed: _handleSubmit);
  }

  Widget _buildPortraitLayout() {
    return Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                  key: Key('general-tab'),
                  icon: Icon(
                    Icons.timer,
                  )),
              Tab(
                  key: Key('sound-tab'),
                  icon: Icon(
                    Icons.music_note,
                  )),
              Tab(
                  key: Key('edit-tab'),
                  icon: Icon(
                    Icons.fitness_center,
                  )),
            ],
          ),
        ),
        body: _buildTabView(),
        bottomNavigationBar: BottomAppBar(
            height: 70,
            child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Align(
                    alignment: Alignment.center,
                    child:
                        SizedBox(width: 120, child: _buildSubmitButton())))));
  }

  Widget _buildLandscapeLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _tabController.index,
            onDestinationSelected: (i) =>
                setState(() => _tabController.index = i),
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.text_fields), label: Text('Tab 1')),
              NavigationRailDestination(
                  icon: Icon(Icons.list), label: Text('Tab 2')),
              NavigationRailDestination(
                  icon: Icon(Icons.more), label: Text('Tab 3')),
            ],
          ),
          Expanded(child: _buildTabView()),
          SizedBox(
              width: 80,
              child: _buildSubmitButton()), // optional vertical submit
        ],
      ),
    );
  }
}
