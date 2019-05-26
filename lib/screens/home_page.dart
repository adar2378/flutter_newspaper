import 'package:flutter/material.dart';
import 'package:newspaperapp/api/repository.dart';
import 'package:newspaperapp/model/catagory.dart';
import 'package:newspaperapp/model/news.dart';
import 'package:newspaperapp/screens/generelized_page.dart';
import 'package:newspaperapp/widgets/collapsable_appbar.dart';
import 'package:newspaperapp/widgets/customized_indicator.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController tabController;
  Future future;
  @override
  void initState() {
    tabController = TabController(length: 7, vsync: this);
    future = Repository().getAllHeadLines();
    super.initState();
  }

  String getDay(int day) {
    final List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    return days[day - 1];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            CollapsableAppBar(
                appBarHeight: 150,
                appBarChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: RichText(
                          text: TextSpan(
                              text: getDay(DateTime.now().toLocal().weekday) +
                                  ", ",
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w300,
                                color: Colors.white70,
                              ),
                              children: [
                                TextSpan(
                                    text: DateFormat.jm()
                                        .format(DateTime.now().toLocal())
                                        .toString(),
                                    style: TextStyle(fontSize: 16)),
                              ]),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TabBar(
                        indicator: CustomTabIndicator(),
                        labelColor: Color(0xFFD71556),
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        indicatorSize: TabBarIndicatorSize.tab,
                        isScrollable: true,
                        unselectedLabelColor: Colors.white,
                        unselectedLabelStyle:
                            TextStyle(fontWeight: FontWeight.w400),
                        controller: tabController,
                        tabs: <Widget>[
                          Container(
                            child: Tab(
                              text: "General",
                            ),
                          ),
                          Tab(
                            text: "Business",
                          ),
                          Tab(
                            text: "Entertainment",
                          ),
                          Tab(
                            text: "Health",
                          ),
                          Tab(
                            text: "Science",
                          ),
                          Tab(
                            text: "Sports",
                          ),
                          Tab(
                            text: "Technology",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                child: TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    FutureBuilder<List<Article>>(
                      future: future,
                      builder: (context, snapshotlist) {
                        if (snapshotlist.hasData) {
                          return ListView.builder(
                            key: PageStorageKey("allheadlines"),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8)),
                                        child: CachedNetworkImage(
                                          imageUrl: snapshotlist
                                                  .data[index].urlToImage ??
                                              "https://dummyimage.com/300x200/000/fff",
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                          placeholder: (context, url) =>
                                              Center(child: Text("Loading...")),
                                          errorWidget: (context, url, error) =>
                                              new Center(
                                                  child: Icon(Icons.error)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Headline",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              snapshotlist.data[index].author ??
                                                  "",
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline,
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              snapshotlist
                                                  .data[index].source.name,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline,
                                            ),
                                            Text(
                                              (DateFormat.MMMMEEEEd().format(
                                                      snapshotlist.data[index]
                                                          .publishedAt
                                                          .toLocal()) +
                                                  " " +
                                                  DateFormat.jm().format(
                                                      snapshotlist.data[index]
                                                          .publishedAt
                                                          .toLocal())),
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .overline,
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
                          return Text("Loading...");
                        }
                      },
                    ),
                    GeneralizedPage(
                      category: Categories.business,
                    ),
                    GeneralizedPage(
                      category: Categories.entertainment,
                    ),
                    GeneralizedPage(
                      category: Categories.health,
                    ),
                    GeneralizedPage(
                      category: Categories.science,
                    ),
                    GeneralizedPage(
                      category: Categories.sports,
                    ),
                    GeneralizedPage(
                      category: Categories.technology,
                    ),
                  ],
                )),
          ],
        ),
      ),
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
