import 'package:onpods/utils/exports.dart';

Widget customGoogleButton(String title,VoidCallback  onTap) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        fixedSize: MaterialStateProperty.resolveWith<Size?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Size(1.sw,50);
            }
            return Size(1.sw, 50);
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return Colors.white;
          },
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            googleLogo,
            height: 20,
          ),
          const SizedBox(
            width: 20,
          ),
           Text(
            title,
            style: const TextStyle(color: blueColor,fontSize: 18),
          ),
        ],
      ),
    );
  }

