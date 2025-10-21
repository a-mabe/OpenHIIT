import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/providers/timer_creation_provider/timer_creation_provider.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/core/providers/timer_provider/utils/functions.dart';
import 'package:openhiit/core/utils/interval_calculation.dart';
import 'package:openhiit/features/edit_timer/ui/widgets/error_toast.dart';
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
  late bool editing;

  final nameController = TextEditingController();
  final activeIntervalsController = TextEditingController();
  Map<String, UnitNumberInputController> timeSettingsControllers = {};
  final List<TextEditingController> editorTabTextControllers = [];
  final formKey = GlobalKey<FormState>();

  late StartSaveState buttonState;

  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = true;

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

    editing = widget.editing;

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

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isExpanded) setState(() => _isExpanded = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isExpanded) setState(() => _isExpanded = true);
      }
    });

    buttonState = editing ? StartSaveState.start : StartSaveState.save;

    var timerCreationProvider = context.read<TimerCreationProvider>();
    final timer = timerCreationProvider.timer;
    final showMinutes = timer.showMinutes == 1;
    final ts = timer.timeSettings;

    nameController.text = timer.name;
    activeIntervalsController.text =
        timer.activeIntervals == 0 ? '' : timer.activeIntervals.toString();

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
    _scrollController.dispose();
    nameController.dispose();
    activeIntervalsController.dispose();
    for (var controller in timeSettingsControllers.values) {
      controller.dispose();
    }
    for (var controller in editorTabTextControllers) {
      controller.dispose();
    }
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
    final isSaving = buttonState == StartSaveState.save;
    setButtonState(StartSaveState.saving);

    final timerCreation = context.read<TimerCreationProvider>();
    final timerProvider = context.read<TimerProvider>();

    final intervals = await generateIntervalsFromTimer(timerCreation.timer);

    if (!mounted) return;

    if (intervals.isEmpty) {
      logger.w('No intervals generated from timer.');
      setButtonState(StartSaveState.save);
      showErrorToast(
        context,
        'At least one interval must have a duration greater than 0.',
      );
      return;
    }

    timerCreation.setTotalTime(getTotalTime(intervals));

    if (!isSaving) {
      logger.i("Starting timer: ${timerCreation.timer.name}");
      setButtonState(StartSaveState.start);
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return RunTimer(
          timer: timerCreation.timer,
          intervals: intervals,
        );
      }));
      return;
    }

    // Saving flow
    if (!formKey.currentState!.validate()) {
      setButtonState(StartSaveState.save);
      return;
    }

    logger.i(
      "Submitting timer: ${timerCreation.timer.name} (editing: $editing)",
    );

    if (editing) {
      await timerProvider.updateTimer(timerCreation.timer);
    } else {
      await timerProvider.pushTimer(timerCreation.timer);
      editing = true;
    }

    logger.i(
      "Timer ${editing ? 'updated' : 'created'}: ${timerCreation.timer.name}",
    );
    setButtonState(StartSaveState.start);
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
              editing: editing,
              onEdited: setButtonState,
              onUnitToggle: unitNumberInputState,
              scrollController: _scrollController,
            ),
            SoundTab(
              onEdited: setButtonState,
              scrollController: _scrollController,
            ),
            EditorTab(
              controllers: editorTabTextControllers,
              onEdited: setButtonState,
              controllersUpdated: controllersUpdated,
              scrollController: _scrollController,
              setButtonState: setButtonState,
            ),
          ],
        ));
  }

  Widget _buildSubmitButton() {
    return StartSaveToggle(
        state: buttonState, onPressed: _handleSubmit, isExpanded: _isExpanded);
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
      floatingActionButton: _buildSubmitButton(),
      body: _buildTabView(),
    );
  }

  Widget _buildLandscapeLayout() {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _tabController.index,
            onDestinationSelected: (i) =>
                setState(() => _tabController.index = i),
            minWidth: 100,
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.timer), label: Text('General Tab')),
              NavigationRailDestination(
                  icon: Icon(Icons.music_note), label: Text('Sound Tab')),
              NavigationRailDestination(
                  icon: Icon(Icons.fitness_center), label: Text('Edit Tab')),
            ],
          ),
          Expanded(child: _buildTabView()),
        ],
      ),
      floatingActionButton: _buildSubmitButton(),
    );
  }
}
