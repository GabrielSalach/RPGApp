abstract interface class ICharacterRepository {
    Future<String> Name();
    Future<String> Backstory();
    Future<String> ImageURL();
    Future<int> HitPoints();
    Future<int> Level();
    Future<int> Experience();
    Future<int> Mana();
    Future<int> Constitution();
    Future<int> Strength();
    Future<int> Agility();
    Future<int> Perception();
    Future<int> Intelligence();
    Future<int> Charisma();
}


class FakeCharacterRepository implements ICharacterRepository {
  @override
  Future<String> Name() async => "Test Hero";

  @override
  Future<String> Backstory() async =>
      "Un guerrier légendaire qui a sauvé le royaume des ténèbres.";

  @override
  Future<String> ImageURL() async =>
      "https://cdn-icons-png.flaticon.com/512/2332/2332589.png";

  @override
  Future<int> HitPoints() async => 100;

  @override
  Future<int> Level() async => 10;

  @override
  Future<int> Experience() async => 5000;

  @override
  Future<int> Mana() async => 50;

  @override
  Future<int> Constitution() async => 15;

  @override
  Future<int> Strength() async => 18;

  @override
  Future<int> Agility() async => 12;

  @override
  Future<int> Perception() async => 14;

  @override
  Future<int> Intelligence() async => 16;

  @override
  Future<int> Charisma() async => 13;
}
