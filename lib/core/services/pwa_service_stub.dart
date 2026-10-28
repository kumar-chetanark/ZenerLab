// Stub implementation for non-web platforms
class PwaService {
  static final PwaService instance = PwaService._();
  PwaService._();

  bool get canInstall => false;
  bool get isStandalone => false;

  void initialize(void Function() onInstallableChanged) {}

  Future<bool> promptInstall() async => false;
}
