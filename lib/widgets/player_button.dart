import 'package:flutter/material.dart';

class PlayerButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onPressed;

  const PlayerButton(this.icon, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Icon(
        icon,
        color: Colors.black,
      ),
    );
  }
}
