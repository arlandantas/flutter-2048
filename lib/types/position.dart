class Position {
  final int x;
  final int y;
  Position({required this.x, required this.y});

  isSame(Position target) {
    return x == target.x && y == target.y;
  }
}
