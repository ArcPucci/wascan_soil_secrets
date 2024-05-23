import 'package:shared_preferences/shared_preferences.dart';
import 'package:wascan_soil_secrets/utils/background_skins.dart';
import 'package:wascan_soil_secrets/utils/player_skins.dart';

class PreferenceService {
  static final PreferenceService instance = PreferenceService._();
  static late final SharedPreferences _prefs;

  PreferenceService._();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  factory PreferenceService() => instance;

  static const premiumKey = "PREMIUM_KEY";
  static const selectedPlayerSkinKey = "SELECTED_PLAYER_SKIN";
  static const selectedBackgroundSkinKey = "SELECTED_BACKGROUND_SKIN";
  static const boughtBackgroundSkinsKey = "BOUGHT_BACKGROUND_SKINS";
  static const boughtPlayerSkinsKey = "BOUGHT_PLAYER_SKINS";
  static const pointsKey = "POINTS";
  static const plateAssetKey = "PLATE_ASSET";

  Future<void> setPremium() async {
    await _prefs.setBool(premiumKey, true);
  }

  bool isPremium() {
    return _prefs.getBool(premiumKey) ?? false;
  }

  Future<void> setPoints(int points) async {
    await _prefs.setInt(pointsKey, points);
  }

  int getPoints() {
    return _prefs.getInt(pointsKey) ?? 1000;
  }

  Future<void> setPlayerSkin(String value) async {
    await _prefs.setString(selectedPlayerSkinKey, value);
  }

  String getPlayerSkin() {
    return _prefs.getString(selectedPlayerSkinKey) ?? playerSkins[0].asset;
  }

  Future<void> setBackgroundSkin(String value) async {
    await _prefs.setString(selectedBackgroundSkinKey, value);
  }

  String getBackgroundSkin() {
    return _prefs.getString(selectedBackgroundSkinKey) ??
        backgroundSkins[0].asset;
  }

  Future<void> setPlateAsset(String value) async {
    await _prefs.setString(plateAssetKey, value);
  }

  String getPlateAsset() {
    return _prefs.getString(plateAssetKey) ??
        backgroundSkins[0].plateAsset;
  }

  Future<void> setPlayerSkins(List<String> items) async {
    await _prefs.setStringList(boughtPlayerSkinsKey, items);
  }

  List<String> getPlayerSkins() {
    return _prefs.getStringList(boughtPlayerSkinsKey) ?? [playerSkins[0].asset];
  }

  Future<void> setBackgroundSkins(List<String> items) async {
    await _prefs.setStringList(boughtBackgroundSkinsKey, items);
  }

  List<String> getBackgroundSkins() {
    return _prefs.getStringList(boughtBackgroundSkinsKey) ??
        [backgroundSkins[0].asset];
  }
}
