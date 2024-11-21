import 'dart:ffi';

import 'package:devcare_frontend/data/response/api_response.dart';
import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/home_screens/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final userPreference = Provider.of<SharedPrefs>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.hotel_class_outlined),
          title: const Text(
            'DemCare',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF432C81),
            ),
            textAlign: TextAlign.left,
          ),
          actions: [
            Icon(
              Icons.notifications,
              size: 35,
              color: Colors.grey.shade600,
            ),
            InkWell(
              onTap: () async {
                await SharedPrefs().remove();
                Navigator.pushNamed(context, RouteConstants.landingViewRoute);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                child: CircleAvatar(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    height: 390,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      // color: const Color(0xFFEDECF4),
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: (viewModel.getUserLocationResponse.status ==
                                Status.PRECALL)
                            ? FutureBuilder<void>(
                                future: viewModel
                                    .fetchAndCalculateDistance(userPreference),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      'Calculating Distance...',
                                      style: TextStyle(
                                        color: Color(0xFF432C81),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  } else if (snapshot.hasError ||
                                      !snapshot.hasData) {
                                    return const Text(
                                        "Error fetching location");
                                  }
            
                                  return Text(
                                    (viewModel.distanceInKiloMeters == null)
                                        ? 'Calculating Distance...'
                                        : 'Distance: ${viewModel.distanceInKiloMeters} km from Home',
                                    style: const TextStyle(
                                      color: Color(0xFF432C81),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              )
                            : Text(
                                (viewModel.distanceInKiloMeters == null)
                                    ? 'Calculating Distance...'
                                    : 'Distance: ${viewModel.distanceInKiloMeters} km from Home',
                                style: const TextStyle(
                                  color: Color(0xFF432C81),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  (viewModel.distanceInKiloMeters != null &&
                          viewModel.distanceInKiloMeters! > 3.0 &&
                          viewModel.emergencyEmailsSent)
                      ? Container(
                          margin: const EdgeInsets.symmetric(vertical: 16.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Emergency Alert",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.warning,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "You are far from your home. An emergency email has been sent to your contacts.",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Colors.red.shade400, // Background color
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // Call Emergency Contact 1
                                  launchUrl(Uri.parse(
                                      "tel://${viewModel.postEmailSentResponse.data!.emergencyContacts![0].contactNumber! ?? '100'}"));
                                },
                                icon:
                                    const Icon(Icons.call, color: Colors.white),
                                label: Text(
                                  'Call ${viewModel.postEmailSentResponse.data!.emergencyContacts![0].contactName! ?? 'Contact'}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Colors.red.shade400, // Background color
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  // Call Emergency Contact 2
                                  launchUrl(Uri.parse(
                                      "tel://${viewModel.postEmailSentResponse.data!.emergencyContacts![1].contactNumber! ?? '100'}"));
                                },
                                icon:
                                    const Icon(Icons.call, color: Colors.white),
                                label: Text(
                                  'Call ${viewModel.postEmailSentResponse.data!.emergencyContacts![1].contactName! ?? 'Contact'}',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Image.asset(
                            'assets/images/home.png',
                          ),
                        ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteConstants.homeViewRoute);
                        },
                        title: const Text(
                          'TO-DO LIST',
                          style: TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Image.asset(
                          'assets/images/todo.png',
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteConstants.allGameViewRoute);
                          },
                          title: const Text(
                            'GAMES',
                            style: TextStyle(
                              color: Color(0xFF432C81),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Image.asset(
                            'assets/images/game.png',
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: ListTile(
                        onTap: () {
                          // Navigator.pushNamed(
                          //     context, RouteConstants.homeViewRoute);
                        },
                        title: const Text(
                          'THERAPY',
                          style: TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Image.asset(
                          'assets/images/therapy.png',
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteConstants.videosViewRoute);
                          },
                          title: const Text(
                            'FITNESS',
                            style: TextStyle(
                              color: Color(0xFF432C81),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Image.asset(
                            'assets/images/fit.png',
                            height: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
