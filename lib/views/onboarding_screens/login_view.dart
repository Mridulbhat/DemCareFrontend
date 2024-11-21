import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/res/colors.dart';
import 'package:devcare_frontend/res/primaryButton.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);

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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF432C81),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Email field
                              TextFormField(
                                onChanged: viewModel.setEmail,
                                decoration: const InputDecoration(
                                  labelText: 'Email ID*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // CTA button at the bottom
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: PrimaryButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            viewModel.login().then((response) {
                              if (viewModel.loginResponse.status == Status.COMPLETED) {
                                if (viewModel.loginResponse.data?.status == 'Successful') {
                                  Navigator.pushNamed(
                                      context, RouteConstants.otpViewRoute);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.loginResponse.data?.message ??
                                          'Failed to send OTP'),
                                    ),
                                  );
                                }
                              } else if (viewModel.loginResponse.status == Status.ERROR) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        viewModel.loginResponse.message ?? 'Failed to send OTP'),
                                  ),
                                );
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sending OTP...')),
                            );
                          }
                        },
                        buttonText: 'Next',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don’t have an account?',
                          style: TextStyle(
                            color: Color(0xFF82799D),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, RouteConstants.signupViewRoute);
                          },
                          child: const Text(
                            'Sign Up',
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
