import 'package:flutter/material.dart';

//convert string to color
Color getColorFromName(String colorName) {
  final lowerName = colorName.toLowerCase();
  switch (lowerName) {
    case 'red':
      return Colors.red;
    case 'green':
      return Colors.green;
    case 'pink':
      return Colors.pink;
    case 'pinkaccent':
      return Colors.pinkAccent;
    case 'grey':
      return Colors.grey;
    case 'bluegrey':
      return Colors.blueGrey;
    case 'blueaccent':
      return Colors.blueAccent;
    case 'blue':
      return Colors.blue;
    case 'black':
      return Colors.black;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'purple':
      return Colors.purple;
    case 'purpleaccent':
      return Colors.purpleAccent;
    case 'brown':
      return Colors.brown;
    case 'teal':
      return Colors.teal;
    default:
      return Colors.blue.shade100; // default color if not recognized
  }
}
