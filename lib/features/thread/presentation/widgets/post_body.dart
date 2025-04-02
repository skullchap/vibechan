import 'package:flutter/material.dart';
import '../../../../core/domain/models/post.dart';
import '../../../../shared/widgets/simple_html_renderer.dart';

class PostBody extends StatelessWidget {
  final Post post;

  const PostBody({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final commentHtml = post.comment ?? '';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SimpleHtmlRenderer(
        htmlString: commentHtml,
        baseStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
