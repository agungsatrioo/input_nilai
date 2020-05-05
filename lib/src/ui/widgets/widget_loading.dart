import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: LoadingIndicator(),
        ),
      );
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator()),
          Text("Harap tunggu...")
        ],
      ),
    );
}