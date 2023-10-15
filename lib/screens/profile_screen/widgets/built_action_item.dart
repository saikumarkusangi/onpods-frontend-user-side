 import '../../../utils/exports.dart';

Widget buildActionItem(
      IconData icon, String title, Function() onTap, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80), color: color),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }