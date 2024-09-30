import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/data/services/api_constants.dart';
import 'package:trending_repositories/data/services/api_service.dart';
import 'package:trending_repositories/data/services/custom_response.dart';

enum TimeFilter { day, week, month }

class RepositoryViewmodel extends ChangeNotifier {
  final NetworkHelper _networkHelper = NetworkHelper.instance;

  bool _isLoading = false;
  String? _errorMessage;
  List<Repository>? _repos;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Repository>? get repos => _repos;

  Future<void> getRepos(
    TimeFilter filter,
  ) async {
    CustomResponse customResponse;
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
    };
    const String url = ApiConstants.baseUrl + ApiConstants.searchRepositories;

    try {
      customResponse =
          await _networkHelper.get(url: url, queryParameters: queryParams);
      _repos = (customResponse.data["items"] as List).map((repo) {
        return Repository.fromMap(repo);
      }).toList();
    } catch (e) {
      _errorMessage = e.toString();
      print("$errorMessage");
    }
    _isLoading = false;
    notifyListeners();
    return;
  }
}
