class BookingException implements Exception {
  final String message;

  const BookingException(this.message);

  @override
  String toString() => message;
}
