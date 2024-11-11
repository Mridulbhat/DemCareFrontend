import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/res/primaryButton.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateContactsView extends StatelessWidget {
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 30),
                                child: Text(
                                  'Add Emergency Contacts',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF432C81),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              // Emergency Contact 1 Name
                              TextFormField(
                                onChanged: viewModel.setEmergencyContactName1,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact 1 Name*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the contact name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Emergency Contact 1 Number
                              TextFormField(
                                onChanged: viewModel.setEmergencyContactNumber1,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact 1 Number*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the contact number';
                                  } else if (!RegExp(r'^\d{10}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid 10-digit contact number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Emergency Contact 2 Name
                              TextFormField(
                                onChanged: viewModel.setEmergencyContactName2,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact 2 Name*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the contact name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Emergency Contact 2 Number
                              TextFormField(
                                onChanged: viewModel.setEmergencyContactNumber2,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact 2 Number*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the contact number';
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
                            viewModel.submitEmergencyContactsForm(userPreference).then((response) {
                              if (viewModel.otpVerificationResponse.status == Status.COMPLETED) {
                                if (viewModel.otpVerificationResponse.data?.status == 'Successful') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.otpVerificationResponse.data?.message ??
                                          'Submission Successful'),
                                    ),
                                  );
                                  Navigator.pushNamed(context, RouteConstants.homeViewRoute);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel.otpVerificationResponse.data?.message ??
                                          'Submission failed'),
                                    ),
                                  );
                                }
                              } else if (viewModel.otpVerificationResponse.status == Status.ERROR) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        viewModel.otpVerificationResponse.message ?? 'Submission failed'),
                                  ),
                                );
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Processing Contacts Submission')),
                            );
                          }
                        },
                        buttonText: 'Submit',
                      ),
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
