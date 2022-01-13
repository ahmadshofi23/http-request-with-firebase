import 'package:flutter/material.dart';
import 'package:http_request_with_firebase/provider/players_provider.dart';
import 'package:provider/provider.dart';

class AddPlayerPage extends StatelessWidget {
  static const routeName = "/add-player";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<PlayersProvider>(context, listen: false);
    final VoidCallback addPlayers = () {
      players
          .addPlayer(
            nameController.text,
            positionController.text,
            imageController.text,
          )
          .then(
            (response) => {
              print("Kembali ke Home & kasih notif snackbar"),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Berhasil Ditambahkan"),
                  duration: Duration(seconds: 2),
                ),
              ),
              Navigator.pop(context),
            },
          )
          .catchError(
            (err) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("TERJADI ERROR $err"),
                content: Text("Tidak dapat menambahkan data."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            ),
          );
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("ADD PLAYER"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: addPlayers,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(labelText: "Nama"),
                textInputAction: TextInputAction.next,
                controller: nameController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(labelText: "Posisi"),
                textInputAction: TextInputAction.next,
                controller: positionController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(labelText: "Image URL"),
                textInputAction: TextInputAction.done,
                controller: imageController,
                onEditingComplete: addPlayers,
              ),
              SizedBox(height: 50),
              Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  onPressed: addPlayers,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
