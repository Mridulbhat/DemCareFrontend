import 'package:devcare_frontend/data/response/api_response.dart';
import 'package:devcare_frontend/data/response/status.dart';
import 'package:devcare_frontend/model/response/GetAllTodoResponse.dart';
import 'package:devcare_frontend/model/response/Todos.dart';
import 'package:devcare_frontend/res/addTodoDialog.dart';
import 'package:devcare_frontend/utils/RouteConstants.dart';
import 'package:devcare_frontend/utils/SharedPrefs.dart';
import 'package:devcare_frontend/views/home_screens/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VideosView extends StatelessWidget {
  const VideosView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final userPreference = Provider.of<SharedPrefs>(context, listen: false);

    final List<String> titles = [
      'Yoga Full Body',
      'Increase Immunity',
      'Beginners Exercises',
      'Yoga for Senior Citizens',
      'Yoga in Hindi',
    ];

    final List<String> imagePaths = [
      'assets/images/video1.png',
      'assets/images/video2.png',
      'assets/images/video3.png',
      'assets/images/video4.png',
      'assets/images/video5.png',
    ];

    final List<String> videoUrls = [
      'https://youtu.be/brjAjq4zEIE?si=F7ZytyA3qsxQSty0',
      'https://youtu.be/cMfChJLqma4?si=rhYLuQfbFv2Tay6e',
      'https://youtu.be/sSiA25XlG_A?si=pPn5Wysyyn6t2B-u',
      'https://youtu.be/laIWV6qJWbk?si=x-th1-oPVyPw4ora',
      'https://youtu.be/brjAjq4zEIE?si=F7ZytyA3qsxQSty0',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          Icon(
            Icons.notifications,
            size: 35,
            color: Colors.grey.shade600,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: CircleAvatar(
              child: Image.asset(
                'assets/images/avatar.png',
                height: 390,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 116,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: ListTile(
                        title: const Text(
                          'FITNESS',
                          style: TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Image.asset(
                          'assets/images/fit.png',
                          height: 60,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
                Expanded(
                  child: ListView.builder(
                      itemCount: titles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteConstants.videoPlayRoute,
                                    arguments: {'url': videoUrls[index]},
                                  );
                                },
                                title: Text(
                                  titles[index],
                                  style: const TextStyle(
                                    color: Color(0xFF432C81),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Image.asset(
                                  imagePaths[index],
                                  height: 50,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
