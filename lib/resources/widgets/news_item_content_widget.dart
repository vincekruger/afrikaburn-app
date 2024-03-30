import 'package:afrikaburn/app/providers/firebase_provider.dart';
import 'package:afrikaburn/bootstrap/helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class NewsContent extends StatelessWidget {
  NewsContent(this.newsItemId, this.htmlContent, {Key? key}) : super(key: key);

  final String newsItemId;
  final String htmlContent;
  final staticAnchorKey = GlobalKey();

  /// Settings html content styles
  Map<String, Style> _setupStyles(BuildContext context) {
    Map<String, Style> styles = {
      "body": Style(padding: HtmlPaddings.zero, margin: Margins.zero),
      "p": Style(
        margin: Margins.only(top: 0, bottom: 12),
        fontSize: FontSize(Theme.of(context).textTheme.bodyMedium!.fontSize!),
        fontFamily: Theme.of(context).textTheme.bodyMedium!.fontFamily,
        fontWeight: Theme.of(context).textTheme.bodyMedium!.fontWeight,
        color: ThemeColor.get(context).primaryContent,
      ),
      "li": Style(
        margin: Margins.zero,
        padding: HtmlPaddings.zero,
        display: Display.listItem,
      ),
      "a": Style(
        color: ThemeColor.get(context).primaryAccent,
        textDecoration: TextDecoration.none,
      ),
      "h2, h3": Style(
        margin: Margins.only(top: 0, bottom: 8),
        padding: HtmlPaddings.zero,
        fontSize:
            FontSize(Theme.of(context).textTheme.headlineMedium!.fontSize!),
        fontFamily: Theme.of(context).textTheme.headlineMedium!.fontFamily,
        fontWeight: Theme.of(context).textTheme.headlineMedium!.fontWeight,
        color: ThemeColor.get(context).primaryContent,
      ),
    };

    return styles;
  }

  /// Configure custom tags
  /// Support: img - creating a newtwork cached image
  List<TagExtension> _extensions(BuildContext context) {
    return [
      TagExtension(
        tagsToExtend: {"img"},
        builder: (extensionContext) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              child: CachedNetworkImage(
                imageUrl: extensionContext.attributes['src']!,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          );
        },
      ),
    ];
  }

  /// Open links in external browser
  void _onLinkTap(url, Map<String, String> attributes) async {
    await launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication);
    FirebaseProvider().logEvent(
        'news_item_link_tap', {"news_item_id": newsItemId, "url": url});
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlContent,
      style: _setupStyles(context),
      extensions: _extensions(context),
      anchorKey: staticAnchorKey,
      onLinkTap: (url, attributes, _) => _onLinkTap(url, attributes),
      onCssParseError: (css, messages) {
        debugPrint("css that errored: $css");
        debugPrint("error messages:");
        for (var element in messages) {
          debugPrint(element.toString());
        }
        return '';
      },
    );
  }
}
