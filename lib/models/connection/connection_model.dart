import 'package:connectivity/connectivity.dart';
import 'package:mobx/mobx.dart';
part 'connection_model.g.dart';

class ConnectionModel = _ConnectionModelBase with _$ConnectionModel;

abstract class _ConnectionModelBase with Store {
  _ConnectionModelBase() {
    connectivityStream = ObservableStream(Connectivity().onConnectivityChanged);
  }

  @observable
  ObservableStream<ConnectivityResult> connectivityStream;
}
