import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:onpods/utils/utils_exports.dart';

class QuotesForYou extends StatefulWidget {
  const QuotesForYou({super.key});

  @override
  State<QuotesForYou> createState() => _QuotesForYouState();
}

class _QuotesForYouState extends State<QuotesForYou> {
  @override
  Widget build(BuildContext context) {
    List<Widget> listTile = <Widget>[
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i.pinimg.com/236x/85/25/80/8525803a3bc75602b03ede2b011b5067.jpg"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i.pinimg.com/474x/8b/57/a8/8b57a85616fcad535ecd85ee1b87b129.jpg"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://img.freepik.com/free-vector/calligraphic-background-motivational-quote_52683-16294.jpg?w=2000"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i0.wp.com/avemateiu.com/wp-content/uploads/2019/05/quote-271.png?fit=1080%2C1080&ssl=1"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i0.wp.com/avemateiu.com/wp-content/uploads/2019/05/quote-271.png?fit=1080%2C1080&ssl=1"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSTqlJevy58P-lkO7dj6kNB1zelqDpgVfHCA&usqp=CAU"),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
              "https://i.pinimg.com/236x/9f/a4/5a/9fa45a5cf307b04d80cdba5b2f152180--hd-wallpaper-wallpapers.jpg"),
        ),
      )
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Quotes for you',
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        StaggeredGridTemplete(listTile: listTile)

        // QuotesSkeleton()
      ],
    );
  }
}
