import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:posts_app/app.dart';
import 'package:posts_app/bloc_observer.dart';

void main(){
  Bloc.observer = const SimpleBlocObserver();
  runApp(const App());
}