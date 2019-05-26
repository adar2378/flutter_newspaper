import 'package:newspaperapp/api/api_provider.dart';
import 'package:newspaperapp/model/catagory.dart';
import 'package:newspaperapp/model/news.dart';

class Repository {
  ApiProvider apiProvider = ApiProvider();

  Future<List<Article>> getAllHeadLines() => apiProvider.getAllHeadLines();

  Future<List<Article>> getCatagorizedHeadLines(Categories category) =>
      apiProvider.getCatagorizedHeadLines(category);
}
