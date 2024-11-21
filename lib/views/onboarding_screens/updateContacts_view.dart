import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/res/primaryButton.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/onboarding_screens/signup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class UpdateContactsView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignupViewModel>(context);
    final userPreference = Provider.of<SharedPrefs>(context, listen: false);
    GoogleMapController mapController;

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 24),
                                child: Text(
                                  'Add EMERGENCY Details',
                                  style: TextStyle(
                                    fontSize: 24,
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
                              TextFormField(
                                onChanged: viewModel.setEmergencyContactEmail1,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact 1 Email*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the contact email';
                                  } else if (!RegExp(
                                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
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
                              const SizedBox(height: 16),
                              TextFormField(
                                onChanged: viewModel.setEmergencyContactEmail2,
                                decoration: const InputDecoration(
                                  labelText: 'Emergency Contact 2 Email*',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the contact email';
                                  } else if (!RegExp(
                                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              (viewModel.userLocation.latitude == 0.0)
                                  ? FutureBuilder(
                                      future: viewModel.getUserLocation(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text(
                                              "Error fetching your location");
                                        } else if (!snapshot.hasData ||
                                            snapshot.data! == false) {
                                          return const Text(
                                              "Error fetching your location");
                                        }

                                        return Container(
                                          // width: 400,
                                          height: 170,
                                          color: Colors.blue,
                                          child: GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                                    target:
                                                        viewModel.userLocation,
                                                    zoom: 10),
                                            markers: {
                                              Marker(
                                                markerId:
                                                    MarkerId('initialLocation'),
                                                position:
                                                    viewModel.userLocation,
                                                draggable: true,
                                                onDragEnd: (newPosition) {
                                                  viewModel.updateLocation(
                                                      newPosition);
                                                },
                                              ),
                                            },
                                            onTap: (newPosition) {
                                              viewModel
                                                  .updateLocation(newPosition);
                                            },
                                            zoomControlsEnabled: true,
                                            onMapCreated: (controller) {
                                              mapController = controller;
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 400,
                                      height: 170,
                                      color: Colors.blue,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                            target: viewModel.userLocation,
                                            zoom: 10),
                                        markers: {
                                          Marker(
                                            markerId:
                                                MarkerId('initialLocation'),
                                            position: viewModel.userLocation,
                                            draggable: true,
                                            onDragEnd: (newPosition) {
                                              viewModel
                                                  .updateLocation(newPosition);
                                            },
                                          ),
                                        },
                                        onTap: (newPosition) {
                                          viewModel.updateLocation(newPosition);
                                        },
                                        zoomControlsEnabled: true,
                                        onMapCreated: (controller) {
                                          mapController = controller;
                                        },
                                      ),
                                    ),
                              const SizedBox(height: 16),
                              const Text(
                                'Patient\'s Address\:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                viewModel.userAddress ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
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
                            viewModel
                                .submitEmergencyContactsForm(userPreference)
                                .then((response) {
                              if (viewModel.otpVerificationResponse.status ==
                                  Status.COMPLETED) {
                                if (viewModel
                                        .otpVerificationResponse.data?.status ==
                                    'Successful') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel
                                              .otpVerificationResponse
                                              .data
                                              ?.message ??
                                          'Submission Successful'),
                                    ),
                                  );
                                  Navigator.pushNamed(
                                      context, RouteConstants.mainViewRoute);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(viewModel
                                              .otpVerificationResponse
                                              .data
                                              ?.message ??
                                          'Submission failed'),
                                    ),
                                  );
                                }
                              } else if (viewModel
                                      .otpVerificationResponse.status ==
                                  Status.ERROR) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(viewModel
                                            .otpVerificationResponse.message ??
                                        'Submission failed'),
                                  ),
                                );
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Processing Contacts Submission')),
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
