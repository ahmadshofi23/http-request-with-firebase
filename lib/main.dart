import 'package:flutter/material.dart';
import 'package:http_request_with_firebase/pages/addplayer_page.dart';
import 'package:http_request_with_firebase/pages/detail_page.dart';
import 'package:http_request_with_firebase/provider/players_provider.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlayersProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          AddPlayerPage.routeName: (context) => AddPlayerPage(),
          DetailPlayerPage.routeName: (context) => DetailPlayerPage(),
        },
      ),
    );
  }
}
