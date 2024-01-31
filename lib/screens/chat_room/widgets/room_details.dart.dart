
import 'package:onpods/utils/exports.dart';

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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
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
                        style:  TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        'Speakers',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5), fontSize: 18.sp),
                      ),
                    ),

                    GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.5,
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
                            color: Colors.white.withOpacity(0.5), fontSize: 18.sp),
                      ),
                    ),

                    GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 10),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    'https://randomuser.me/api/portraits/men/${index + 20}.jpg'),
                              ),
                               Text(
                                'Name',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                              )
                            ],
                          );
                        }),

                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      color: bottomSheetColor,
                      child: Center(
                          child: CustomElevatedButton(
                            onTap: () {},
                              width: 0.9.sw,
                              height: 50,
                              buttonTextStyle: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            buttonColor: blueColor,
                              text: 'Join Room')),
                    ),
                  ],
                ),
              ));
    },
  );
}
