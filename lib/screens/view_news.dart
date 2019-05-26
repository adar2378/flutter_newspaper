import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewNews extends StatefulWidget {
  final String newsUrl;
  final String title;

  ViewNews({this.newsUrl, this.title});
  @override
  _ViewNewsState createState() => _ViewNewsState();
}

class _ViewNewsState extends State<ViewNews> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool offstageValue;

  @override
  void initState() {
    offstageValue = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("news url: " + widget.newsUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
          overflow: TextOverflow.clip,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[SampleMenu(_controller.future)],
      ),
      body: Column(
        children: <Widget>[
          Offstage(
            child: LinearProgressIndicator(),
            offstage: offstageValue,
          ),
          Expanded(
            child: WebView(
              initialUrl: widget.newsUrl,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              navigationDelegate: (NavigationRequest request) {
                return NavigationDecision.prevent;
              },
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (value) {
                setState(() {
                  offstageValue = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum MenuOptions {
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
}

class SampleMenu extends StatelessWidget {
  SampleMenu(this.controller);

  final Future<WebViewController> controller;
  final CookieManager cookieManager = CookieManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.listCookies:
                _onListCookies(controller.data, context);
                break;
              case MenuOptions.clearCookies:
                _onClearCookies(context);
                break;
              case MenuOptions.addToCache:
                _onAddToCache(controller.data, context);
                break;
              case MenuOptions.listCache:
                _onListCache(controller.data, context);
                break;
              case MenuOptions.clearCache:
                _onClearCache(controller.data, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.listCookies,
                  child: Text('List cookies'),
                ),
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.clearCookies,
                  child: Text('Clear cookies'),
                ),
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.addToCache,
                  child: Text('Add to cache'),
                ),
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.listCache,
                  child: Text('List cache'),
                ),
                const PopupMenuItem<MenuOptions>(
                  value: MenuOptions.clearCache,
                  child: Text('Clear cache'),
                ),
              ],
        );
      },
    );
  }

  void _onListCookies(
      WebViewController controller, BuildContext context) async {
    final String cookies =
        await controller.evaluateJavascript('document.cookie');
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Cookies:'),
          _getCookieList(cookies),
        ],
      ),
    ));
  }

  void _onAddToCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript(
        'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";');
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text('Added a test entry to cache.'),
    ));
  }

  void _onListCache(WebViewController controller, BuildContext context) async {
    await controller.evaluateJavascript('caches.keys()'
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  void _onClearCache(WebViewController controller, BuildContext context) async {
    await controller.clearCache();
    Scaffold.of(context).showSnackBar(const SnackBar(
      content: Text("Cache cleared."),
    ));
  }

  void _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  Widget _getCookieList(String cookies) {
    if (cookies == null || cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
        cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }
}
