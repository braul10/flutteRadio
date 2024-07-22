import 'package:flutter/material.dart';

class BodyWrapper extends StatefulWidget {
  final Widget child;

  const BodyWrapper({required this.child, super.key});

  @override
  State<StatefulWidget> createState() => _BodyWrapperState();
}

class _BodyWrapperState extends State<BodyWrapper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Colors.black,
        ),
        child: widget.child,
      ),
    );
  }
}
