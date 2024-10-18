import 'dart:convert';
import 'dart:math';
import 'package:audio_session/audio_session.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:background_hiit_timer/background_timer_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:background_hiit_timer/background_timer.dart';
import 'package:background_hiit_timer/background_timer_data.dart';
import 'package:confetti/confetti.dart';
import '../../utils/functions.dart';
import '../../models/workout_type.dart';
import '../../widgets/card_item_animated.dart';
import '../../models/lists/list_model_animated.dart';
import '../../models/lists/list_tile_model.dart';

class StartWorkout extends StatelessWidget {
  const StartWorkout({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CountDownTimer(workout: workout),
      ),
    );
  }
}

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key, required this.workout});

  final Workout workout;

  @override
  CountDownTimerState createState() => CountDownTimerState();
}

class CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  /// VARS

  final CountdownController _workoutController =
      CountdownController(autoStart: true);

  IconData pausePlayIcon = Icons.pause;
  int currentWorkInterval = 0;
  bool flipCurrentWorkInterval = true;
  bool doneVisible = false;
  bool done = false;

  GlobalKey volumeKey = GlobalKey();

  late ConfettiController _controllerCenter;
  late SharedPreferences preferences;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<ListTileModel> intervalInfo;

  /// END VARS

  @override
  void initState() {
    super.initState();
    intervalInfo = ListModel<ListTileModel>(
      listKey: _listKey,
      initialItems: <ListTileModel>[],
      removedItemBuilder: _buildRemovedItem,
    );
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    WakelockPlus.enable();
    init();
  }

  void init() async {
    final session = await AudioSession.instance;
    await session.setActive(false);

    preferences = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  Widget _buildRemovedItem(
      ListTileModel item, BuildContext context, Animation<double> animation) {
    return CardItemAnimated(
      animation: animation,
      item: item,
      fontColor: const Color.fromARGB(153, 255, 255, 255),
      fontWeight: FontWeight.normal,
      backgroundColor: Colors.transparent,
      sizeMultiplier: 1,
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  String timerScreenText(interval, status, exercises, Workout workoutArgument) {
    switch (status) {
      case 'start':
        return "Get ready";
      case 'warmup':
        return "Warm-up";
      case 'work':
        String exercise = exercises.isNotEmpty ? exercises[interval] : "Work";
        flipCurrentWorkInterval = true;
        return exercise;
      case 'rest':
        if (flipCurrentWorkInterval) {
          currentWorkInterval++;
          flipCurrentWorkInterval = false;
        }
        return "Rest";
      case 'cooldown':
        return "Cooldown";
      case 'break':
        return "Break";
      default:
        return "Rest";
    }
  }

  bool shouldReset = true;
  bool restart = false;
  int intervalsCompleted = 0;
  String lastStatus = "start";
  int intervalTotal = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.renderViews.first.automaticSystemUiAdjustment =
        false;

    Workout workout = widget.workout;

    List<dynamic> exercises =
        workout.exercises != "" ? jsonDecode(workout.exercises) : [];

    final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

    // ignore: unused_local_variable
    String backgroundColorStatus = "start";

    setState(() {
      if (shouldReset) {
        shouldReset = false;
        intervalInfo = ListModel<ListTileModel>(
          listKey: listKey,
          initialItems: listItems(exercises, workout),
          removedItemBuilder: _buildRemovedItem,
        );
        intervalTotal = intervalInfo.length;
        if (restart) {
          _workoutController.restart();
          restart = false;
        }
      }
    });

    Widget complete() {
      return Visibility(
          visible: doneVisible,
          maintainAnimation: true,
          maintainState: true,
          child: Container(
            alignment: Alignment.center,
            color: const Color.fromARGB(255, 0, 225, 255),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ConfettiWidget(
                    confettiController: _controllerCenter,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    shouldLoop:
                        true, // start again as soon as the animation is finished
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                    createParticlePath: drawStar, // define a custom shape/path.
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                    opacity: doneVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: Center(
                        child: Column(
                          children: [
                            const Text("Nice job!",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 45,
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Align(
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  TextButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  const Color.fromARGB(
                                                      133, 255, 255, 255))),
                                      label: const Text(
                                        "Back",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.arrow_back,
                                          color: Colors.white, size: 38)),
                                  const Spacer(),
                                  TextButton.icon(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  const Color.fromARGB(
                                                      133, 255, 255, 255))),
                                      label: const Text(
                                        "Restart",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          shouldReset = true;
                                          doneVisible = false;
                                          restart = true;
                                          done = false;
                                          WakelockPlus.enable();
                                        });
                                      },
                                      icon: const Icon(Icons.restart_alt,
                                          color: Colors.white, size: 38))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    }

    return Countdown(
        controller: _workoutController,
        iterations: workout.iterations,
        workSeconds: workout.workTime,
        restSeconds: workout.restTime,
        breakSeconds: workout.breakTime,
        getreadySeconds: workout.getReadyTime,
        warmupSeconds: workout.warmupTime,
        cooldownSeconds: workout.cooldownTime,
        workSound: workout.workSound,
        restSound: workout.restSound,
        completeSound: workout.completeSound,
        countdownSound: workout.countdownSound,
        halfwaySound: workout.halfwaySound,
        numberOfWorkIntervals: workout.numExercises,
        onFinished: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (intervalInfo.length == 1) {
              intervalInfo.removeAt(0);

              Future.delayed(const Duration(microseconds: 500000), () {
                setState(() {
                  doneVisible = true;
                  _controllerCenter.play();
                });
              });
            }
          });
        },
        build: (_, BackgroundTimerData timerData) {
          SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
          ));

          backgroundColorStatus = timerData.status;

          if (timerData.status == "complete" && restart == false) {
            done = true;
          } else if (timerData.status == "start" &&
              timerData.iterations == workout.iterations) {
            currentWorkInterval = 0;
            ListModel<ListTileModel> intervalList = ListModel<ListTileModel>(
              listKey: listKey,
              initialItems: listItems(exercises, workout),
              removedItemBuilder: _buildRemovedItem,
            );

            int count = 0;
            while (intervalInfo.length < intervalTotal) {
              intervalInfo.insert(count, intervalList[count]);
              count++;
            }
          } else {
            done = false;
            restart = true;
          }

          while ((intervalInfo.length + timerData.currentOverallInterval) >
              intervalTotal) {
            if (intervalInfo.length > 0 && doneVisible == false) {
              intervalInfo.removeAt(0);
            }
          }

          return Container(
              color: backgroundColor(timerData.status),
              child: SafeArea(
                  child: Scaffold(
                      body: Stack(children: [
                Container(
                  color: backgroundColor(timerData.status),
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      if (orientation == Orientation.landscape) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 50,
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 18,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: Row(children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      color:
                                                          const Color.fromARGB(
                                                              70, 0, 0, 0)),
                                                  width: 50,
                                                  height: 50,
                                                  child: Icon(
                                                    color: Colors.white,
                                                    Icons.arrow_back,
                                                    size: MediaQuery.of(context)
                                                                .orientation ==
                                                            Orientation.portrait
                                                        ? 50
                                                        : 30,
                                                  ),
                                                )),
                                          ),
                                          const Spacer(),
                                          Text(
                                            intervalInfo.length > 0
                                                ? intervalInfo[0]
                                                    .intervalString()
                                                : "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                            .orientation ==
                                                        Orientation.portrait
                                                    ? 30
                                                    : 20),
                                          ),
                                          const Spacer(),
                                          const SizedBox(
                                            width: 50,
                                            height: 20,
                                          )
                                        ]),
                                      )),
                                  Expanded(
                                      flex: 64,
                                      child: Center(
                                          child: AutoSizeText(
                                        timerText(
                                            timerData.currentMicroSeconds
                                                .toString(),
                                            workout),
                                        maxLines: 1,
                                        minFontSize: 20,
                                        maxFontSize: 20000,
                                        style: GoogleFonts.dmMono(
                                          // 'DmMono',
                                          fontSize: 20000,
                                          height: .9,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ))),
                                  Expanded(
                                    flex: 18,
                                    child: Container(
                                        color:
                                            const Color.fromARGB(70, 0, 0, 0),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Visibility(
                                                  visible:
                                                      !timerData.changeVolume,
                                                  child: const Spacer()),
                                              Visibility(
                                                  visible:
                                                      !timerData.changeVolume,
                                                  child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        setState(() {
                                                          shouldReset = true;
                                                          doneVisible = false;
                                                          restart = true;
                                                          done = false;
                                                          WakelockPlus.enable();
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        Icons.restart_alt,
                                                        color: Colors.white,
                                                      ))),
                                              Visibility(
                                                  visible:
                                                      !timerData.changeVolume,
                                                  child: const Spacer()),
                                              Visibility(
                                                visible:
                                                    !timerData.changeVolume,
                                                child: IconButton(
                                                    padding: EdgeInsets.zero,
                                                    iconSize: 50,
                                                    onPressed: () {
                                                      if (!timerData.paused) {
                                                        _workoutController
                                                            .pause();
                                                      } else {
                                                        _workoutController
                                                            .resume();
                                                      }
                                                    },
                                                    icon: Icon(
                                                      timerData.paused
                                                          ? Icons.play_arrow
                                                          : Icons.pause,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                              Visibility(
                                                  visible:
                                                      !timerData.changeVolume,
                                                  child: const Spacer()),
                                              Visibility(
                                                  visible:
                                                      timerData.changeVolume,
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        if (timerData.volume >
                                                            0) {
                                                          await preferences
                                                              .setDouble(
                                                                  'volume',
                                                                  timerData
                                                                          .volume -
                                                                      10);
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          color: Colors.white,
                                                          Icons.volume_down))),
                                              Visibility(
                                                visible: timerData.changeVolume,
                                                child: SliderTheme(
                                                  data: SliderTheme.of(context)
                                                      .copyWith(
                                                    trackHeight: 6.0,
                                                    thumbColor:
                                                        const Color.fromARGB(
                                                            255, 201, 201, 201),
                                                    thumbShape:
                                                        const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                12.0),
                                                  ),
                                                  child: ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                      minWidth: 50,
                                                      maxWidth: 170,
                                                    ),
                                                    child: Slider(
                                                      min: 0,
                                                      max: 100,
                                                      divisions: 10,
                                                      label:
                                                          "${timerData.volume.round()}%",
                                                      value: timerData.volume
                                                          .toDouble(),
                                                      onChanged: (value) async {
                                                        await preferences
                                                            .setDouble('volume',
                                                                value);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                  visible:
                                                      timerData.changeVolume,
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        if (timerData.volume <
                                                            100) {
                                                          await preferences
                                                              .setDouble(
                                                                  'volume',
                                                                  timerData
                                                                          .volume +
                                                                      10);
                                                        }
                                                      },
                                                      icon: const Icon(
                                                          color: Colors.white,
                                                          Icons.volume_up))),
                                              IconButton(
                                                  key: volumeKey,
                                                  padding: EdgeInsets.zero,
                                                  iconSize: 30,
                                                  onPressed: () async {
                                                    if (timerData
                                                        .changeVolume) {
                                                      await preferences.setBool(
                                                          'changeVolume',
                                                          false);
                                                    } else {
                                                      await preferences.setBool(
                                                          'changeVolume', true);
                                                    }
                                                  },
                                                  icon: Icon(
                                                    timerData.changeVolume
                                                        ? Icons.close
                                                        : Icons.volume_up,
                                                    color: Colors.white,
                                                  )),
                                              Visibility(
                                                  visible:
                                                      !timerData.changeVolume,
                                                  child: const Spacer()),
                                            ])),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 50,
                              child: Container(
                                  color: const Color.fromARGB(22, 0, 0, 0),
                                  child: AnimatedList(
                                    key: listKey,
                                    initialItemCount: intervalInfo.length,
                                    itemBuilder: (context, index, animation) {
                                      if (index >= intervalInfo.length) {
                                        return Container();
                                      } else {
                                        return CardItemAnimated(
                                          animation: animation,
                                          item: intervalInfo[index],
                                          fontColor: index == 0
                                              ? Colors.white
                                              : const Color.fromARGB(
                                                  153, 255, 255, 255),
                                          fontWeight: index == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          backgroundColor: Colors.transparent,
                                          sizeMultiplier: index == 0 ? 1.5 : 1,
                                        );
                                      }
                                    },
                                  )),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Row(children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 0, 0, 0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.portrait
                                                  ? const Color.fromARGB(
                                                      70, 0, 0, 0)
                                                  : Colors.transparent),
                                          width: 50,
                                          height: 50,
                                          child: Icon(
                                            color: Colors.white,
                                            Icons.arrow_back,
                                            size: MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.portrait
                                                ? 50
                                                : 30,
                                          ),
                                        )),
                                  ),
                                  const Spacer(),
                                  Text(
                                    intervalInfo.length > 0
                                        ? intervalInfo[0].intervalString()
                                        : "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait
                                            ? 30
                                            : 20),
                                  ),
                                  const Spacer(),
                                  const SizedBox(
                                    width: 50,
                                    height: 50,
                                  )
                                ]),
                              )),
                          Expanded(
                            flex: 31,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 3.0, 20.0, 5.0),
                              child: Center(
                                  child: AutoSizeText(
                                timerText(
                                    timerData.currentMicroSeconds.toString(),
                                    workout),
                                maxLines: 1,
                                minFontSize: 20,
                                maxFontSize: 20000,
                                style: GoogleFonts.dmMono(
                                  // 'DmMono',
                                  fontSize: 20000,
                                  height: .7,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              )),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Container(
                                color: const Color.fromARGB(70, 0, 0, 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                          visible: !timerData.changeVolume,
                                          child: const Spacer()),
                                      Visibility(
                                          visible: !timerData.changeVolume,
                                          child: IconButton(
                                              padding: EdgeInsets.zero,
                                              iconSize: 30,
                                              onPressed: () {
                                                setState(() {
                                                  shouldReset = true;
                                                  doneVisible = false;
                                                  restart = true;
                                                  done = false;
                                                  WakelockPlus.enable();
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.restart_alt,
                                                color: Colors.white,
                                              ))),
                                      Visibility(
                                          visible: !timerData.changeVolume,
                                          child: const Spacer()),
                                      Visibility(
                                        visible: !timerData.changeVolume,
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            iconSize: 50,
                                            onPressed: () {
                                              if (!timerData.paused) {
                                                _workoutController.pause();
                                              } else {
                                                _workoutController.resume();
                                              }
                                            },
                                            icon: Icon(
                                              timerData.paused
                                                  ? Icons.play_arrow
                                                  : Icons.pause,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Visibility(
                                          visible: timerData.changeVolume,
                                          child: IconButton(
                                              onPressed: () async {
                                                if (timerData.volume > 0) {
                                                  await preferences.setDouble(
                                                      'volume',
                                                      timerData.volume - 10);
                                                }
                                              },
                                              icon: const Icon(
                                                  color: Colors.white,
                                                  Icons.volume_down))),
                                      Visibility(
                                        visible: timerData.changeVolume,
                                        child: SliderTheme(
                                          data:
                                              SliderTheme.of(context).copyWith(
                                            trackHeight: 6.0,
                                            thumbColor: const Color.fromARGB(
                                                255, 201, 201, 201),
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 12.0),
                                          ),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              minWidth: 50,
                                              maxWidth: 170,
                                            ),
                                            child: Slider(
                                              min: 0,
                                              max: 100,
                                              divisions: 10,
                                              label:
                                                  "${timerData.volume.round()}%",
                                              value:
                                                  timerData.volume.toDouble(),
                                              onChanged: (value) async {
                                                await preferences.setDouble(
                                                    'volume', value);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                          visible: timerData.changeVolume,
                                          child: IconButton(
                                              onPressed: () async {
                                                if (timerData.volume < 100) {
                                                  await preferences.setDouble(
                                                      'volume',
                                                      timerData.volume + 10);
                                                }
                                              },
                                              icon: const Icon(
                                                  color: Colors.white,
                                                  Icons.volume_up))),
                                      Visibility(
                                          visible: !timerData.changeVolume,
                                          child: const Spacer()),
                                      IconButton(
                                          key: volumeKey,
                                          padding: EdgeInsets.zero,
                                          iconSize: 30,
                                          onPressed: () async {
                                            if (timerData.changeVolume) {
                                              await preferences.setBool(
                                                  'changeVolume', false);
                                            } else {
                                              await preferences.setBool(
                                                  'changeVolume', true);
                                            }
                                          },
                                          icon: Icon(
                                            timerData.changeVolume
                                                ? Icons.close
                                                : Icons.volume_up,
                                            color: Colors.white,
                                          )),
                                      Visibility(
                                          visible: !timerData.changeVolume,
                                          child: const Spacer()),
                                    ])),
                          ),
                          Expanded(
                            flex: 51,
                            child: Container(
                                color: const Color.fromARGB(22, 0, 0, 0),
                                child: AnimatedList(
                                  key: listKey,
                                  initialItemCount: intervalInfo.length,
                                  itemBuilder: (context, index, animation) {
                                    if (index >= intervalInfo.length) {
                                      return Container();
                                    } else {
                                      return CardItemAnimated(
                                        animation: animation,
                                        item: intervalInfo[index],
                                        fontColor: index == 0
                                            ? Colors.white
                                            : const Color.fromARGB(
                                                153, 255, 255, 255),
                                        fontWeight: index == 0
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        backgroundColor: Colors.transparent,
                                        sizeMultiplier: index == 0 ? 1.5 : 1,
                                      );
                                    }
                                  },
                                )),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                complete()
              ]))));
        });
  }

  Color backgroundColor(String status) {
    switch (status) {
      case "work":
        return Colors.green;
      case "rest":
        return Colors.red;
      case "start":
        return Colors.black;
      case "break":
        return Colors.teal;
      case "warmup":
        return Colors.orange;
      case "cooldown":
        return Colors.blue;
      default:
        return const Color.fromARGB(255, 0, 225, 255);
    }
  }

  String timerText(String currentSeconds, Workout workout) {
    if (workout.showMinutes == 1) {
      int currentSecondsInt = int.parse(currentSeconds);
      int seconds = currentSecondsInt % 60;
      int minutes = ((currentSecondsInt - seconds) / 60).round();

      if (minutes == 0) {
        return currentSeconds;
      }

      String secondsString = seconds.toString();
      if (seconds < 10) {
        secondsString = "0$seconds";
      }

      return "$minutes:$secondsString";
    } else {
      return currentSeconds;
    }
  }
}
