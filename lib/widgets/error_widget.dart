import 'package:flutter/material.dart';

class BGMErrorWidget extends StatelessWidget {
  const BGMErrorWidget({
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Text(errorMessage),
            SizedBox(height: 16.0),
            TextButton(onPressed: onRetry, child: Text('Retry')),
          ],
        ),
      ),
    );
  }
}
