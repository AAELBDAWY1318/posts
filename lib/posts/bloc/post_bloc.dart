import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app/posts/models/posts.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
part 'post_event.dart';
part 'post_state.dart';

const postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;
  PostBloc({required this.httpClient}) : super(const PostState()) {
    on<FetchPostEvent>(
      getPosts,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> getPosts(FetchPostEvent event, Emitter<PostState> emit) async {
    if (state.maxNumberOfPosts) return;
    try {
      if (state.postStatus == PostStatus.initial) {
        final posts = await fetchPosts();
        return emit(
          state.copyWith(
            postStatus: PostStatus.success,
            posts: posts,
            maxNumberOfPosts: false,
          ),
        );
      }
      final posts = await fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(maxNumberOfPosts: true))
          : emit(
              state.copyWith(
                postStatus: PostStatus.success,
                posts: List.of(state.posts)..addAll(posts),
                maxNumberOfPosts: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(postStatus: PostStatus.failure));
    }
  }

  Future<List<PostModel>> fetchPosts([int index = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$index', '_limit': '$postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return PostModel(
          id: map['id'] as int,
          title: map['title'] as String,
          body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
