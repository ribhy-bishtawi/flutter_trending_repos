import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Constants {
  static const wrongAnswerSkipLimit = 3;

  static final gapW16 = SizedBox(width: 16.w);
  static final gapW4 = SizedBox(width: 4.w);
  static final gapH8 = SizedBox(height: 8.h);

  static final borderRadius8 = BorderRadius.circular(8.0.r);

  static final paddingAll16 = EdgeInsets.all(16.w);
  static final iconSizeWidth30 = 30.w;

  static final marginVertical8Horizontal16 =
      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w);
  static final marginAll16 = EdgeInsets.all(16.w);
}
