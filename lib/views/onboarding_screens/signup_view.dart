import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/res/colors.dart';
import 'package:devcare_frontend/res/primaryButton.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupView extends StatelessWidget {
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
                              // Name field
                              TextFormField(
                                onChanged: viewModel.setName,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Age field
                              TextFormField(
                                onChanged: viewModel.setAge,
                                decoration: const InputDecoration(
                                  labelText: 'Age*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your age';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Sex Dropdown field
                              DropdownButtonFormField<String>(
                                value: viewModel.gender,
                                decoration: const InputDecoration(
                                  labelText: 'Gender*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                items: viewModel.genderOptions
                                    .map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child: Text(gender),
                                  );
                                }).toList(),
                                onChanged: viewModel.setGender,
                              ),
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                              // Contact field
                              TextFormField(
                                onChanged: viewModel.setContact,
                                decoration: const InputDecoration(
                                  labelText: 'Contact Number*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your contact number';
                                  } else if (!RegExp(r'^\d{10}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid 10-digit contact number';
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
                            viewModel.submitForm(userPreference).then((response) {
                              if (viewModel.signupResponse.status == Status.COMPLETED) {
                                if (viewModel.signupResponse.data?.status == 'Successful') {
                                  Navigator.pushNamed(
                                      context, RouteConstants.otpViewRoute);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.signupResponse.data?.message ??
                                          'Sign up failed'),
                                    ),
                                  );
                                }
                              } else if (viewModel.signupResponse.status == Status.ERROR) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        viewModel.signupResponse.message ?? 'Sign up failed'),
                                  ),
                                );
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Processing Sign Up')),
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
                          'Already have an account?',
                          style: TextStyle(
                            color: Color(0xFF82799D),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, RouteConstants.loginViewRoute);
                          },
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
