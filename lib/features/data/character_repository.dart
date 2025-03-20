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
      "Un guerrier légendaire qui a sauvé le royaume des ténèbres. ET QUI FAIT UN GROS CACA";

  @override
  Future<String> ImageURL() async =>
      "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/34f536ea-ac3a-4186-abd6-1fd58c9d1a9c/dhg19pn-d7de4e72-690a-4e27-99c1-5dec32ed9ac3.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcLzM0ZjUzNmVhLWFjM2EtNDE4Ni1hYmQ2LTFmZDU4YzlkMWE5Y1wvZGhnMTlwbi1kN2RlNGU3Mi02OTBhLTRlMjctOTljMS01ZGVjMzJlZDlhYzMucG5nIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.6KU40LNnYmwbX98DmMK5KtQLu1VBCsOSZTZCKLySMBg";

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
