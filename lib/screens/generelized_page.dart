import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newspaperapp/api/repository.dart';
import 'package:newspaperapp/model/catagory.dart';
import 'package:newspaperapp/model/news.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:newspaperapp/screens/view_news.dart';

class GeneralizedPage extends StatefulWidget {
  final Categories category;
  GeneralizedPage({@required this.category});
  @override
  _GeneralizedPageState createState() => _GeneralizedPageState();
}

class _GeneralizedPageState extends State<GeneralizedPage>
    with AutomaticKeepAliveClientMixin {
  Future future;
  @override
  void initState() {
    future = Repository().getCatagorizedHeadLines(widget.category);
    super.initState();
  }

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Article>>(
      future: future,
      builder: (context, snapshotlist) {
        if (snapshotlist.hasData) {
          return EasyRefresh(
            onRefresh: () async {
              await new Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  future =
                      Repository().getCatagorizedHeadLines(widget.category);
                });
              });
            },
            refreshHeader: ClassicsHeader(
              key: _headerKey,
              bgColor: Colors.transparent,
              textColor: Colors.black87,
            ),
            child: ListView.builder(
              key: PageStorageKey(widget.category.index),
              shrinkWrap: true,
              itemCount: snapshotlist.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/view_news",
                        arguments: ViewNews(
                          newsUrl: snapshotlist.data[index].url,
                          title: snapshotlist.data[index].source.name ?? "",
                        ));
                  },
                  child: Card(
                    elevation: 5,
                    color: Color(0xFFFAFAFA),
                    margin: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8)),
                          child: CachedNetworkImage(
                            imageUrl: snapshotlist.data[index].urlToImage ??
                                "https://dummyimage.com/300x200/000/fff",
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                            placeholder: (context, url) =>
                                Center(child: Text("Loading...")),
                            errorWidget: (context, url, error) =>
                                new Center(child: Icon(Icons.error)),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.category.toString().split('.').last,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(width: 16),
                              Text(
                                snapshotlist.data[index].author ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: Theme.of(context).textTheme.overline,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshotlist.data[index].title,
                            maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.headline,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                snapshotlist.data[index].source.name,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.overline,
                              ),
                              Text(
                                (DateFormat.MMMMEEEEd().format(snapshotlist
                                        .data[index].publishedAt
                                        .toLocal()) +
                                    " " +
                                    DateFormat.jm().format(snapshotlist
                                        .data[index].publishedAt
                                        .toLocal())),
                                maxLines: 2,
                                style: Theme.of(context).textTheme.overline,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Loading..."),
          ));
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    updateKeepAlive();
    super.didChangeDependencies();
  }

  @override
  bool get wantKeepAlive => true;
}
