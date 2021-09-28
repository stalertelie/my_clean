import 'package:rxdart/rxdart.dart';

import 'loading.dart';

abstract class BaseBloc {
  Stream<Loading> get loading => _loadingSubject.stream;
  final _loadingSubject = BehaviorSubject<Loading>();
  BehaviorSubject<Loading> get loadingSubject => _loadingSubject;

  void dispose(){
    _loadingSubject.close();
  }
}