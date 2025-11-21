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
    timerProvider = Provider.of<TimerProvider>(context, listen: false);
    refreshTimers();
  }

  bool _isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // 600 is a common breakpoint for tablets.
    return size.shortestSide >= 600;
  }

  void refreshTimers() {
    setState(() {
      _loadTimersFuture = timerProvider.loadTimers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TimerType>>(
      future: _loadTimersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          logger.e("Error fetching timers: ${snapshot.error}");
          return Scaffold(
            body:
                Center(child: Text('Error fetching timers: ${snapshot.error}')),
          );
        }

        final timers = snapshot.data ?? [];

        return LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final isTablet = _isTablet(context);

            return Scaffold(
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar: isTablet && isLandscape
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(40.0),
                      child: AppBar(
                        toolbarHeight: 1.0,
                        elevation: 0,
                      ),
                    )
                  : (!isLandscape ? ListTimersAppBar() : null),
              body: isLandscape || isTablet
                  ? Row(
                      children: [
                        _buildNavRail(timers),
                        Expanded(
                          child: SafeArea(
                            left: false,
                            child: _buildTimerList(timers),
                          ),
                        ),
                      ],
                    )
                  : SafeArea(
                      child: _buildTimerList(timers),
                    ),
              bottomNavigationBar: !isLandscape
                  ? SafeArea(
                      top: false,
                      child: _buildBottomNavBar(timers),
                    )
                  : null,
            );
          },
        );
      },
    );
  }

  // -------------------
  // Timer List
  // -------------------
  Widget _buildTimerList(List<TimerType> timers) {
    if (timers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('No saved timers', style: TextStyle(fontSize: 20)),
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
        context.read<TimerCreationProvider>().setTimer(timer);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditTimer(editing: true)),
        ).then((_) => refreshTimers());
      },
    );
  }

  // -------------------
  // Bottom Navigation Bar (Portrait)
  // -------------------
  Widget _buildBottomNavBar(List<TimerType> timers) {
    return CustomBottomAppBar(
      children: [
        Visibility(visible: timers.isNotEmpty, child: const Spacer()),
        Visibility(
          visible: timers.isNotEmpty,
          child: NavBarIconButton(
            icon: Icons.upload,
            label: 'Export',
            fontSize: 11,
            spacing: 0,
            verticalPadding: 0,
            onPressed: () {
              onExportPressed(context, timers);
            },
          ),
        ),
        const Spacer(),
        NavBarIconButton(
          icon: Icons.download,
          label: 'Import',
          fontSize: 11,
          spacing: 0,
          verticalPadding: 0,
          onPressed: () async {
            await onImportPressed(context, timerProvider);
            refreshTimers();
          },
        ),
        const Spacer(),
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
                  builder: (context) => const EditTimer(editing: false)),
            ).then((_) => refreshTimers());
          },
        ),
        const Spacer(),
      ],
    );
  }

  // -------------------
  // Nav Rail (Landscape / Tablet)
  // -------------------
  Widget _buildNavRail(List<TimerType> timers) {
    return Material(
      elevation: 12.0,
      child: SafeArea(
        right: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
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
                        builder: (context) => const EditTimer(editing: false)),
                  ).then((_) => refreshTimers());
                },
              ),
            ),
            Visibility(
                visible: timers.isNotEmpty, child: const SizedBox(height: 12)),
            Visibility(
              visible: timers.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: NavBarIconButton(
                  icon: Icons.upload,
                  iconSize: 25,
                  label: 'Export',
                  verticalPadding: 8,
                  onPressed: () {
                    onExportPressed(context, timers);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: NavBarIconButton(
                icon: Icons.download,
                iconSize: 25,
                label: 'Import',
                verticalPadding: 8,
                onPressed: () async {
                  await onImportPressed(context, timerProvider);
                  refreshTimers();
                },
              ),
            ),
            const Spacer(),
            const AboutButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
