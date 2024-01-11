import 'package:flutter_hud/flutter_hud.dart';
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
    final provider = Provider.of<PodcastProvider>(context, listen: false);
    await provider.fetchCategories();
  }

  _submit() async {
    if (selectedChipIndex.length < 3) {
      Fluttertoast.showToast(msg: 'Please select 3 categories');
    } else {
      setState(() {
        loading = true;
      });
      await UserServices()
          .updateUser('', '', selectedChipIndex)
          .whenComplete(() {
        setState(() {
          loading = true;
        });
        Get.off(const Layout(), transition: Transition.circularReveal);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodcastProvider>(context);
    List<Widget> chipWidgets =
        provider.podcastCategories.asMap().entries.map((entry) {
      final index = entry.value.id;
      final category = entry.value;

      return SizedBox(
        height: 0.2.sh,
        width: 0.4.sw,
        child: InkWell(
          onTap: () {
            setState(() {
              if (selectedChipIndex.contains(index)) {
                selectedChipIndex.remove(index);
              } else {
                if (selectedChipIndex.length < 3) {
                  selectedChipIndex.add(index);
                } else {
                  Fluttertoast.showToast(msg: 'Max 3 categories are allowed');
                }
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(category.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  height: 0.2.sh,
                  width: 0.4.sw,
                  decoration: BoxDecoration(
                    color: !selectedChipIndex.contains(index)
                        ? darkscaffoldBackgroundColor.withOpacity(0.8)
                        : Colors.transparent,
                  ),
                ),
                Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();

    return SafeArea(
      child: WidgetHUD(
        showHUD: loading,
        hud: HUD(
            progressIndicator: Image.asset(
          liveGif,
          color: blueColor,
          scale: 3,
        )),
        builder: (context, child) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: darkscaffoldBackgroundColor,
            toolbarHeight: 120,
            title: Column(children: [
              Text(
                "Choose Your Interests",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 29.sp,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Pick 3 categories that you want to listen',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp),
              ),
            ]),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                provider.podcastCategories.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: blueColor,
                        ),
                      )
                    : provider.podcastCategories.isEmpty
                        ? const EmptyPlaceHolder(message: 'Categories')
                        : Wrap(
                            spacing: 10,
                            runSpacing: 20,
                            children: chipWidgets,
                          ),
                CustomElevatedButton(
                  height: 50,
                  text: "Next",
                  buttonColor: blueColor,
                  buttonTextStyle: TextStyle(
                      fontSize:18.sp,
                      color: Colors.white),
                  onTap: () => _submit(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
