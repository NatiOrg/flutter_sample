import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
      home: Home(),
    ));

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text('Tip Calculator'),
        centerTitle: true,
      ),
      body: TipCalculator(),
    );
  }
}

class TipCalculator extends StatefulWidget {
  @override
  _TipCalculatorState createState() => _TipCalculatorState();
}

class _TipCalculatorState extends State<TipCalculator>
    with SingleTickerProviderStateMixin {
  TextEditingController billController;
  TextEditingController tipController;
  TextEditingController numOfPeopleController;

  double tipPerPerson = 0;
  double totalPerPerson = 0;

  bool multiplePerson = false;

  @override
  void initState() {
    billController = TextEditingController();
    tipController = TextEditingController(text: "15");
    numOfPeopleController = TextEditingController(text: "1");

    billController.addListener(calculateTip);
    tipController.addListener(calculateTip);
    numOfPeopleController.addListener(updateMultiplePerson);
    numOfPeopleController.addListener(calculateTip);
    super.initState();
  }

  void calculateTip() {
    if (billController.text == null ||
        billController.text.isEmpty ||
        tipController.text == null ||
        tipController.text.isEmpty ||
        numOfPeopleController.text == null ||
        numOfPeopleController.text.isEmpty) {
      tipPerPerson = 0;
      totalPerPerson = 0;
      return;
    }

    var bill = double.parse(billController.text);
    var tip = double.parse(tipController.text);
    var numberOfPeople = int.parse(numOfPeopleController.text);

    tipPerPerson = (bill * tip / 100) / numberOfPeople;
    totalPerPerson = bill / numberOfPeople + tipPerPerson;

    setState(() {});
  }

  void updateMultiplePerson() {
    if (numOfPeopleController.text == null ||
        numOfPeopleController.text.isEmpty) {
      return;
    }

    multiplePerson = numOfPeopleController.text != '1';

    setState(() {});
  }

  @override
  void dispose() {
    billController.dispose();
    tipController.dispose();
    numOfPeopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20), child: BillWidget(billController)),
        Container(padding: EdgeInsets.all(20), child: TipWidget(tipController)),
        Container(
            padding: EdgeInsets.all(20),
            child: NumberOfPeopleWidget(numOfPeopleController)),
        Container(
            padding: EdgeInsets.all(20),
            child: TotalTipWidget(tipPerPerson, multiplePerson)),
        Container(
            padding: EdgeInsets.all(20),
            child: TotalAmountWidget(totalPerPerson, multiplePerson)),
      ],
    );
  }
}

class BillWidget extends StatelessWidget {
  TextEditingController controller;

  BillWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return NumberInputField(
      this.controller,
      'Bill',
      TextAlign.center,
      isDecimal: true,
      minValue: 0,
      unit: '???',
    );
  }
}

class TipWidget extends StatelessWidget {
  TextEditingController controller;

  TipWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return IncreaseDecreaseWidget(
      this.controller,
      'Tip',
      Colors.green[400],
      isDecimal: true,
      minValue: 0,
      maxValue: 100,
      unit: '%',
    );
  }
}

class NumberOfPeopleWidget extends StatelessWidget {
  TextEditingController controller;

  NumberOfPeopleWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return IncreaseDecreaseWidget(
      this.controller,
      'Number Of People',
      Colors.green[400],
      minValue: 1,
    );
  }
}

class TotalTipWidget extends StatelessWidget {
  double tip;
  bool multiplePerson;

  TotalTipWidget(this.tip, this.multiplePerson);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GeneralText(multiplePerson ? 'Tip Per Person' : 'Tip', 20),
        GeneralText(this.tip.toString() + " ???", 20)
      ],
    );
  }
}

class TotalAmountWidget extends StatelessWidget {
  double total;
  bool multiplePerson;

  TotalAmountWidget(this.total, this.multiplePerson);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GeneralText(multiplePerson ? 'Total Per Person' : 'Total', 20),
        GeneralText(total.toString() + " ???", 20)
      ],
    );
  }
}

class IncreaseDecreaseWidget extends StatelessWidget {
  bool isDecimal;
  String label;
  Color color;
  TextEditingController controller;
  double maxValue;
  double minValue;
  String unit;

