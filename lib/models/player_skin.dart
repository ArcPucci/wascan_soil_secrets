class PlayerSkin {
  final int id;
  final int cost;
  final bool isPremium;
  final String asset;
  final String name;
  final String description;
  final int abilityDuration;

  PlayerSkin({
    required this.abilityDuration,
    required this.isPremium,
    required this.name,
    required this.description,
    required this.id,
    required this.cost,
    required this.asset,
  });
}
