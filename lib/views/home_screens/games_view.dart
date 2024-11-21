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

class GamesView extends StatelessWidget {
  const GamesView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final userPreference = Provider.of<SharedPrefs>(context, listen: false);

    final List<String> titles = [
      'Puzzle Game',
      'Memory Cards',
      'Face Recognition',
      'Memory Game',
      'Logic Game',
      'Tricky Colors',
      'Word Generator',
      'Let\'s Find It',
    ];

    final List<String> imagePaths = [
      'assets/images/game1.png',
      'assets/images/game2.png',
      'assets/images/game3.png',
      'assets/images/game4.png',
      'assets/images/game5.png',
      'assets/images/game6.png',
      'assets/images/game7.png',
      'assets/images/game8.png',
    ];

    final List<String> gameUrls = [
      'https://www.mentalup.co/samples/game-v2/game122?referrer=blog-games-for-dementia-patients&page=Desktop&ga_dp=%2Fblog%2Fgames-for-dementia-patients&adj_redirect_android=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.ayasis.mentalup%26listing%3Dbrain-games-for-adults-web&adj_redirect_ios=https%3A%2F%2Fapps.apple.com%2Fapp%2Fmentalup-kids-learning-games%2Fid1284769817%3Fppid%3D5ad25681-b721-4cba-a5dd-7dd102afcc49',
      'https://www.mentalup.co/samples/game-v2/game24?referrer=blog-games-for-dementia-patients&page=Desktop&ga_dp=%2Fblog%2Fgames-for-dementia-patients&adj_redirect_android=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.ayasis.mentalup%26listing%3Dbrain-games-for-adults-web&adj_redirect_ios=https%3A%2F%2Fapps.apple.com%2Fapp%2Fmentalup-kids-learning-games%2Fid1284769817%3Fppid%3D5ad25681-b721-4cba-a5dd-7dd102afcc49',
      'https://www.mentalup.co/samples/game-v2/game64?referrer=blog-games-for-dementia-patients&page=Desktop&ga_dp=%2Fblog%2Fgames-for-dementia-patients&adj_redirect_android=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.ayasis.mentalup%26listing%3Dbrain-games-for-adults-web&adj_redirect_ios=https%3A%2F%2Fapps.apple.com%2Fapp%2Fmentalup-kids-learning-games%2Fid1284769817%3Fppid%3D5ad25681-b721-4cba-a5dd-7dd102afcc49',
      'https://www.mentalup.co/samples/game-v2/game9?referrer=blog-games-for-dementia-patients&page=Desktop&ga_dp=%2Fblog%2Fgames-for-dementia-patients&adj_redirect_android=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.ayasis.mentalup%26listing%3Dbrain-games-for-adults-web&adj_redirect_ios=https%3A%2F%2Fapps.apple.com%2Fapp%2Fmentalup-kids-learning-games%2Fid1284769817%3Fppid%3D5ad25681-b721-4cba-a5dd-7dd102afcc49',
      'https://www.mentalup.co/samples/game/game19?referrer=blog-games-for-dementia-patients&page=Desktop&ga_dp=%2Fblog%2Fgames-for-dementia-patients&adj_redirect_android=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.ayasis.mentalup%26listing%3Dbrain-games-for-adults-web&adj_redirect_ios=https%3A%2F%2Fapps.apple.com%2Fapp%2Fmentalup-kids-learning-games%2Fid1284769817%3Fppid%3D5ad25681-b721-4cba-a5dd-7dd102afcc49',
      'https://www.mentalup.co/samples/game/game21?referrer=blog-games-for-dementia-patients&page=Desktop&ga_dp=%2Fblog%2Fgames-for-dementia-patients&adj_redirect_android=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.ayasis.mentalup%26listing%3Dbrain-games-for-adults-web&adj_redirect_ios=https%3A%2F%2Fapps.apple.com%2Fapp%2Fmentalup-kids-learning-games%2Fid1284769817%3Fppid%3D5ad25681-b721-4cba-a5dd-7dd102afcc49',
      'https://www.mentalup.co/samples/game/game37?referrer=blog-games-for-dementia-patients&page=Desktop&ga_dp=%2Fblog%2Fgames-for-dementia-patients&adj_redirect_android=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.ayasis.mentalup%26listing%3Dbrain-games-for-adults-web&adj_redirect_ios=https%3A%2F%2Fapps.apple.com%2Fapp%2Fmentalup-kids-learning-games%2Fid1284769817%3Fppid%3D5ad25681-b721-4cba-a5dd-7dd102afcc49',
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
                          'GAMES',
                          style: TextStyle(
                            color: Color(0xFF432C81),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Image.asset(
                          'assets/images/game.png',
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
                                    RouteConstants.gameViewRoute,
                                    arguments: {'url': gameUrls[index]},
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
