class ChatsModel {
  late String id;
  late String username;
  late String message;
  late String profilePicture;
  ChatsModel(
      {required this.id,
      required this.username,
      required this.profilePicture,
      required this.message});

  ChatsModel.fromJson(Map<String, dynamic> json) {
    id:
    json["id"];
    username:
    json["username"];
    message:
    json["message"];
    profilePicture:
    json["profilePicture"];
  }
}
