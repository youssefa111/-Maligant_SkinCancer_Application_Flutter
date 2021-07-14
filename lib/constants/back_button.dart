import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: non_constant_identifier_names
Widget MyBackButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      EasyLoading.dismiss();
      Navigator.pop(context);
    },
    icon: FaIcon(
      FontAwesomeIcons.arrowAltCircleLeft,
      size: 36,
    ),
  );
}
