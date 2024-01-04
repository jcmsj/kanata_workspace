import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bt_platform_interface.dart';

/// An implementation of [BtPlatform] that uses method channels.
class MethodChannelBt extends BtPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bt');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> hello() async {
    return methodChannel.invokeMethod<String?>('hello');
  }

  @override
  Future<void> scheduleBtDeactivation(int minutes) async {
    return methodChannel.invokeMethod<void>(
        'scheduleBtDeactivation', {'timeInMinutes': minutes});
  }
}
