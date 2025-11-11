import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:openhiit/core/logs/logs.dart';
import 'package:openhiit/core/models/timer_type.dart';
import 'package:openhiit/core/providers/timer_creation_provider/timer_creation_provider.dart';
import 'package:openhiit/core/providers/timer_provider/timer_provider.dart';
import 'package:openhiit/features/edit_timer/ui/edit_timer.dart';
import 'package:openhiit/features/home/ui/widgets/about_button.dart';
import 'package:openhiit/features/home/ui/widgets/app_bar.dart';
import 'package:openhiit/features/home/ui/widgets/nav_bar_icon_button.dart';
import 'package:openhiit/features/import_export_timers/utils/functions.dart';
import 'package:openhiit/features/reorder_timers/ui/list_timers.dart';
import 'package:openhiit/shared/ui/widgets/bottom_app_bar.dart';
import 'package:provider/provider.dart';

class ListTimersPage extends StatefulWidget {
  const ListTimersPage({super.key});

  @override
  State<ListTimersPage> createState() => _ListTimersPageState();
}

class _ListTimersPageState extends State<ListTimersPage> {
  late TimerProvider timerProvider;
  late Future<List<TimerType>> _loadTimersFuture;

  Logger logger = Logger(
    printer: JsonLogPrinter('ListTimersPage'),
  );

  @override
  void initState() {
    super.initState();
    refreshTimers();
  }

  bool _isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // A common breakpoint for tablets is 600dp
    return size.shortestSide >= 600;
  }

  void refreshTimers() {
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
    setState(() {
      _loadTimersFuture = timerProvider.loadTimers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isTablet = _isTablet(context);

        if (isLandscape || isTablet) {
          return _buildHomeLandscape();
        } else {
          return _buildHomePortrait();
        }
      },
    );
  }

  Widget _buildHomePortrait() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: ListTimersAppBar(),
      body: SafeArea(
          child: FutureBuilder(
        future: _loadTimersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching timers'));
          } else {
            final timers = snapshot.data ?? [];
            if (timers.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('No saved timers',
                          style: TextStyle(fontSize: 20)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text("Hit the + to get started!"),
                    ),
                  ],
                ),
              );
            }
            return ListTimersReorderableList(
              items: timers,
              onReorderCompleted: (reorderedItems) {},
              onTap: (timer) {
                logger.d("Tapped on timer: ${timer.name}");
                context.read<TimerCreationProvider>().setTimer(timer);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTimer(editing: true),
                  ),
                ).then((_) {
                  refreshTimers();
                });
              },
            );
          }
        },
      )),
      bottomNavigationBar: SafeArea(
          top: false,
          child: CustomBottomAppBar(
            children: [
              Visibility(
                  visible: timerProvider.timers.isNotEmpty, child: Spacer()),
              Visibility(
                visible: timerProvider.timers.isNotEmpty,
                child: NavBarIconButton(
                  icon: Icons.upload,
                  label: 'Export',
                  fontSize: 11,
                  spacing: 0,
                  verticalPadding: 0,
                  onPressed: () {
                    onExportPressed(context, timerProvider.timers);
                  },
                ),
              ),
              Spacer(),
              NavBarIconButton(
                  icon: Icons.download,
                  label: 'Import',
                  fontSize: 11,
                  spacing: 0,
                  verticalPadding: 0,
                  onPressed: () async {
                    await onImportPressed(
                      context,
                      timerProvider,
                      refreshTimers,
                    );
                  }),
              Spacer(),
              NavBarIconButton(
                icon: Icons.add_circle,
                iconColor: Theme.of(context).colorScheme.primary,
                label: 'New',
                keyLabel: 'new-timer',
                fontSize: 11,
                spacing: 0,
                verticalPadding: 4,
                onPressed: () {
                  context.read<TimerCreationProvider>().clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditTimer(editing: false),
                    ),
                  ).then((_) {
                    refreshTimers();
                  });
                },
              ),
              Spacer(),
            ],
          )),
    );
  }

  Widget _buildHomeLandscape() {
    return Scaffold(
      appBar: _isTablet(context)
          ? PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                toolbarHeight: 1.0,
                elevation: 0,
              ),
            )
          : null,
      body: Row(children: [
        _buildNavRail(),
        Expanded(
            child: SafeArea(
          // Not needed because the nav rail is on the left side
          left: false,
          child: FutureBuilder(
            future: _loadTimersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                logger.e("Error fetching timers: ${snapshot.error}");
                return const Center(child: Text('Error fetching timers'));
              } else {
                final timers = snapshot.data ?? [];
                if (timers.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('No saved timers',
                              style: TextStyle(fontSize: 20)),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text("Hit the + to get started!"),
                        ),
                      ],
                    ),
                  );
                }
                return ListTimersReorderableList(
                  items: timers,
                  onReorderCompleted: (reorderedItems) {},
                  onTap: (timer) {
                    logger.d("Tapped on timer: ${timer.name}");
                    context.read<TimerCreationProvider>().setTimer(timer);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTimer(editing: true),
                      ),
                    ).then((_) {
                      refreshTimers();
                    });
                  },
                );
              }
            },
          ),
        )),
      ]),
    );
  }

  Widget _buildNavRail() {
    return Material(
        elevation: 12.0,
        child: SafeArea(
          // Not needed because the timer list is on the right side
          right: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: NavBarIconButton(
                  icon: Icons.add_circle,
                  iconSize: 25,
                  iconColor: Theme.of(context).colorScheme.primary,
                  label: 'New',
                  verticalPadding: 8,
                  onPressed: () {
                    context.read<TimerCreationProvider>().clear();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditTimer(editing: false),
                      ),
                    ).then((_) {
                      refreshTimers();
                    });
                  },
                ),
              ),
              Visibility(
                  visible: timerProvider.timers.isNotEmpty,
                  child: SizedBox(height: 12)),
              Visibility(
                  visible: timerProvider.timers.isNotEmpty,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: NavBarIconButton(
                          icon: Icons.upload,
                          iconSize: 25,
                          label: 'Export',
                          verticalPadding: 8,
                          onPressed: () {
                            onExportPressed(context, timerProvider.timers);
                          }))),
              SizedBox(height: 12),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: NavBarIconButton(
                      icon: Icons.download,
                      iconSize: 25,
                      label: 'Import',
                      verticalPadding: 8,
                      onPressed: () async {
                        await onImportPressed(
                          context,
                          timerProvider,
                          refreshTimers,
                        );
                      })),
              Spacer(),
              AboutButton(),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}
