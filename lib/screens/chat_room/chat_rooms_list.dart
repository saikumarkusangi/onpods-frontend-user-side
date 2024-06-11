

import 'package:onpods/utils/exports.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  final data = [
    {'title': 'Basics of flutter development'},
    {'title': 'How to influence people'},
    {'title': 'Bit coin trading tricks'}
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
          
            bottom: const PreferredSize(
                preferredSize: Size(0, 6),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      TabBar(
                        splashFactory: NoSplash.splashFactory,
                        tabAlignment: TabAlignment.start,
                        indicatorColor: blueColor,
                        isScrollable: true,
                        splashBorderRadius: BorderRadius.zero,
                        dividerColor: Colors.transparent,
                        labelColor: blueColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor:
                            Color.fromARGB(255, 114, 111, 111),
                        labelStyle: TextStyle(fontSize: 20),
                        tabs: [Tab(text: "Live"), Tab(text: "Upcoming")],
                      ),
                    ],
                  ),
                )),
          ),
          body:const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Coming Soon...",style: TextStyle(fontSize: 24,color: Colors.white),)
              ],
            ),
          )
          
          //  Padding(
          //   padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          //   child: TabBarView(children: [
          //     ListView.builder(
          //         itemCount: data.length,
          //         itemBuilder: (context, index) {
          //           return GestureDetector(
          //             onTap: () {
          //               showRoomDetails(context, data[index]['title']!);
          //             },
          //             child: ChartRoomCard(title: data[index]['title']!),
          //           );
          //         }),
          //     const ChatRoomListkeleton()
          //   ]),
          // ),
      
        ));
  }
}
