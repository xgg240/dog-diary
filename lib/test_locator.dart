// 临时：import 到 main.dart 测
import 'core/location_service.dart';
void testLoc() async {
  final r = await LocationService.getMyLocation();
  print('LOC RESULT: $r');
}
