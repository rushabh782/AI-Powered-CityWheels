// payment_details_page.dart
import 'package:flutter/material.dart';
import 'package:city_wheels/hotels/models.dart';

class PaymentDetailsPage extends StatefulWidget {
  final GuestDetails guestDetails;
  final String bookingId;
  final dynamic bookingData;

  // ignore: use_super_parameters
  const PaymentDetailsPage({
    Key? key,
    required this.guestDetails,
    required this.bookingId,
    required this.bookingData,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate payment processing
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Navigate to confirmation page
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => BookingConfirmationPage(
                  bookingId: widget.bookingId,
                  guestDetails: widget.guestDetails,
                ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Debug print to verify received data
    debugPrint('Received guestDetails: ${widget.guestDetails}');
    debugPrint('Received bookingData: ${widget.bookingData}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Summary
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking Summary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Guest Name:'),
                          Text(
                            '${widget.guestDetails.title} ${widget.guestDetails.firstName} ${widget.guestDetails.lastName}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text('Amount to Pay:'),
                      //     Text(
                      //       '₹5,999',
                      //       style: const TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // ),

                      // Modify the Amount to Pay section in the build method
                      // Inside the Row where Amount to Pay is displayed:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Amount to Pay:'),
                          Text(
                            '₹${widget.guestDetails.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Card Number
              const Text(
                'CARD NUMBER',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                maxLength: 19,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  // Remove spaces for validation
                  String cleanNumber = value.replaceAll(RegExp(r'\s+'), '');
                  if (cleanNumber.length < 16 || cleanNumber.length > 16) {
                    return 'Card number must be 16 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
                    return 'Card number must contain only digits';
                  }
                  return null;
                },
                // Format card number with spaces for readability
                onChanged: (value) {
                  // Remove any non-digit characters
                  String newValue = value.replaceAll(RegExp(r'[^\d]'), '');

                  // Format with spaces after every 4 digits
                  if (newValue.isNotEmpty) {
                    newValue = newValue.replaceAllMapped(
                      RegExp(r'(.{4})(?=.)'),
                      (match) => '${match.group(0)} ',
                    );
                  }

                  // Only update if formatting changed the value
                  if (newValue != value) {
                    _cardNumberController.value = TextEditingValue(
                      text: newValue,
                      selection: TextSelection.collapsed(
                        offset: newValue.length,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Card Holder Name
              const Text(
                'CARD HOLDER NAME',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _cardHolderController,
                decoration: InputDecoration(
                  hintText: 'John Doe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
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
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _expiryDateController,
                          decoration: InputDecoration(
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLength: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }

                            // Check for MM/YY format
                            if (!RegExp(
                              r'^(0[1-9]|1[0-2])\/[0-9]{2}$',
                            ).hasMatch(value)) {
                              return 'Use MM/YY format';
                            }

                            // Check if card is not expired
                            final parts = value.split('/');
                            final month = int.parse(parts[0]);
                            final year = int.parse('20${parts[1]}');

                            final now = DateTime.now();
                            final cardDate = DateTime(
                              year,
                              month + 1,
                              0,
                            ); // Last day of expiry month

                            if (cardDate.isBefore(now)) {
                              return 'Card expired';
                            }

                            return null;
                          },
                          onChanged: (value) {
                            // Automatically add / after month
                            if (value.length == 2 && !value.contains('/')) {
                              _expiryDateController.text = '$value/';
                              _expiryDateController
                                  .selection = TextSelection.fromPosition(
                                TextPosition(
                                  offset: _expiryDateController.text.length,
                                ),
                              );
                            }
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
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _cvvController,
                          decoration: InputDecoration(
                            hintText: '123',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          maxLength: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length != 3) {
                              return 'Must be 3 digits';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Numbers only';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Payment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Text(
                            'PAY NOW',
                            style: TextStyle(color: Colors.white),
                          ),
                ),
              ),

              const SizedBox(height: 16),

              // Secure Payment Note
              const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      'Secure Payment',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Booking confirmation page
class BookingConfirmationPage extends StatelessWidget {
  final String bookingId;
  final GuestDetails guestDetails;

  // ignore: use_super_parameters
  const BookingConfirmationPage({
    Key? key,
    required this.bookingId,
    required this.guestDetails,
  }) : super(key: key);

  // At the top of the build method, you can add this check:
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Booking ID: $bookingId',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Guest:'),
                        Text(
                          '${guestDetails.title} ${guestDetails.firstName} ${guestDetails.lastName}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Email:'),
                        Text(guestDetails.email),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Phone:'),
                        Text(
                          '${guestDetails.countryCode} ${guestDetails.phoneNumber}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount Paid:'),
                        Text(
                          '₹${guestDetails.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'A confirmation email has been sent to:',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              guestDetails.email,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate back to home or main screen
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 24,
                ),
              ),
              child: const Text(
                'Return to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
