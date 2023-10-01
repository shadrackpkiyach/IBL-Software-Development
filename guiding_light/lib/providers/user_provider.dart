import 'package:flutter/material.dart';
import 'package:guiding_light/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    phoneNumber: '',
    token: '',
  );
  int _unreadNotifications = 0;
  int get unreadNotifications => _unreadNotifications;

  User get user => _user;

  void setUser(String userData) {
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }

  void incrementNotifications() {
    _unreadNotifications++;
    notifyListeners();
  }

  void resetNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }
}
