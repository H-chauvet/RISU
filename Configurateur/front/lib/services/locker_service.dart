/// LockerCoordinates
///
/// Class for the locker coordinates
///[x] : X coordinate for the locker
///[y] : Y coordinate for the locker
/// [face] : Container's face where the locker is
/// [direction] : Locker's direction
/// [size] : Locker's size
class LockerCoordinates {
  int x;
  int y;
  String face;
  String direction;
  int size;

  LockerCoordinates(this.x, this.y, this.face, this.direction, this.size);

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
      'face': face,
      'direction': direction,
      'size': size,
    };
  }
}

/// LockerService
///
/// Defines the locker's coordinates
class LockerService {
  LockerCoordinates? _lockerCoordinates;

  /// [Function] : Set the locker's coordinates
  ///
  /// [lockerCoordinates] : locker's informations
  void setLockerCoordinates(LockerCoordinates lockerCoordinates) {
    _lockerCoordinates = lockerCoordinates;
  }

  /// [Function] : Get the locker's coordinates
  /// return the locker's informations
  getLockerCoordinates() {
    return _lockerCoordinates;
  }
}
