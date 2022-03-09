class CurrentUserException implements Exception {
  final String message;

  const CurrentUserException(this.message);

  String toString() => '$message';
}
