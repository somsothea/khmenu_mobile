import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';

class SecondStateScreen extends StatelessWidget {

  // int counter = 0;
  // SecondStateScreen(this.counter);

  // const SimpleStateScreen({super.key});
  int _counter = 0;

  @override
  Widget build(BuildContext context) {

    _counter = context.watch<CounterLogic>().counter;

    return Scaffold(
      appBar: AppBar(
        title: Text("Second State Screen"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().decrease();
              debugPrint("counter: $_counter");
            },
            icon: Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().increase();
              debugPrint("counter: $_counter");
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Text(
          "In the country's northwest are the ruins of Angkor Wat, a massive stone temple complex built during the Khmer Empire",
          // style: TextStyle(fontSize: 18 + _counter.toDouble()),
        ),
      ),
    );
  }
}
