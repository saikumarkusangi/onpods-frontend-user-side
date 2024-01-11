import 'package:onpods/utils/exports.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<double> appBarOpacity = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    final podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    podcastProvider.fetchSuggestPodcasts();
    podcastProvider.fetchTrendingPodcasts();

    _scrollController.addListener(_updateAppBarOpacity);
  }

  void _updateAppBarOpacity() {
    double newOpacity = (_scrollController.offset / 200).clamp(0.0, 1.0);
    appBarOpacity.value = newOpacity;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateAppBarOpacity);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(appBarOpacity: appBarOpacity),
      bottomNavigationBar: const MiniPlayer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const BannerCarsouel(),
              // const ContinueListening(),
              const PodcastCardTemplate(categoryTitle: 'Trending Podcast'),
              // const PodcastCardTemplate(categoryTitle: 'Recommended For You'),
            ]),
          ),
        ],
      ),
    );
  }
}
