import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:trending_repositories/data/services/custom_response.dart';
import 'package:trending_repositories/data/services/status_code.dart';

class NetworkHelper {
  bool debugging = true;
  Map<String, String> headers = HashMap();

  static final NetworkHelper _instance = NetworkHelper._privateConstructor();
  static NetworkHelper get instance => _instance;

  late Dio _dio;

  var baseOptions = BaseOptions(
    receiveDataWhenStatusError: true,
    receiveTimeout: const Duration(milliseconds: 60000),
    connectTimeout: const Duration(milliseconds: 60000),
    sendTimeout: const Duration(milliseconds: 5000),
    followRedirects: false,
    validateStatus: (status) {
      return status != null ? status < 500 : true;
    },
  );

  NetworkHelper._privateConstructor() {
    _initDio();
  }

  void _initDio() async {
    _dio = Dio(baseOptions);
    if (debugging) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: false,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  void _setJsonHeader() {
    headers.putIfAbsent('Accept', () => 'application/json');
    headers.putIfAbsent('Authorization', () => 'Bearer ');
  }

  /// Handles GET requests and returns a [CustomResponse].
  Future<CustomResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    Response response;
    var data;
    String? errorMessage;

    try {
      _setJsonHeader();
      response = await _dio.get(url,
          queryParameters: queryParameters, options: Options(headers: headers));

      ErrorType errorType = ErrorHelper.getErrorType(response.statusCode);

      if (response.statusCode == HttpStatusCode.success) {
        data = response.data;
      } else {
        errorMessage = ErrorHelper.getErrorMessage(errorType);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.badResponse) {
        ErrorType errorType = ErrorHelper.getErrorType(e.response?.statusCode);
        errorMessage = ErrorHelper.getErrorMessage(errorType);
      } else {
        errorMessage = 'Network error occurred.';
      }
      return CustomResponse(
        statusCode: e.response?.statusCode,
        errorMessage: errorMessage,
      );
    } catch (error) {
      errorMessage = 'An unexpected error occurred.';
      return CustomResponse(
        statusCode: HttpStatusCode.internalServerError,
        errorMessage: errorMessage,
      );
    }

    return CustomResponse(
      data: data,
      statusCode: response.statusCode,
      errorMessage: errorMessage,
    );
  }
}
