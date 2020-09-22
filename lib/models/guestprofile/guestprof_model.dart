import 'package:mobx/mobx.dart';
part 'guestprof_model.g.dart';

class GuestProfileModel = _GuestProfileModelBase with _$GuestProfileModel;

abstract class _GuestProfileModelBase with Store {
  @observable
  int followerCount;

  @action
  setfollowerCount(int value) => followerCount = value;

  @action
  addfollowerCount() {
    followerCount = followerCount + 1;
  }

  @action
  subtractfollowerCount() {
    followerCount = followerCount - 1;
  }
}
