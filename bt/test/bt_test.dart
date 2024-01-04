import 'package:flutter_test/flutter_test.dart';
import 'package:bt/bt.dart';
import 'package:bt/bt_platform_interface.dart';
import 'package:bt/bt_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBtPlatform
    with MockPlatformInterfaceMixin
    implements BtPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final BtPlatform initialPlatform = BtPlatform.instance;

  test('$MethodChannelBt is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBt>());
  });

  test('getPlatformVersion', () async {
    Bt btPlugin = Bt();
    MockBtPlatform fakePlatform = MockBtPlatform();
    BtPlatform.instance = fakePlatform;

    expect(await btPlugin.getPlatformVersion(), '42');
  });
}
