import 'dart:async';

import 'package:example/dio_utils.dart';
import 'package:flutter/material.dart';
import 'package:lack_off_debug_logs/lack_off.dart';

void main() {
  LackOff.initialize(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LackOff Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'LackOff Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didUpdateWidget(covariant MyHomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  LackOff.showLackOffButton(context);
                },
                child: const Text(
                  'showLackOffButton',
                )),
            ElevatedButton(
                onPressed: () {
                  throw Exception('flutter runtime exception');
                },
                child: const Text(
                  'flutter error',
                )),
            ElevatedButton(
                onPressed: () {
                  // 模拟一个定时器异常
                  Timer(const Duration(seconds: 2), () {
                    throw Exception('This is an unexpected error!');
                  });
                },
                child: const Text(
                  'dart error',
                )),
            ElevatedButton(
                onPressed: () {
                  DioUtil.instance.get();
                },
                child: const Text(
                  'dio log',
                )),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    // 模拟网络请求延迟
    await Future.delayed(Duration(seconds: 1));

    // 抛出一个异常，例如网络请求失败
    throw Exception('网络请求失败！');
  }
}
