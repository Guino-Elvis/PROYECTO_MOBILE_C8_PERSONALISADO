import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDiurno = false;

  bool get isDiurno => _isDiurno;

  void toggleTheme() {
    _isDiurno = !_isDiurno;
    notifyListeners();
  }

  static Color personalizado_0 = HexColor("#CDAF1A");
  // static Color personalizado_0 = HexColor("#77F067");
  static Color fondodark_1 = HexColor("#1A1B1F");
  static Color fondodarkcard_2 = HexColor("#161719");
  static Color color3 = Colors.orange;
  static Color color4 = Colors.purple;
  static Color color5 = Colors.yellow;
  static Color color6 = Colors.black;
  static Color color7 = Colors.white;
  static Color color8 = Colors.transparent;
  static Color textdia_9 = Colors.black;
  static Color textdark_10 = Colors.black;
  static Color color11 = Colors.grey.shade900;
  static Color color12 = Colors.grey.shade100;

  List<Color> diatheme() {
    return [
      personalizado_0,
      fondodark_1,
      fondodarkcard_2,
      color3,
      color4,
      color5,
      color6,
      color7,
      color8,
      textdia_9,
      textdark_10,
      color11,
      color12,
    ];
  }

  List<Color> nochetheme() {
    return [
      personalizado_0,
      fondodark_1,
      fondodarkcard_2,
      color3,
      color4,
      color5,
      color6,
      color7,
      color8,
      textdia_9,
      textdark_10,
      color11,
      color12,
    ];
  }

  List<Color> getThemeColors() {
    return _isDiurno ? diatheme() : nochetheme();
  }
}
