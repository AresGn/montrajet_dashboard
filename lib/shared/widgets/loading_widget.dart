import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double? value; // 0-1 for progress indicator

  const LoadingWidget({
    Key? key,
    this.message,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (value != null)
            SizedBox(
              width: 120,
              child: CircularProgressIndicator(
                value: value,
                strokeWidth: 4,
              ),
            )
          else
            const SizedBox(
              width: 120,
              child: CircularProgressIndicator(strokeWidth: 4),
            ),
          const SizedBox(height: 24),
          if (message != null)
            Text(
              message!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
        ],
      ),
    );
  }
}
