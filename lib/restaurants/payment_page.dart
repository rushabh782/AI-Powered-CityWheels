// restaurants/payment_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:city_wheels/restaurants/booking_confirmation_page.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final double coverCharge;
  final String restaurantId;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final int guests;
  final String selectedMealType;

  const PaymentPage({
    super.key,
    required this.coverCharge,
    required this.restaurantId,
    required this.selectedDate,
    required this.selectedTime,
    required this.guests,
    required this.selectedMealType,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Charge Summary
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cover Charge: ₹${widget.coverCharge.toStringAsFixed(0)}',
                      ),
                      Text('Guests: ${widget.guests}'),
                      Text(
                        'Date: ${DateFormat('EEE, MMM d').format(widget.selectedDate)}',
                      ),
                      Text('Time: ${widget.selectedTime.format(context)}'),
                      Text('Meal Type: ${widget.selectedMealType}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Card Number
              const Text(
                'CARD NUMBER',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  CardNumberFormatter(),
                ],
                decoration: const InputDecoration(
                  hintText: '1234 5678 9012 3456',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.replaceAll(' ', '').length != 16) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Card Holder Name
              const Text(
                'CARD HOLDER NAME',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              TextFormField(
                controller: _cardNameController,
                decoration: const InputDecoration(hintText: 'John Doe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expiry Date and CVV
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'EXPIRY DATE',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        TextFormField(
                          controller: _expiryDateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardExpiryFormatter(),
                          ],
                          decoration: const InputDecoration(hintText: 'MM/YY'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter expiry date';
                            }
                            if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                              return 'Invalid format (MM/YY)';
                            }

                            // Add expiry date validation
                            final parts = value.split('/');
                            if (parts.length != 2) return 'Invalid format';

                            final month = int.tryParse(parts[0]);
                            final year = int.tryParse(parts[1]);

                            if (month == null || year == null) {
                              return 'Invalid date';
                            }
                            if (month < 1 || month > 12) return 'Invalid month';

                            final now = DateTime.now();
                            final currentYear = now.year % 100;
                            final currentMonth = now.month;

                            // Check if year is in the past or month is in the past for current year
                            if (year < currentYear ||
                                (year == currentYear && month < currentMonth)) {
                              return 'Card has expired';
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CVV',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        // CVV TextFormField (updated with obscure text)
                        TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true, // This hides the CVV input
                          obscuringCharacter:
                              '•', // Optional: Custom character for hiding
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: const InputDecoration(hintText: '•••'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter CVV';
                            }
                            if (value.length != 3) {
                              return 'CVV must be 3 digits';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Pay Now Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'PAY NOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //   void _processPayment() {
  //     if (_formKey.currentState!.validate()) {
  //       // Process payment logic here
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => BookingConfirmationPage(
  //             restaurantId: widget.restaurantId,
  //             date: widget.selectedDate,
  //             time: widget.selectedTime,
  //             guests: widget.guests,
  //             mealType: widget.selectedMealType,
  //             coverCharge: widget.coverCharge,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  // }
  // In PaymentPage's _processPayment method:
  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // Process payment logic here
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => BookingConfirmationPage(
                restaurantId: widget.restaurantId,
                date: widget.selectedDate,
                time: widget.selectedTime,
                guests: widget.guests,
                mealType: widget.selectedMealType,
                coverCharge: widget.coverCharge,
              ),
        ),
      ).then((_) {
        // Return true to indicate payment success
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      });
    }
  }
}

// Formatter for card number (adds spaces every 4 digits)
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) text = text.substring(0, 16);

    var formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) formatted += ' ';
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formatter for expiry date (adds / after 2 digits)
class CardExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);

    var formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2) formatted += '/';
      formatted += text[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
