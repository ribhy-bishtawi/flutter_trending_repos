/// Acknowledgment:
/// This file defines HTTP status codes and their descriptions based on general
/// web standards and GitHub API guidelines. The descriptions are derived from
/// publicly available documentation and best practices for API error handling.
///
/// References:
/// - GitHub API documentation: https://gist.github.com/subfuzion/669dfae1d1a27de83e69

class HttpStatusCode {
  static const int success = 200;
  static const int found = 302;
  static const int notModified = 304;

  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int notAcceptable = 406;
  static const int gone = 410;
  static const int tooManyRequests = 429;

  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
}

enum ErrorType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  notAcceptable,
  gone,
  tooManyRequests,
  internalServerError,
  badGateway,
  serviceUnavailable,
  gatewayTimeout,
  unknown
}

class ErrorHelper {
  static ErrorType getErrorType(int? statusCode) {
    switch (statusCode) {
      case HttpStatusCode.badRequest:
        return ErrorType.badRequest;
      case HttpStatusCode.unauthorized:
        return ErrorType.unauthorized;
      case HttpStatusCode.forbidden:
        return ErrorType.forbidden;

      case HttpStatusCode.notFound:
        return ErrorType.notFound;

      case HttpStatusCode.notAcceptable:
        return ErrorType.notAcceptable;

      case HttpStatusCode.gone:
        return ErrorType.gone;

      case HttpStatusCode.tooManyRequests:
        return ErrorType.tooManyRequests;

      case HttpStatusCode.internalServerError:
        return ErrorType.internalServerError;

      case HttpStatusCode.badGateway:
        return ErrorType.badGateway;

      case HttpStatusCode.serviceUnavailable:
        return ErrorType.serviceUnavailable;

      case HttpStatusCode.gatewayTimeout:
        return ErrorType.gatewayTimeout;

      default:
        return ErrorType.unknown;
    }
  }

  /// Returns a user-friendly error message based on the ErrorType
  static String getErrorMessage(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.badRequest:
        return "BAD REQUEST: The request was invalid or cannot be otherwise served.";
      case ErrorType.unauthorized:
        return "UNAUTHORIZED: Authentication credentials are missing, invalid, or not sufficient.";
      case ErrorType.forbidden:
        return "FORBIDDEN: The request has been refused. This could be due to exceeding rate limits or insufficient permissions.";
      case ErrorType.notFound:
        return "NOT FOUND: The URI requested is invalid or the resource requested does not exists.";
      case ErrorType.notAcceptable:
        return "NOT ACCEPTABLE: The request specified an invalid format";

      case ErrorType.gone:
        return "GONE: This resource has been removed, or the API endpoint is turned off.";

      case ErrorType.tooManyRequests:
        return "TOO MANY REQUESTS: Rate limit exceeded. Please try again later.";

      case ErrorType.internalServerError:
        return "INTERNAL SERVER ERROR: Something went wrong on the server.";
      case ErrorType.badGateway:
        return "BAD GATEWAY: The service is down or being upgraded.";
      case ErrorType.serviceUnavailable:
        return "SERVICE UNAVAILABLE: The service is currently overloaded or down for maintenance.";
      case ErrorType.gatewayTimeout:
        return "GATEWAY TIMEOUT: The request couldn’t be serviced due to internal server issues. Try again later.";
      case ErrorType.unknown:
        return "An unknown error occurred.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }
}
