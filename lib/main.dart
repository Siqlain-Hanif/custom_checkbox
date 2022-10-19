import 'package:custom_checkbox/custom_checkbox.dart';
import 'package:custom_checkbox/custom_checkbox_list_tile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? checkboxValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example Custom Checkbox"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CheckboxListTile(
                value: checkboxValue,
                title: Text("test"),
                subtitle: Text("Subtitle"),
                tristate: true,
                controlAffinity: ListTileControlAffinity.leading,
                visualDensity: VisualDensity.compact,
                onChanged: (bool? value) {
                  checkboxValue = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              CustomCheckBoxListTile(
                value: checkboxValue,
                tristate: true,
                visualDensity: VisualDensity.compact,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text("test"),
                subtitle: Text("Subtitle"),
                activeColor: Colors.green,
                activeIcon: Icons.access_time,
                tristateIcon: Icons.trip_origin,
                onChanged: (bool? value) {
                  checkboxValue = value;
                  setState(() {});
                },
              ),
              CustomCheckbox(
                value: checkboxValue,
                checkColor: Colors.black,
                tristate: true,
                onChanged: (bool? value) {
                  checkboxValue = value;
                  setState(() {});
                },
              ),
              const SizedBox(height: 50),
              Checkbox(
                value: checkboxValue,
                autofocus: true,
                tristate: true,
                onChanged: (bool? value) {
                  checkboxValue = value;
                  setState(() {});
                },
                checkColor: Colors.black,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.orange.withOpacity(.32);
                    }
                    return Colors.orange;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
