import 'bt_platform_interface.dart';

class Bt {
  Future<String?> getPlatformVersion() {
    return BtPlatform.instance.getPlatformVersion();
  }

  Future<String?> hello() {
    return BtPlatform.instance.hello();
  }

  Future<void> scheduleDeactivation(int minutes) {
    return BtPlatform.instance.scheduleBtDeactivation(minutes);
  }
}
