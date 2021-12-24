class AppError {
  String message;
  AppErrorType errorType;

  AppError({
    required this.message,
    required this.errorType,
  });
}

enum AppErrorType {
  API_ERROR,
  NETWORK_ERROR,
}
