import 'package:wascan_soil_secrets/models/player_skin.dart';

List<PlayerSkin> playerSkins = [
  PlayerSkin(
    id: 0,
    cost: 0,
    isPremium: false,
    abilityDuration: 10,
    asset: "assets/png/player_skins/bast.png",
    name: 'Bast',
    description:
        'Collects twice as many treasures with a positive effect for 10 seconds',
  ),
  PlayerSkin(
    id: 1,
    cost: 2000,
    abilityDuration: 0,
    isPremium: false,
    asset: "assets/png/player_skins/maahes.png",
    name: 'Maahes',
    description:
        'Burns 3x3 cells and Pharaoh with them if he’s in. Other treasures are not burnt',
  ),
  PlayerSkin(
    id: 2,
    cost: 5000,
    isPremium: false,
    abilityDuration: 10,
    asset: "assets/png/player_skins/serket.png",
    name: 'Serket',
    description: 'Becomes invulnerable to bad artifacts for\n10 seconds',
  ),
  PlayerSkin(
    id: 3,
    cost: 0,
    isPremium: true,
    abilityDuration: 15,
    asset: "assets/png/player_skins/ermak.png",
    name: 'Ermak',
    description: 'Gives the ability to see through walls for\n15 seconds',
  ),
  PlayerSkin(
    id: 4,
    cost: 0,
    isPremium: true,
    abilityDuration: 10,
    asset: "assets/png/player_skins/anubis.png",
    name: 'Anubis',
    description: 'Gives permanent immunity to the curse of the Pharaoh',
  ),
];
