import 'package:flutter/material.dart';

class Dark {
  static const Color primary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0x99EBEBF5);
  static const Color tertiary = Color(0x4DEBEBF5);
  static const Color quaternary = Color(0x2EEBEBF5);

  static const Color solid1 = Color(0xFF48319D);
  static const Color solid2 = Color(0xFF1F1D47);
  static const Color solid3 = Color(0xFFC427FB);
  static const Color solid4 = Color(0xFFE0D9FF);
}

class Light {
  static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(0x993C3C43);
  static const Color tertiary = Color(0x4D3C3C43);
  static const Color quaternary = Color(0x2E3C3C43);

  static const LinearGradient linear1 =
      LinearGradient(colors: [Color(0xFF2E335A), Color(0xFF1C1B33)]);
  static const LinearGradient linear2 =
      LinearGradient(colors: [Color(0xFF5936B4), Color(0XFF362A84)]);
  static const LinearGradient linear3 =
      LinearGradient(colors: [Color(0xFF427BD1), Color(0xFFC159EC)]);
  static const LinearGradient linear4 = LinearGradient(
      colors: [Color(0xFFAEC9FF), Color(0xFFAEC9FF), Color(0xFF083072)]);

  static const RadialGradient radial =
      RadialGradient(colors: [Color(0xFFF7CBFD), Color(0xFF7758D1)]);
}
