import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:posts_app/posts/bloc/post_bloc.dart';
import 'package:posts_app/posts/widgets/post_item.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final scrollController = ScrollController();
  @override
  void initState() {
    scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Posts App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
        switch (state.postStatus) {
          case PostStatus.failure:
            return Center(
              child: Lottie.asset(
                "assets/lottie/server_failure.json",
              ),
            );
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return const Icon(
                Icons.hourglass_empty,
                size: 60.0,
                color: Colors.blueGrey,
              );
            }
            return ListView.builder(
              itemCount: state.maxNumberOfPosts
                  ? state.posts.length
                  : state.posts.length + 1,
              controller: scrollController,
              itemBuilder: (context, index) {
                return index >= state.posts.length
                    ? Center(
                        child: Lottie.asset(
                        "assets/lottie/load.json",
                        height: 30.0,
                      ))
                    : PostItem(
                        id: state.posts[index].id,
                        body: state.posts[index].body,
                        title: state.posts[index].title,
                      );
              },
            );
          case PostStatus.initial:
            return Center(
              child: Lottie.asset(
                "assets/lottie/load.json",
              ),
            );
        }
      }),
    );
  }

  void onScroll() {
    if (isBottom) context.read<PostBloc>().add(FetchPostEvent());
  }

  bool get isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
