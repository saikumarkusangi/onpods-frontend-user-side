import 'package:onpods/utils/exports.dart';

class ChooseYourInterestScreen extends StatefulWidget {
  const ChooseYourInterestScreen({super.key});

  @override
  State<ChooseYourInterestScreen> createState() =>
      _ChooseYourInterestScreenState();
}

class _ChooseYourInterestScreenState extends State<ChooseYourInterestScreen> {
  List selectedChipIndex = [];
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
    final provider = Provider.of<QuoteProvider>(context);
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
            color: selectedChipIndex.contains(index)
                ? Colors.white
                : Colors.black),
        selected: selectedChipIndex.contains(index),
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              if (selectedChipIndex.length < 3) {
                selectedChipIndex.add(index);
              } else {
                Fluttertoast.showToast(msg: 'Max 3 categories are allowed');
              }
            } else {
              selectedChipIndex.remove(index);
            }
          });
        },
      );
    }).toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: darkscaffoldBackgroundColor,
          toolbarHeight: 100,
          title: const Column(children: [
            Text(
              "What are your interests.",
              style: TextStyle(color: Colors.white, fontSize: 26),
            ),
            SizedBox(height: 10),
            Text(
              'Pick 3 categories of your choice',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ]),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: blueColor,
                      ),
                    )
                  : provider.quotesCategories.isEmpty
                      ? const EmptyPlaceHiolder(message: 'Categories')
                      : SizedBox(
                          height: 400,
                          width: double.maxFinite,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: chipWidgets,
                          ),
                        ),
              const Spacer(),
              Container(
                color: darkscaffoldBackgroundColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomElevatedButton(
                        height: 38,
                        text: "Continue",
                        onTap: () => onTapContinue(context),
                      ),
                      const SizedBox(height: 18),
                      CustomElevatedButton(
                        height: 38,
                        buttonColor: Colors.transparent,
                        text: "Skip",
                        onTap: () => onTapSkip(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapSkip(BuildContext context) {
    Get.off(() => const Layout(), transition: Transition.rightToLeft);
  }

  void onTapContinue(BuildContext context) {
    Get.off(() => const Layout(), transition: Transition.rightToLeft);
  }
}
