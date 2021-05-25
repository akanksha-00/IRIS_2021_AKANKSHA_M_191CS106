import 'package:flutter/material.dart';

const textFormFieldDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0)));

Widget button(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 17, color: Colors.white),
    ),
  );
}
