import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bt_method_channel.dart';

abstract class BtPlatform extends PlatformInterface {
  /// Constructs a BtPlatform.
  BtPlatform() : super(token: _token);

  static final Object _token = Object();

  static BtPlatform _instance = MethodChannelBt();

  /// The default instance of [BtPlatform] to use.
  ///
  /// Defaults to [MethodChannelBt].
  static BtPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BtPlatform] when
  /// they register themselves.
  static set instance(BtPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> hello() {
    throw UnimplementedError('hello() has not been implemented.');
  }

  Future<void> scheduleBtDeactivation(int minutes) {
    throw UnimplementedError('scheduleBtDeactivation() has not been implemented.');
  }
}
