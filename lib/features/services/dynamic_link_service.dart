import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future<Uri> generateDynamicLink() async {
    var shorLink = await FirebaseDynamicLinks.instance.buildShortLink(
        DynamicLinkParameters(link: Uri.parse('https://tripto.page.link'),
            uriPrefix: 'https://tripto.page.link',
            androidParameters: const AndroidParameters(packageName: 'com.example.tripto')));
    return shorLink.shortUrl;
  }
}