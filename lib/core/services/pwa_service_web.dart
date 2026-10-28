import 'dart:js_interop';
import 'package:web/web.dart' as web;

@JS('zenerLabCanInstall')
external bool? get _zenerLabCanInstall;

@JS('installZenerLabApp')
external JSPromise<JSBoolean> _installZenerLabApp();

@JS('onZenerLabInstallable')
external set _onZenerLabInstallable(JSFunction? callback);

class PwaService {
  static final PwaService instance = PwaService._();
  PwaService._();

  bool _canInstall = false;
  void Function()? _onInstallableChanged;

  bool get canInstall => _canInstall;

  bool get isStandalone {
    try {
      final isStandaloneDisplay = web.window.matchMedia('(display-mode: standalone)').matches;
      final isIosStandalone = (web.window.navigator as dynamic).standalone == true;
      return isStandaloneDisplay || isIosStandalone;
    } catch (_) {
      return false;
    }
  }

  void initialize(void Function() onInstallableChanged) {
    _onInstallableChanged = onInstallableChanged;

    if (_zenerLabCanInstall == true) {
      _canInstall = true;
      _onInstallableChanged?.call();
    }

    _onZenerLabInstallable = (() {
      _canInstall = true;
      _onInstallableChanged?.call();
    }).toJS;
  }

  Future<bool> promptInstall() async {
    try {
      final jsPromise = _installZenerLabApp();
      final jsBool = await jsPromise.toDart;
      _canInstall = false;
      _onInstallableChanged?.call();
      return jsBool.toDart;
    } catch (e) {
      return false;
    }
  }
}
