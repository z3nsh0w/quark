import 'package:flutter/material.dart';

enum StateIndicatorOperation { none, error, success, loading }

class StateIndicator extends StatelessWidget {
  final StateIndicatorOperation operation;

  const StateIndicator({Key? key, required this.operation}) : super(key: key);

  static Color _getColor(StateIndicatorOperation operation) {
    switch (operation) {
      case StateIndicatorOperation.none:
        return Colors.transparent;
      case StateIndicatorOperation.success:
        return Colors.greenAccent;
      case StateIndicatorOperation.error:
        return Colors.red;
      case StateIndicatorOperation.loading:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: _getColor(operation),
        shape: BoxShape.circle,
      ),
    );
  }
}
