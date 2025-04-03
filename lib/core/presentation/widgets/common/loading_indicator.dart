import 'package:flutter/material.dart';

/// A simple centered circular progress indicator.
class LoadingIndicator extends StatelessWidget {
  final double strokeWidth;

  const LoadingIndicator({super.key, this.strokeWidth = 4.0});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(strokeWidth: strokeWidth));
  }
}
