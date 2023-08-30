import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BrowseCategoryCard extends StatelessWidget {
  BrowseCategoryCard({this.onTapTypeRoundedC});

  VoidCallback? onTapTypeRoundedC;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          onTapTypeRoundedC?.call();
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 21,
                  bottom: 76,
                ),
                child: Text(
                  "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
