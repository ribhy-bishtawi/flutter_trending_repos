import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/data/services/api_constants.dart';
import 'package:trending_repositories/data/services/api_service.dart';
import 'package:trending_repositories/data/services/custom_response.dart';
import 'package:trending_repositories/data/services/status_code.dart';

enum TimeFilter { day, week, month }

class RepositoryViewmodel extends ChangeNotifier {
  final NetworkHelper _networkHelper = NetworkHelper.instance;

  bool _isLoading = false;
  String? _errorMessage;
  List<Repository> _repos = [];
  List<Repository> _favoriteRepos = [];
  List<Repository> _filteredRepos = [];
  List<Repository> _filteredFavoriteRepos = []; // Filtered favorite repos

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Repository> get repos => _repos;
  List<Repository> get favoriteRepos => _favoriteRepos;
  List<Repository> get filteredRepos => _filteredRepos;
  List<Repository> get filteredFavoriteRepos => _filteredFavoriteRepos;

  int currentPage = 1;
  RepositoryViewmodel() {
    loadFavorites();
  }
  Future<void> getRepos(TimeFilter filter) async {
    _isLoading = true;
    _filteredRepos = [];
    notifyListeners();

    List<Repository> newRepos = await fetchRepos(page: 1, filter: filter);
    currentPage = 1;
    _repos = newRepos;

    _filteredRepos = _repos;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreRepos(TimeFilter filter) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();
    List<Repository> moreRepos =
        await fetchRepos(page: currentPage + 1, filter: filter);
    if (moreRepos.isNotEmpty) {
      repos.addAll(moreRepos);
      currentPage++;
    }
    _filteredRepos = repos;
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
      'page': page,
    };
    const String url = ApiConstants.baseUrl + ApiConstants.searchRepositories;

    customResponse =
        await _networkHelper.get(url: url, queryParameters: queryParams);
    if (customResponse.statusCode == HttpStatusCode.success) {
      _tempRepos = (customResponse.data["items"] as List).map((repo) {
        return Repository.fromMap(repo);
      }).toList();
    } else {
      _errorMessage = customResponse.errorMessage;
    }
    _isLoading = false;
    notifyListeners();
    return _tempRepos;
  }

  Future<void> addToFavorites(Repository repo) async {
    if (!favoriteRepos.contains(repo)) {
      favoriteRepos.add(repo);
      _filteredFavoriteRepos = _favoriteRepos;

      await saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(Repository repo) async {
    favoriteRepos.remove(repo);
    _filteredFavoriteRepos = _favoriteRepos;

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
      _filteredFavoriteRepos = _favoriteRepos;
    }
    notifyListeners();
  }

  void searchRepos(String query) {
    if (query.isEmpty) {
      _filteredRepos = repos;
    } else {
      _filteredRepos = repos
          .where(
              (repo) => repo.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void searchFavoriteRepos(String query) {
    if (query.isEmpty) {
      _filteredFavoriteRepos = _favoriteRepos;
    } else {
      _filteredFavoriteRepos = _favoriteRepos
          .where(
              (repo) => repo.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify the UI to update
  }

  bool isFavorite(Repository repo) {
    return favoriteRepos.contains(repo);
  }
}
