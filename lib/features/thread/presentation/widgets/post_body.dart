import 'package:flutter/material.dart';
import '../../../../core/domain/models/post.dart';
import '../../../../shared/widgets/html_text.dart';

class PostBody extends StatelessWidget {
  final Post post;

  const PostBody({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HtmlText(post.comment, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
