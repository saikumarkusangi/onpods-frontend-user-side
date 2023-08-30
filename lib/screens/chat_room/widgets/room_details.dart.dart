import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onpods/screens/chat_room/widgets/user_avatar.dart';
import 'package:onpods/utils/utils_exports.dart';
import 'package:onpods/widgets/custom_button.dart';

showRoomDetails(context, title) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
          snap: true,
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          expand: true,
          builder: (context, controller) => Container(
                decoration: const BoxDecoration(
                    color: bottomSheetColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: textFieldColor,
                              borderRadius: BorderRadius.circular(10)),
                          width: 40,
                          height: 6,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Speakers',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5), fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.4,
                                mainAxisSpacing: 20),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return UserAvatar(index: index, name: 'name$index');
                        }),
                     const  Padding(
                         padding:  EdgeInsets.symmetric(horizontal: 15),
                         child: Divider(),
                       ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Listeners',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5), fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.4,
                                mainAxisSpacing: 20),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    'https://randomuser.me/api/portraits/men/${index + 20}.jpg'),
                              ),
                              const Text(
                                'Name',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              )
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      color: bottomSheetColor,
                      child: Center(
                          child: CustomElevatedButton(
                              width: 0.9.sw,
                              height: 40,
                              buttonTextStyle: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              buttonStyle: ButtonStyle(backgroundColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors
                                        .grey; // Color for disabled state
                                  }
                                  return Colors
                                      .blue; // Default color for enabled state
                                },
                              )),
                              text: 'Join Room')),
                    ),
                  ],
                ),
              ));
    },
  );
}
