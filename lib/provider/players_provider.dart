import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_request_with_firebase/models/player_models.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PlayersProvider with ChangeNotifier {
  List<PlayerModels> _allPlayer = [];

  List<PlayerModels> get allPlayer => _allPlayer;

  int get jumlahPlayer => _allPlayer.length;

  PlayerModels selectById(String id) =>
      _allPlayer.firstWhere((element) => element.id == id);

  Future<void> addPlayer(String name, String position, String image) {
    DateTime datetimeNow = DateTime.now();

    Uri url = Uri.parse(
        "https://temafutsal-1886f-default-rtdb.firebaseio.com/players.json");
    return http
        .post(
      url,
      body: json.encode(
        {
          "name": name,
          "position": position,
          "imageUrl": image,
          "cretateAt": datetimeNow.toString(),
        },
      ),
    )
        .then(
      (response) {
        _allPlayer.add(
          PlayerModels(
            id: json.decode(response.body)["name"].toString(),
            name: name,
            position: position,
            imageUrl: image,
            cretateAt: datetimeNow,
          ),
        );

        notifyListeners();
      },
    );
  }

  Future<void> editPlayer(
      String id, String name, String position, String image) {
    Uri url = Uri.parse(
        "https://temafutsal-1886f-default-rtdb.firebaseio.com/players/$id.json");
    return http
        .patch(
      url,
      body: json.encode(
        {
          "name": name,
          "position": position,
          "imageUrl": image,
          // "cretateAt": datetimeNow.toString(),
        },
      ),
    )
        .then(
      (response) {
        PlayerModels selectPlayer =
            _allPlayer.firstWhere((element) => element.id == id);
        selectPlayer.name = name;
        selectPlayer.position = position;
        selectPlayer.imageUrl = image;
        notifyListeners();
      },
    );
  }

  Future deletePlayer(String id) {
    Uri url = Uri.parse(
        "https://temafutsal-1886f-default-rtdb.firebaseio.com/players/$id.json");
    return http.delete(url).then(
      (response) {
        _allPlayer.removeWhere((element) => element.id == id);
        notifyListeners();
      },
    );
  }

  Future<void> initialData() async {
    Uri url = Uri.parse(
        "https://temafutsal-1886f-default-rtdb.firebaseio.com/players.json");
    var hasilGetData = await http.get(url);
    var dataResponse = json.decode(hasilGetData.body) as Map<String, dynamic>;
    dataResponse.forEach(
      (key, value) {
        // print(value);
        DateTime dateTimerParse =
            DateFormat("yyyy-mm-dd hh:mm:ss").parse(value["cretateAt"]);
        print(dateTimerParse);
        _allPlayer.add(
          PlayerModels(
            id: key,
            name: value["name"],
            cretateAt: dateTimerParse,
            position: value["position"],
            imageUrl: value["imageUrl"],
          ),
        );
      },
    );
    notifyListeners();
  }
}
