import 'package:flutter/material.dart';

BoxDecoration buttonDecoration() {
  return const BoxDecoration(
    color: Color.fromARGB(31, 255, 255, 255),
    borderRadius: BorderRadius.all(Radius.circular(50)),
  );
}

Widget functionPlayerButton(
  IconData enabledIcon,
  IconData disabledIcon,
  bool isEnable,
  Function() onTap, {
  Key? key,
  Color? color,
}) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(30)),

    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,

        decoration: BoxDecoration(
          color: color ?? Color.fromARGB(31, 255, 255, 255),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 120),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.center,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
              child: Icon(
                isEnable ? enabledIcon : disabledIcon,
                key: ValueKey<bool>(isEnable),
                color: isEnable
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(255, 255, 255, 0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget functionPlayerButtonAndroid(
  IconData enabledIcon,
  IconData disabledIcon,
  bool isEnable,
  Function() onTap, {
  Key? key,
  Color? color,
}) {
  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.all(Radius.circular(30)),

    child: InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: SizedBox(
        height: 35,
        width: 35,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 120),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.center,
                children: [
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              ),
              child: Icon(
                isEnable ? enabledIcon : disabledIcon,
                key: ValueKey<bool>(isEnable),
                color: isEnable
                    ? Color.fromRGBO(255, 255, 255, 1)
                    : Color.fromRGBO(255, 255, 255, 0.5),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
