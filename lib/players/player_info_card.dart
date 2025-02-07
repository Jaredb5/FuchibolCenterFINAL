import 'package:flutter/material.dart';

class PlayerInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const PlayerInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title: $value',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
