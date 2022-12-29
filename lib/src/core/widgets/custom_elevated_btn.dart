import 'package:flutter/material.dart';

import '../media_query.dart';
import '../utils/app_size.dart';

class CustomElevatedBtn extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final double? width;
  final isLoading = false;

  const CustomElevatedBtn({
    Key? key,
    this.onPressed,
    required this.label,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s50,
      width: width ?? context.width / 2,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : Text(label),
      ),
    );
  }
}
