class ResponsePost {
  final bool resp;
  final String message;
  final List<Post> data;

  ResponsePost({
    required this.resp,
    required this.message,
    required this.data,
  });

  factory ResponsePost.fromJson(Map<String, dynamic> json) => ResponsePost(
        resp: json["resp"],
        message: json["message"],
        data: List<Post>.from(json["data"].map((x) => Post.fromJson(x))),
      );
}

class Post {
  final String uuid;
  final String note;
  final String user_uid;

  Post({required this.note, required this.user_uid, required this.uuid});

  factory Post.fromJson(Map<String, dynamic> json) =>
      Post(uuid: json["uuid"], note: json["note"], user_uid: json["user_uid"]);
}
