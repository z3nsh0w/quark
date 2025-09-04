

import 'package:flutter/material.dart';

BoxDecoration overlayBoxDecoration() {
  return BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1,
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
    );
}