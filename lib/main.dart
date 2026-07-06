import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter App',
      home: const CounterScreen(),
    ); // MaterialApp
  }
}

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('My First Flutter App'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ), // AppBar
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'You have pressed the button this many times:',
                ), // Text
                Text(
                  '$_counter',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ), // Text
              ],
            ), // Column
          ), // Center
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(
                'Created by: Jeremy Don Giyangan',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.deepPurple,
                ), // TextStyle
              ), // Text
            ), // Padding
          ), // Align
        ],
      ), // Stack
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            heroTag: 'increment',
            child: const Icon(Icons.add),
          ), // FloatingActionButton
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: _decrementCounter,
            heroTag: 'decrement',
            backgroundColor: Colors.deepPurple.shade200,
            child: const Icon(Icons.remove),
          ), // FloatingActionButton
        ],
      ), // Column
    ); // Scaffold
  }
}