import 'dart:convert';

import 'package:hobby_hub_ui/http_setup/post_model.dart';
import 'package:http/http.dart';

class HttpService {
  final String postsUrl = "http://192.168.0.66:5000/api/Hello";

  Future<List<Post>> getPosts() async {
    Response res = await get(postsUrl);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Post> posts =
          body.map((dynamic item) => Post.fromJson(item)).toList();
      return posts;
    } else {
      throw "Can't get posts.";
    }
  }
}
