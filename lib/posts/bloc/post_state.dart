part of 'post_bloc.dart';

enum PostStatus { initial, success, failure }

final class PostState extends Equatable {
  final PostStatus postStatus;
  final List<PostModel> posts;
  final bool maxNumberOfPosts;
  const PostState(
      {this.postStatus = PostStatus.initial,
      this.posts = const <PostModel>[],
      this.maxNumberOfPosts = false});

  PostState copyWith({
    PostStatus? postStatus,
    List<PostModel>? posts,
    bool? maxNumberOfPosts,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      postStatus: postStatus ?? this.postStatus,
      maxNumberOfPosts: maxNumberOfPosts ?? this.maxNumberOfPosts,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $postStatus, hasReachedMax: $maxNumberOfPosts, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [postStatus, posts, maxNumberOfPosts];
}
