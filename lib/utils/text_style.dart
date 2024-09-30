import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'palette.dart';

class AppTextStyle {
  static TextStyle headline = TextStyle(
    fontSize: 24.0.sp,
    fontWeight: FontWeight.bold,
    color: Palette.header,
  );

  static TextStyle primaryText = TextStyle(
    fontSize: 24.0.sp,
    fontWeight: FontWeight.bold,
    color: Palette.header,
  );

  static TextStyle secondaryText = TextStyle(
    fontSize: 16.0.sp,
    fontWeight: FontWeight.w400,
    color: Palette.secondaryText,
  );
}
