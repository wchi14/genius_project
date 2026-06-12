/// Local seat is always [SniperPlayerId.p1] in the hub UI.
enum SniperPlayerId {
  p1,
  p2;

  SniperPlayerId get opponent =>
      this == SniperPlayerId.p1 ? SniperPlayerId.p2 : SniperPlayerId.p1;
}
