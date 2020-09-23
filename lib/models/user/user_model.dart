import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'user_model.g.dart';

class UserModel = _UserModelBase with _$UserModel;

abstract class _UserModelBase with Store {
  // @action
  // getUserInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   userId = prefs.getString('userId') ?? '';
  //   displayName = prefs.getString('displayName') ?? '';
  //   dpUrl = prefs.getString('dpUrl') ?? '';
  //   email = prefs.getString('email') ?? '';
  //   bio = prefs.getString('bio') ?? '';
  //   phoneNumber = prefs.getString('phoneNumber') ?? '';
  //   isVerified = prefs.getBool('isVerified') ?? false;
  // }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('userId') ?? '';
  }

  Future<String> getDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('displayName') ?? '';
  }

  Future<String> getDpUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('dpUrl') ?? '';
  }

  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('email') ?? '';
  }

  Future<String> getBio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('bio') ?? '';
  }

  Future<String> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('phoneNumber') ?? '';
  }

  Future<bool> getIsVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isVerified') ?? false;
  }

  @observable
  String userId;

  @observable
  String displayName;

  @observable
  String dpUrl;

  @observable
  String email;

  @observable
  String bio;

  @observable
  String phoneNumber;

  @observable
  bool isVerified;

  // setUserInfo(
  //     String newUserId,
  //     String newDisplayName,
  //     String newDpUrl,
  //     String newEmail,
  //     String newBio,
  //     String newPhoneNumber,
  //     bool newIsVerified) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();

  //   prefs.setString('userId', newUserId);
  //   prefs.setString('displayName', newDisplayName);
  //   prefs.setString('dpUrl', newDpUrl);
  //   prefs.setString('email', newEmail);
  //   prefs.setString('bio', newBio);
  //   prefs.setString('phoneNumber', newPhoneNumber);
  //   prefs.setBool('isVerified', isVerified);
  // }
}
