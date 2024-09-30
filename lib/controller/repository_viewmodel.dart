import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/data/services/api_constants.dart';
import 'package:trending_repositories/data/services/api_service.dart';
import 'package:trending_repositories/data/services/custom_response.dart';

enum TimeFilter { day, week, month }

class RepositoryViewmodel extends ChangeNotifier {
  final NetworkHelper _networkHelper = NetworkHelper.instance;

  bool _isLoading = false;
  String? _errorMessage;
  List<Repository> _repos = [];
  List<Repository> _favoriteRepos = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Repository> get repos => _repos;
  List<Repository> get favoriteRepos => _favoriteRepos;

  int currentPage = 1;
  RepositoryViewmodel() {
    loadFavorites();
  }
  Future<void> getRepos(TimeFilter filter) async {
    _isLoading = true;
    _repos = [];
    notifyListeners();

    _repos = await fetchRepos(page: 1, filter: filter);
    currentPage = 1;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreRepos() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();
    List<Repository> moreRepos =
        await fetchRepos(page: currentPage + 1, filter: TimeFilter.day);
    if (moreRepos.isNotEmpty) {
      repos.addAll(moreRepos);
      currentPage++;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<List<Repository>> fetchRepos(
      {required int page, required TimeFilter filter}) async {
    CustomResponse customResponse;
    List<Repository> _tempRepos = [];
    _errorMessage = null;
    _isLoading = true;
    DateTime now = DateTime.now();
    notifyListeners();

    String createdSince;
    switch (filter) {
      case TimeFilter.day:
        createdSince = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 1)));
        break;
      case TimeFilter.week:
        createdSince = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 7)));
        break;
      case TimeFilter.month:
        createdSince = DateFormat('yyyy-MM-dd')
            .format(now.subtract(const Duration(days: 30)));
        break;
    }

    Map<String, dynamic> queryParams = {
      'sort': 'stars',
      'order': 'desc',
      'q': 'created:>$createdSince',
      'page': page
    };
    const String url = ApiConstants.baseUrl + ApiConstants.searchRepositories;

    try {
      customResponse =
          await _networkHelper.get(url: url, queryParameters: queryParams);
      _tempRepos = (customResponse.data["items"] as List).map((repo) {
        return Repository.fromMap(repo);
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
      print("$errorMessage");
    }
    _isLoading = false;
    notifyListeners();
    return _tempRepos;
  }

  // Add repository to favorites and save to local storage
  Future<void> addToFavorites(Repository repo) async {
    if (!favoriteRepos.contains(repo)) {
      favoriteRepos.add(repo);
      await saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(Repository repo) async {
    favoriteRepos.remove(repo);
    await saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteRepoJsonList =
        favoriteRepos.map((repo) => jsonEncode(repo.toMap())).toList();
    await prefs.setStringList('favoriteRepos', favoriteRepoJsonList);
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteRepoJsonList = prefs.getStringList('favoriteRepos');
    if (favoriteRepoJsonList != null) {
      _favoriteRepos = favoriteRepoJsonList
          .map((repoJson) => Repository.fromMap(jsonDecode(repoJson)))
          .toList();
    }
    notifyListeners();
  }

  bool isFavorite(Repository repo) {
    return favoriteRepos.contains(repo);
  }
}
