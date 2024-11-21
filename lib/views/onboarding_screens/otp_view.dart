import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/res/colors.dart';
import 'package:devcare_frontend/res/primaryButton.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

class OtpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);
    final userPreference = Provider.of<SharedPrefs>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Ensure space between form and button
                  children: [
                    // Form Section inside scrollable area
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                child: Text(
                                  'DemCare',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF432C81),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF432C81),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Image.asset(
                                  'assets/images/otp.png',
                                  height: 142,
                                  width: 140,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  'OTP Verification',
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B096C),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Text(
                                'Enter the OTP sent to',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF084D79),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  viewModel.email,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF084D79),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: OtpTextField(
                                  numberOfFields: 4,
                                  borderColor: AppColors.primaryColor,
                                  enabledBorderColor: Colors.grey,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0)),
                                  fieldWidth: 58,
                                  showCursor: false,
                                  showFieldAsBox: true,
                                  //runs when a code is typed in
                                  onCodeChanged: (String code) {
                                    //handle validation or checks here
                                  },
                                  //runs when every textfield is filled
                                  onSubmit: (String verificationCode) {
                                    viewModel.setOTPEntered(verificationCode);
                                  }, // end onSubmit
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Didn\'t receive the OTP?',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            viewModel.submitForm(userPreference).then((response) {
                              if (response.status == Status.COMPLETED) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('OTP Sent')),
                                );
                              } else if (response.status == Status.ERROR) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        response.message ?? 'Sign up failed'),
                                  ),
                                );
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Resending OTP')),
                            );
                          },
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),

                    // CTA button at the bottom
                    PrimaryButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          viewModel.verifyOTP(userPreference).then((response) {
                            if (response.status == Status.COMPLETED) {
                              if (response.data?.status == 'Successful') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Welcome ${response.data?.user?.name}')),
                                );
                                Navigator.pushNamed(
                                    context,
                                    response.data?.user?.emergencyContacts
                                                ?.length ==
                                            0
                                        ? RouteConstants
                                            .emergencyContactsViewRoute
                                        : RouteConstants.mainViewRoute);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(response.data?.message ??
                                        'Verification failed'),
                                  ),
                                );
                              }
                            } else if (response.status == Status.ERROR) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(response.message ??
                                      'Verification failed'),
                                ),
                              );
                            }
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Verifying OTP')),
                          );
                        }
                      },
                      buttonText: 'Verify & Proceed',
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            color: Color(0xFF82799D),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                      ],
                    )
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
