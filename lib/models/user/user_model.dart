import 'package:mobx/mobx.dart';
part 'user_model.g.dart';

class UserModel = _UserModelBase with _$UserModel;

abstract class _UserModelBase with Store {
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

  @action
  setUserInfo(
      String newUserId,
      String newDisplayName,
      String newDpUrl,
      String newEmail,
      String newBio,
      String newPhoneNumber,
      bool newIsVerified) {
    userId = newUserId;
    displayName = newDisplayName;
    dpUrl = newDpUrl;
    email = newEmail;
    bio = newBio;
    phoneNumber = newPhoneNumber;
    isVerified = newIsVerified;
  }
}
