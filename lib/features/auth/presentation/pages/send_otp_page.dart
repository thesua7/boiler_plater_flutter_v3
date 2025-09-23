import 'package:flutter/material.dart';
import '../widgets/send_otp_form.dart';

/// Send OTP Page
class SendOtpPage extends StatelessWidget {
  const SendOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Send OTP'),
        centerTitle: true,
        elevation: 0,
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: SendOtpForm(),
        ),
      ),
    );
  }
}