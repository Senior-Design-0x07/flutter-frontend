import 'package:flutter/material.dart';
import 'package:hobby_hub_ui/http_setup/post_model.dart';

class PostDetail extends StatelessWidget {
  final Post post;

  const PostDetail({@required this.post,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(post.title),
      ),
    );
  }
}