 import '../../../utils/exports.dart';

Widget buildActionItem(
      IconData icon, String title, Function() onTap, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        splashColor: const Color.fromARGB(255, 42, 42, 42),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80), color: color),
          child: Icon(
            icon,
            size: 32,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style:  TextStyle(
            color: Colors.white,
            fontSize: 26.sp,
          ),
        ),
        onTap: onTap,
      ),
    );
  }