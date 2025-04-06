// lib/core/widgets/custom_loader.dart

import 'package:flutter/material.dart';

/// A simple loader widget that can be displayed in place of screen content
/// or overlaid on top of it (e.g., with a Stack).
class CustomLoader extends StatelessWidget {
  final String message;

  const CustomLoader({
    Key? key,
    this.message = 'Loading...',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
