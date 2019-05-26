import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newspaperapp/api/repository.dart';
import 'package:newspaperapp/model/catagory.dart';
import 'package:newspaperapp/model/news.dart';

class GeneralizedPage extends StatefulWidget {
  final Categories category;
  GeneralizedPage({this.category});
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Article>>(
      future: future,
      builder: (context, snapshotlist) {
        if (snapshotlist.hasData) {
          return ListView.builder(
            key: PageStorageKey(widget.category.index),
            shrinkWrap: true,
            itemCount: snapshotlist.data.length,
            itemBuilder: (context, index) {
//                          print(snapshotlist.data[index].urlToImage);
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/view_news",
                      arguments: snapshotlist.data[index].url);
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
                              "Headline",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              snapshotlist.data[index].author ?? "",
                              maxLines: 2,
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
          );
        } else {
          return Center(child: Padding(
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
