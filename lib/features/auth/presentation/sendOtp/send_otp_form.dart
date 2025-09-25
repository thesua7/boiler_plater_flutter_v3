import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/route/route_constant.dart';
import '../../../../l10n/app_localizations.dart';

import 'bloc/send_otp_bloc.dart';
import 'bloc/send_otp_event.dart';
import 'bloc/send_otp_state.dart';

/// Send OTP Form Widget
class SendOtpForm extends StatefulWidget {
  const SendOtpForm({super.key});

  @override
  State<SendOtpForm> createState() => _SendOtpFormState();
}

class _SendOtpFormState extends State<SendOtpForm> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<SendOtpBloc, SendOtpState>(
      listener: (context, state) {
        if (state is SendOtpSuccess) {
          _showSuccessDialog(context, state.message);
        } else if (state is SendOtpError) {
          _showErrorSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is SendOtpLoading;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.h),

              // Header
              Text(
                l10n.enterPhoneNumber,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 8.h),

              Text(
                l10n.sendVerificationCode,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.color?.withOpacity(0.7),
                  fontSize: 16.sp,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 48.h),

              // Phone Number Input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                enabled: !isLoading,
                style: TextStyle(fontSize: 16.sp),
                decoration: InputDecoration(
                  labelText: l10n.phoneNumber,
                  hintText: l10n.phoneNumberHint,
                  prefixIcon: Icon(Icons.phone, size: 20.sp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterPhoneNumber;
                  }
                  if (value.length < 10) {
                    return l10n.pleaseEnterValidPhoneNumber;
                  }
                  return null;
                },
              ),

              SizedBox(height: 32.h),

              // Send OTP Button
              ElevatedButton(
                onPressed: isLoading ? null : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                  minimumSize: Size(double.infinity, 48.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        l10n.sendOtp,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),

              SizedBox(height: 24.h),

              // Reset Button
              TextButton(
                onPressed: isLoading ? null : _resetForm,
                child: Text(
                  l10n.reset,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),

              const Spacer(),

              // Footer
              Text(
                l10n.termsAndPrivacy,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).textTheme.bodySmall?.color?.withOpacity(0.6),
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Send OTP
  void _sendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<SendOtpBloc>().add(
        SendOtpRequested(phoneNumber: _phoneController.text.trim()),
      );
    }
  }

  /// Reset form
  void _resetForm() {
    _phoneController.clear();
    context.read<SendOtpBloc>().add(const SendOtpReset());
  }

  /// Show success dialog
  void _showSuccessDialog(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.success),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to verify OTP page
              _navigateToVerifyOtp();
            },
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  /// Navigate to verify OTP page
  void _navigateToVerifyOtp() {
    final phoneNumber = _phoneController.text.trim();
    context.push('${RouteConstant.verifyOtp}?phone=$phoneNumber');
  }

  /// Show error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
