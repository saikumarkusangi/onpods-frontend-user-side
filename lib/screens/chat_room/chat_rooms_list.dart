import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onpods/utils/colors.dart';
import 'package:onpods/utils/images.dart';
import 'package:onpods/widgets/custom_text_field.dart';
import 'widgets/chat_room_card.dart';
import 'widgets/chat_room_skeleton.dart';
import 'widgets/room_details.dart.dart';

class ChatRoomList extends StatefulWidget {
  const ChatRoomList({super.key});

  @override
  State<ChatRoomList> createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  bool _showFab = true;

  final data = [
    {'title': 'Basics of flutter development'},
    {'title': 'How to influence people'},
    {'title': 'Bit coin trading tricks'}
  ];

  @override
  Widget build(BuildContext context) {
    print('object');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 120,
          backgroundColor: scaffoldBackgroundColor,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Image.asset(appBarLogo),
          ),
          bottom: const PreferredSize(
              preferredSize: Size(0, 120),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    CustomTextFormField(
                      autofocus: false,
                      radius: 10,
                      hintText: "Search...",
                      vertical: 16,
                      fillColor: textFieldColor,
                      hintStyle: TextStyle(color: Colors.grey),
                      textStyle: TextStyle(color: Colors.white),
                    ),
                    TabBar(
                      splashFactory: NoSplash.splashFactory,
                      tabAlignment: TabAlignment.start,
                      indicatorColor: Colors.blue,
                      isScrollable: true,
                      splashBorderRadius: BorderRadius.zero,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.blue,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Color.fromARGB(255, 114, 111, 111),
                      labelStyle: TextStyle(fontSize: 20),
                      tabs: [Tab(text: "Live"), Tab(text: "Upcoming")],
                    ),
                  ],
                ),
              )),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            final ScrollDirection direction = notification.direction;
            setState(() {
              if (direction == ScrollDirection.reverse) {
                _showFab = false;
              } else if (direction == ScrollDirection.forward) {
                _showFab = true;
              }
            });
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: TabBarView(children: [
              ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showRoomDetails(context, data[index]['title']!);
                      },
                      child: ChartRoomCard(title: data[index]['title']!),
                    );
                  }),
              const ChatRoomListkeleton()
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            onPressed: () {},
            isExtended: _showFab,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: const Text(
              'Start a room',
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
      ),
    );
  }
}

