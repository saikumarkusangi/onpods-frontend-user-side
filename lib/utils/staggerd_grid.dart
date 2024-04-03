import 'package:onpods/utils/exports.dart';

class StaggeredGridTemplate extends StatefulWidget {
  final String categoryId;
  const StaggeredGridTemplate({Key? key, required this.categoryId})
      : super(key: key);

  @override
  State<StaggeredGridTemplate> createState() => _StaggeredGridTemplateState();
}

class _StaggeredGridTemplateState extends State<StaggeredGridTemplate> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _initializeScrollController();
    _fetchQuotes();
  }

  void _initializeScrollController() {
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final provider = Provider.of<QuoteProvider>(context, listen: false);
        final i = provider.quotes.indexWhere(
          (element) =>
              element.datas.any((e) => e.category == widget.categoryId),
        );

        try {
          if (provider.quotes[i].totalPages > provider.quotes[i].page) {
            setState(() {
              _isLoadingMore = true;
            });
            print(
                '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ current page :${provider.quotes[i].page}');
            print(
                '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ total page :${provider.quotes[i].totalPages}');
            await provider.fetchQuotesByCategory(
                widget.categoryId, provider.quotes[i].page + 1);
          }
        } catch (e) {
          throw Exception(e);
        } finally {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    });
  }

  Future<void> _fetchQuotes() async {
    final provider = Provider.of<QuoteProvider>(context, listen: false);
    final i = provider.quotes.indexWhere(
        (element) => element.datas.any((e) => e.category == widget.categoryId));
    if (provider.quotes.isEmpty || i == -1) {
      await provider.fetchQuotesByCategory(widget.categoryId, 1);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<Color> placeholderColors = [
    Colors.red.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.yellow.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
  ];
  Color getRandomColor() {
    final random = Random();
    return placeholderColors[random.nextInt(placeholderColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuoteProvider>(context, listen: true);
    final i = provider.quotes.indexWhere(
        (element) => element.datas.any((e) => e.category == widget.categoryId));
    final count = i > -1 ? provider.quotes[i].datas.length : 0;

    return provider.isLoading
        ? const CustomScrollView(
            slivers: [SliverToBoxAdapter(child: QuotesSkeleton())])
        : count == 0
            ? const Center(child: EmptyPlaceHolder(message: 'Quotes'))
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: CustomScrollView(
                  shrinkWrap: true,
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14.0,
                        crossAxisSpacing: 10.0,
                        children: List.generate(count, (index) {
                          final quoteCategoryIndex = provider.quotes.indexWhere(
                              (element) => element.datas
                                  .any((e) => e.category == widget.categoryId));
                          final quote =
                              provider.quotes[quoteCategoryIndex].datas[index];

                         
                        

                          return GestureDetector(
                            onTap: () => Get.to(
                                SingleQuote(
                                    postId: quote.id,
                                    image: quote.imageUrl,
                                    userId: quote.userId,
                                  ),
                                transition: Transition.cupertino),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: quote.imageUrl,
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: getRandomColor(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    width: 0.5.sw,
                                    height: 0.3.sh,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(imagePlaceHolder),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    _isLoadingMore
                        ? const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: blueColor,
                                ),
                              ),
                            ),
                          )
                        : const SliverToBoxAdapter(child: SizedBox())
                  ],
                ),
              );
  }
}
