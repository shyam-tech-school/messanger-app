import 'package:flutter/material.dart';

class CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function()? ontap;

  const CallActionButton({
    super.key,
    required this.icon,
    this.color = Colors.white12,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
