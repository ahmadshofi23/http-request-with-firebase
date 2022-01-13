import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http_request_with_firebase/pages/addplayer_page.dart';
import 'package:http_request_with_firebase/pages/detail_page.dart';
import 'package:http_request_with_firebase/provider/players_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<PlayersProvider>(context).initialData();
    }
    isInit = false;
    super.didChangeDependencies();
    print("REBUILD STATE");
  }

  @override
  Widget build(BuildContext context) {
    final allPlayerProvider = Provider.of<PlayersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("ALL PLAYERS"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddPlayerPage.routeName);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.remove_red_eye),
          //   onPressed: () {
          //     allPlayerProvider.initialData().then((_) {
          //       setState(() {});
          //     });
          //   },
          // ),
        ],
      ),
      body: (allPlayerProvider.jumlahPlayer == 0)
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Data",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddPlayerPage.routeName);
                    },
                    child: Text(
                      "Add Player",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: allPlayerProvider.jumlahPlayer,
              itemBuilder: (context, index) {
                var id = allPlayerProvider.allPlayer[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailPlayerPage.routeName,
                      arguments: id,
                    );
                  },
                  // leading: CircleAvatar(
                  //   backgroundImage: NetworkImage(
                  //     allPlayerProvider.allPlayer[index].imageUrl,
                  //   ),
                  // ),
                  //
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: allPlayerProvider.allPlayer[index].imageUrl,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                          width: 50,
                          height: 50,
                          child: Image.network(
                              "https://www.uclg-planning.org/sites/default/files/styles/featured_home_left/public/no-user-image-square.jpg"),
                        ),
                      ),
                    ),
                  ),

                  title: Text(
                    allPlayerProvider.allPlayer[index].name,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMMd()
                        .format(allPlayerProvider.allPlayer[index].cretateAt),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      allPlayerProvider.deletePlayer(id).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil dihapus"),
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      });
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}
