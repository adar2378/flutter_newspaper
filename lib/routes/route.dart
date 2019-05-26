import 'package:flutter/material.dart';
import 'package:newspaperapp/screens/home_page.dart';
import 'package:newspaperapp/screens/view_news.dart';

class MyRoutes {
  Route getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/single_news':
        return _buildRoute(settings, HomePage());
      case '/view_news':
        final ViewNews args = settings.arguments;
        return _buildRoute(
            settings, ViewNews(newsUrl: args.newsUrl, title: args.title));
      // case '/category_headlines':
      //   return _buildRoute(settings, CourseDetail(course: settings.arguments));

      default:
        return _buildRoute(settings, HomePage());
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      maintainState: true,
      builder: (BuildContext context) => builder,
    );
  }
}
