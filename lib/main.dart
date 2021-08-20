import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _result = 0;

  TextEditingController weightController = new TextEditingController();

  void _calculate() {
    FlutterBlue flutterBlue = FlutterBlue.instance;
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 1));

    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) async {
      // do something with scan results
      int count = 0;
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
      for (ScanResult r in results) {
        //print(count);
        if ('HCare Plus C49F' == r.device.name.trim()) {
          print('$count.   ${r.device.name} found! rssi: ${r.rssi}');
          await r.device.connect();
          print(" --------------------------------------- Connected");
        }
        count++;
      }
    });
    // Stop scanning
    flutterBlue.stopScan();
    print("======================");
    print(subscription);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ListView.builder(
            //   padding: const EdgeInsets.all(2),
            //   itemCount: entries.length,
            //   itemBuilder: (BuildContext context, int index) {
            //     return Container(
            //       height: 50,
            //       color: Colors.amber[colorCodes[index]],
            //       child: Center(child: Text('Entry ${entries[index]}')),
            //     );
            //   }
            // ),
            Text(
              'น้ำที่คุณควรจะดื่นวันละ',
            ),
            Text(
              '$_result',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextFormField(
              controller: weightController,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Kg.',
                labelText: 'กรอกน้ำหน้กของคุณ',
              ),
            ),
            TextButton(
              onPressed: () {
                _calculate();
                // Respond to button press
              },
              child: Text("TEXT BUTTON"),
            )
          ],
        ),
      ),
    );
  }
}
