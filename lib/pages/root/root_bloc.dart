import 'package:my_clean/utils/utils_fonction.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootBLoc {
  Stream<int> get pageindexStream => _pageindexSubject.stream;
  final _pageindexSubject = BehaviorSubject<int>.seeded(0);

  BehaviorSubject<int> get pageindexSubject => _pageindexSubject;

  Stream<int> get drawerIndexStream => _drawerIndexSubject.stream;
  final _drawerIndexSubject = BehaviorSubject<int>();

  BehaviorSubject<int> get drawerIndexSubject => _drawerIndexSubject;

  Stream<String> get servicePassedIdStream => _servicePassedIdSubject.stream;
  final _servicePassedIdSubject = BehaviorSubject<String>();
  BehaviorSubject<String> get servicePassedIdSubject =>
      _servicePassedIdSubject;

  RootBLoc() {
    _pageindexSubject.add(0);
    _drawerIndexSubject.add(0);
  }

  switchToPage(int index) {
    _pageindexSubject.add(index);
  }

  setServicePAssedId(String id) {
    _servicePassedIdSubject.add(id);
  }

  switchDrawerIndex(int index) {
    _drawerIndexSubject.add(index);
  }

  logout() async {
    return await UtilsFonction.clearAll();
  }
}
