import 'package:news_app/models/categoryNewsModel.dart';
import 'package:news_app/models/newsChannelHeadlinesModel.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _repo = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    final response = await _repo.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _repo.fetchCategoriesNewsApi(category);
    return response;
  }
}
