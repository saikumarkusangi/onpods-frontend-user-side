import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hud/flutter_hud.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:onpods/providers/providers_exports.dart';
import 'package:onpods/resources/quote_service.dart';
import 'package:onpods/utils/colors.dart';
import 'package:provider/provider.dart';

import '../layout_screen.dart';

class UploadQuotes extends StatefulWidget {
  final File image;
  const UploadQuotes({Key? key, required this.image}) : super(key: key);

  @override
  State<UploadQuotes> createState() => _UploadQuotesState();
}

class _UploadQuotesState extends State<UploadQuotes> {
  String selectedChipIndex =
      ''; // Index of the selected chip, -1 means none selected
  bool loading = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    final provider = Provider.of<QuoteProvider>(context, listen: false);
    if (provider.quotesCategories.isEmpty) {
      await provider.fetchCategories();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuoteProvider>(context, listen: false);
    List<Widget> chipWidgets =
        provider.quotesCategories.asMap().entries.map((entry) {
      final index = entry.value.id;
      final category = entry.value;

      // Define BorderRadius for the chip
      BorderRadiusGeometry borderRadius = BorderRadius.circular(40);

      return ChoiceChip(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius, // Use the defined BorderRadius here
        ),
        label: Text(category.name),
        checkmarkColor: Colors.white,
        selectedColor: blueColor,
        labelStyle: TextStyle(
            color: selectedChipIndex == index ? Colors.white : Colors.black),
        selected: selectedChipIndex == index, // Check if this chip is selected
        onSelected: (bool selected) {
          setState(() {
            selectedChipIndex = selected ? index : '';
          });
        },
      );
    }).toList();

    return WidgetHUD(
      showHUD: loading,
      hud: HUD(
          progressIndicator: const CircularProgressIndicator(
        color: blueColor,
      )),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Upload',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            TextButton(
              child: const Text('post',
                  style: TextStyle(color: blueColor, fontSize: 18)),
              onPressed: () async {
                if (selectedChipIndex != '') {
                  setState(() {
                    loading = true;
                  });
                  bool res = await QuoteService()
                      .uploadQuotes(selectedChipIndex, widget.image);
                  setState(() {
                    loading = false;
                  });
                  if (res) {
                    Get.snackbar(
                      
                      'Success', // Title
                      'Quote Uploaded Successfully',
                       backgroundColor: Colors.white
                    );
                    Get.offAll(const Layout());
                  }else{
                     Get.snackbar(
                      'Failed', // Title
                      'Something went wrong', // Message
                    );
                  }
                } else {
                  Fluttertoast.showToast(msg: 'Select One Category');
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                  child: Image.file(widget.image,
                      height: 0.4.sh, width: double.maxFinite)),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  'Select Quote Category',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Wrap(
                spacing: 10, // Adjust spacing as needed
                runSpacing: 10, // Adjust runSpacing as needed
                children: chipWidgets,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
