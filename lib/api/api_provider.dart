import 'package:http/http.dart' as http;
import 'package:newspaperapp/model/catagory.dart';
import 'package:newspaperapp/model/news.dart';

//newsapi.org Api key ="1a7bf325a72544ce900372b2754f2b4e"

class ApiProvider {
  final String baseUrl = "newsapi.org";
  final String apiKey = "1a7bf325a72544ce900372b2754f2b4e";

  http.Client client = http.Client();

  Duration timeOutDuration = Duration(seconds: 10);

  Future<List<Article>> getAllHeadLines() async {
    List<Article> tempList = List<Article>();
    try {
      final response = await client
          .get(Uri.https(
              baseUrl, "/v2/top-headlines", {"country": "us", "apiKey": apiKey}))
          .timeout(timeOutDuration, onTimeout: () {
        client.close();
        throw ("Time out exception");
      });
      if (response.statusCode == 200) {
        News newsMain = newsFromJson(response.body);
        tempList = newsMain.articles;
      } else {
        throw ("failed to fetch data");
      }
    } catch (e) {
      throw (e);
    }
    return tempList;
  }

  Future<List<Article>> getCatagorizedHeadLines(Categories category) async {
    List<Article> tempList = List<Article>();
    try {
      final response = await client
          .get(Uri.https(
        baseUrl,
        "/v2/top-headlines",
        {
          "country": "us",
          "category": category.toString().split('.').last,
          "apiKey": apiKey
        },
      ))
          .timeout(timeOutDuration, onTimeout: () {
        client.close();
        throw ("Time out exception");
      });
      if (response.statusCode == 200) {
        News newsMain = newsFromJson(response.body);
        tempList = newsMain.articles;
      } else {
        throw ("failed to fetch data");
      }
    } catch (e) {
      throw (e);
    }
    return tempList;
  }
}
