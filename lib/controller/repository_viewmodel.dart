import 'package:flutter/material.dart';
import 'package:trending_repositories/data/models/repository_model.dart';
import 'package:trending_repositories/data/services/api_constants.dart';
import 'package:trending_repositories/data/services/api_service.dart';
import 'package:trending_repositories/data/services/custom_response.dart';

class RepositoryViewmodel extends ChangeNotifier {
  final NetworkHelper _networkHelper = NetworkHelper.instance;

  bool _isLoading = false;
  String? _errorMessage;
  List<Repository>? _repos;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Repository>? get data => _repos;

  Future<void> getRepos({
    Map<String, dynamic>? queryParameters,
  }) async {
    CustomResponse customResponse;
    _errorMessage = null;

    notifyListeners();
    Map<String, dynamic> queryParams = {
      'sort': 'stars',
      'order': 'desc',
      'q': 'created:>2023-09-01',
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
    notifyListeners();
    return;
  }
}
