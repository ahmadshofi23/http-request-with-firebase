class PlayerModels {
  String id, name, position, imageUrl;
  DateTime cretateAt;

  PlayerModels(
      {this.position = "",
      this.name = "",
      this.imageUrl = "",
      this.id = "",
      required this.cretateAt});
}
