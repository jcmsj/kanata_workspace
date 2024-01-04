import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifier.dart';
import 'schedule_button.dart';

void main() {
  runApp(const App());
}

// https://love-live.fandom.com/wiki/Kanata_Konoe?file=Kanata_Logo.png
const KANATA_COLOR = Color(0xffb5528f);

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DurationNotifier()),
      ],
      child: MaterialApp(
        title: 'Kanata',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: KANATA_COLOR),
          useMaterial3: true,
        ),
        home: const HomePage(title: 'Kanata'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const Main(),
      floatingActionButton: const ScheduleButton(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<DurationNotifier>(context, listen: false)
        .restore()
        .whenComplete(() => syncValue());
  }

  void setValue(int m) {
    controller.value = TextEditingValue(text: m.toString());
  }

  void syncValue() {
    log("Syncing...");
    setValue(Provider.of<DurationNotifier>(context, listen: false)
        .totalTimeInMinutes);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  void activate() {
    super.activate();
    syncValue();
  }

  // when the app hot reloads set the text to the current time
  @override
  void reassemble() {
    super.reassemble();
    syncValue();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(
            builder: (context, DurationNotifier durationNotifier, child) {
          return Column(
            children: [
              // Show a HH hours MM minutes  format text
              Text(
                "Duration:",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                '${durationNotifier.hours.toString().padLeft(2, '0')} h ${durationNotifier.minutes.toString().padLeft(2, '0')} m',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                "Activates at:",
                style: Theme.of(context).textTheme.displayMedium,
              ),
              //  Show time the timerwill expire HH:MM AM/PM format
              Text(
                '${(durationNotifier.hours + DateTime.now().hour).toString().padLeft(2, '0')}:${(durationNotifier.minutes + DateTime.now().minute).toString().padLeft(2, '0')}',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              // spacer 1/24 of screen height
              SizedBox(
                height: MediaQuery.of(context).size.height / 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ScheduleField(controller: controller),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}

class ScheduleField extends StatefulWidget {
  final TextEditingController controller;

  const ScheduleField({
    super.key,
    required this.controller,
  });

  @override
  State<ScheduleField> createState() => _ScheduleFieldState();
}

class _ScheduleFieldState extends State<ScheduleField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: Consumer<DurationNotifier>(
          builder: (context, durationNotifier, child) {
        return TextField(
          maxLength: 4,
          style: Theme.of(context).textTheme.displayMedium,
          controller: widget.controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Minutes',
              labelStyle: Theme.of(context).textTheme.displaySmall,
              // suffix button to clear
              suffix: IconButton.outlined(
                onPressed: () {
                  durationNotifier.totalTimeInMinutes = 0;
                  widget.controller.clear();
                },
                icon: const Icon(Icons.clear),
              )),
          onChanged: (value) {
            durationNotifier.totalTimeInMinutes =
                value == "" ? 0 : int.parse(value);
          },
        );
      }),
    );
  }
}
