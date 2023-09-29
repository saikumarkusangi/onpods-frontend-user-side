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
            flexibleSpace: const Padding(
                padding: EdgeInsets.only(top: 50, left: 10, right: 10),
                child: CustomTextFormField(
                  autofocus: false,
                  radius: 10,
                  prefix: Icon(
                    Icons.search_rounded,
                    color: Colors.grey,
                    size: 26,
                  ),
                  hintText: "Search author,category & more...",
                  vertical: 16,
                  fillColor: textFieldColor,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  textStyle: TextStyle(color: Colors.white),
                )),
            bottom: const PreferredSize(
                preferredSize: Size(0, 80),
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
          body: Padding(
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
      
        ));
  }
}
