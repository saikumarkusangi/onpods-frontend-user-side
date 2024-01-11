import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:onpods/utils/exports.dart';

class DynamicLinkProvider {
  Future<String> createLink(String refcode) async {
    final String url = "https://com.example.onpods?ref=$refcode";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        androidParameters: const AndroidParameters(
            packageName: "com.example.onpods", minimumVersion: 0),
        link: Uri.parse(url),
        uriPrefix: 'https://onpods.page.link');

    final FirebaseDynamicLinks links =  FirebaseDynamicLinks.instance;

    final refLink = await links.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  void initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null) {
      final Uri refLink = instanceLink.link;

      Share.share('this is the link ${refLink.queryParameters["ref"]}');
    }
  }
}
