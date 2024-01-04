import 'package:bt/bt.dart';
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

var bt = Bt();

class _ScheduleButtonState extends State<ScheduleButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: sched,
      tooltip: 'Schedule',
      child: const Icon(Icons.bluetooth),
    );
  }

  void onBtDenied() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Bluetooth permission is required"),
      ),
    );
  }

  void onAlarmDenied() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Alarm permission is required"),
      ),
    );
  }

  void sched() {
    //  save it
    Provider.of<DurationNotifier>(context, listen: false).save();
    bt
        .scheduleDeactivation(
            Provider.of<DurationNotifier>(context, listen: false)
                .totalTimeInMinutes)
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Bluetooth will be deactivated at ${Provider.of<DurationNotifier>(context, listen: false).activationTime}"),
                ),
              )
            })
        .onError((error, stackTrace) => {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Could not schedule bluetooth deactivation"),
                ),
              )
            });

    // TODO: schedule bluetooth deactivation
  }
}
