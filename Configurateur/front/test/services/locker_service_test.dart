import 'package:flutter_test/flutter_test.dart';
import 'package:front/services/locker_service.dart';

void main() {
  test('test getter locker_service', () {
    LockerService lockerService = LockerService();

    lockerService
        .setLockerCoordinates(LockerCoordinates(1, 2, 'front', 'direction', 1));

    expect(lockerService.getLockerCoordinates().x, 1);
    expect(lockerService.getLockerCoordinates().y, 2);
    expect(lockerService.getLockerCoordinates().face, 'front');
    expect(lockerService.getLockerCoordinates().direction, 'direction');
    expect(lockerService.getLockerCoordinates().size, 1);
  });
}
