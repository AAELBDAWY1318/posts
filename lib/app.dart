import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_app/posts/bloc/post_bloc.dart';
import 'package:posts_app/posts/view/post_page.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => PostBloc(httpClient: http.Client())..add(
          FetchPostEvent(), 
        ),
        child: const PostPage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
