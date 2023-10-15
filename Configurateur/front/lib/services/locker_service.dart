class LockerCoordinates {
  int x;
  int y;
  String face;
  String direction;
  int size;

  LockerCoordinates(this.x, this.y, this.face, this.direction, this.size);
}

class LockerService {
  LockerCoordinates? _lockerCoordinates;

  void setLockerCoordinates(LockerCoordinates lockerCoordinates) {
    _lockerCoordinates = lockerCoordinates;
  }

  getLockerCoordinates() {
    return _lockerCoordinates;
  }
}