  IncreaseDecreaseWidget(this.controller, this.label, this.color,
      {this.isDecimal = false, this.maxValue, this.minValue, this.unit});

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      RaisedButton(
          onPressed: () {
            if (controller.text == null || controller.text == '') return;

            var newVal = this.isDecimal
                ? double.parse(controller.text) + 1
                : int.parse(controller.text) + 1;

            if (this.maxValue == null ||
                (this.maxValue != null && newVal <= this.maxValue)) {
              controller.text = newVal.toString();
            }
          },
          child: Icon(Icons.add),
          color: this.color),
      Expanded(
        child: Container(
          child: NumberInputField(this.controller, this.label, TextAlign.center,
              isDecimal: this.isDecimal,
              maxValue: this.maxValue,
              minValue: this.minValue,
              unit: this.unit),
        ),
      ),
      RaisedButton(
          onPressed: () {
            if (controller.text == null || controller.text == '') return;

            var newVal = this.isDecimal
                ? double.parse(controller.text) - 1
                : int.parse(controller.text) - 1;
            if (this.minValue == null ||
                (this.minValue != null && newVal >= this.minValue)) {
              controller.text = newVal.toString();
            }
          },
          child: Icon(Icons.remove),
          color: this.color)
    ]);
  }
}

class NumberInputField extends StatelessWidget {
  bool isDecimal;
  String label;
  TextAlign textAlign;
  TextEditingController controller;
  double maxValue;
  double minValue;
  String unit;

  NumberInputField(this.controller, this.label, this.textAlign,
      {this.isDecimal = false, this.maxValue, this.minValue, this.unit});

  @override
  Widget build(BuildContext context) {
    return GeneralTextField(
      this.controller,
      this.label,
      this.textAlign,
      formatters: [
        WhitelistingTextInputFormatter(
            RegExp(this.isDecimal ? r"[\d.]" : r"[\d]")),
        GeneralInputFormatter(this.maxValue, this.minValue),
      ],
      textInputType: TextInputType.numberWithOptions(decimal: this.isDecimal),
      unit: this.unit,
    );
  }
}

class GeneralText extends StatelessWidget {
  String text;
  double fontSize;

  GeneralText(this.text, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      this.text,
      style: TextStyle(fontSize: this.fontSize),
    );
  }
}

class GeneralTextField extends StatelessWidget {
  String label;
  TextAlign textAlign;
  List<TextInputFormatter> formatters;
  TextInputType textInputType;
  TextEditingController controller;
  String unit;

  GeneralTextField(this.controller, this.label, this.textAlign,
      {this.formatters = const [],
      this.textInputType = TextInputType.text,
      this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                textAlign: this.textAlign,
                inputFormatters: this.formatters,
                keyboardType: this.textInputType,
                decoration: InputDecoration(
                  labelText: this.label,
                ),
              ),
            ),
            if (this.unit != null) Text(this.unit)
          ],
        ));
  }
}

class GeneralInputFormatter extends TextInputFormatter {
  double maxValue;
  double minValue;

  GeneralInputFormatter(this.maxValue, this.minValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (this.maxValue != null && double.parse(newValue.text) > this.maxValue) {
      return oldValue;
    }

    if (this.minValue != null && double.parse(newValue.text) < this.minValue) {
      return oldValue;
    }

    return newValue;
  }
}

//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//        // This makes the visual density adapt to the platform that you run
//        // the app on. For desktop platforms, the controls will be smaller and
//        // closer together (more dense) than on mobile platforms.
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
//      home: MyHomePage(title: 'Flutter Demo Home Page'),
//    );
//  }
//}
//
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//
//class _MyHomePageState extends State<MyHomePage> {
//  int _counter = 0;
//
//  void _incrementCounter() {
//    setState(() {
//      // This call to setState tells the Flutter framework that something has
//      // changed in this State, which causes it to rerun the build method below
//      // so that the display can reflect the updated values. If we changed
//      // _counter without calling setState(), then the build method would not be
//      // called again, and so nothing would appear to happen.
//      _counter++;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    // This method is rerun every time setState is called, for instance as done
//    // by the _incrementCounter method above.
//    //
//    // The Flutter framework has been optimized to make rerunning build methods
//    // fast, so that you can just rebuild anything that needs updating rather
//    // than having to individually change instances of widgets.
//    return Scaffold(
//      appBar: AppBar(
//        // Here we take the value from the MyHomePage object that was created by
//        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
//      ),
//      body: Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.headline4,
//            ),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _incrementCounter,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.
//    );
//  }
//}
