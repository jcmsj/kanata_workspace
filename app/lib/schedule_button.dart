import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier.dart';

class ScheduleButton extends StatefulWidget {
  const ScheduleButton({
    super.key,
  });

  @override
  State<ScheduleButton> createState() => _ScheduleButtonState();
}

class _ScheduleButtonState extends State<ScheduleButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: sched,
      tooltip: 'Schedule',
      child: const Icon(Icons.bluetooth),
    );
  }

  void sched() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Bluetooth will be deactivated at ${Provider.of<DurationNotifier>(context, listen: false).activationTime}"),
      ),
    );
    // log the activation time
    log("Bluetooth will be deactivated at ${Provider.of<DurationNotifier>(context).activationTime}");

    // TODO: schedule bluetooth deactivation
  }
}
