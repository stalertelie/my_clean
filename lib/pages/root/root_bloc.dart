import 'package:my_clean/utils/utils_fonction.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootBLoc {
  Stream<int> get pageindexStream => _pageindexSubject.stream;
  final _pageindexSubject = BehaviorSubject<int>();

  BehaviorSubject<int> get pageindexSubject => _pageindexSubject;

  Stream<int> get drawerIndexStream => _drawerIndexSubject.stream;
  final _drawerIndexSubject = BehaviorSubject<int>();

  BehaviorSubject<int> get drawerIndexSubject => _drawerIndexSubject;

  RootBLoc() {
    _pageindexSubject.add(0);
    _drawerIndexSubject.add(0);
  }

  switchToPage(int index) {
    _pageindexSubject.add(index);
  }

  switchDrawerIndex(int index) {
    _drawerIndexSubject.add(index);
  }

  logout() async {
    return await UtilsFonction.clearAll();
  }
}
