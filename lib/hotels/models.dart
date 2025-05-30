// models.dart
class GuestDetails {
  final String title;
  final String firstName;
  final String lastName;
  final String email;
  final String countryCode;
  final String phoneNumber;
  final double totalPrice;

  const GuestDetails({
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.countryCode,
    required this.phoneNumber,
    required this.totalPrice,
  });
}
