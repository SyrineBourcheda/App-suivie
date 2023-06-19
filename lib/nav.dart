import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationBloc extends Bloc<String, String> {
  NavigationBloc() : super('/');

  @override
  Stream<String> mapEventToState(String event) async* {
    yield event;
  }
}