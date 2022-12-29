import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CenterProgressIndicator extends StatelessWidget {
  const CenterProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Color.fromARGB(255, 12, 12, 12)),
    );
  }
}
