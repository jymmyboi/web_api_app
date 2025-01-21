import 'package:flutter/material.dart';

class FutureWidget<T> extends StatelessWidget {
  const FutureWidget({
    super.key,
    required this.future,
    required this.dataBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  });

  final Future<T> future;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? errorBuilder;
  final WidgetBuilder? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return (loadingBuilder != null)
              ? loadingBuilder!(context)
              : const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return (errorBuilder != null)
              ? errorBuilder!(context)
              : Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return (emptyBuilder != null)
              ? emptyBuilder!(context)
              : const Center(child: Text('No data available.'));
        } else {
          return dataBuilder(context, snapshot.data!);
        }
      },
    );
  }
}
