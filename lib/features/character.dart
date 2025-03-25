import 'package:flutter/material.dart';
import 'data/character_repository.dart';

class Character {
  final String name;
  final String backstory;
  final String imageURL;
  final int hitPoints;
  final int level;
  final int experience;
  final int mana;
  final int constitution;
  final int strength;
  final int agility;
  final int perception;
  final int intelligence;
  final int charisma;

  final int currentHitPoints;
  final int currentMana;

  Character({
    required this.name,
    required this.backstory,
    required this.imageURL,
    required this.hitPoints,
    required this.level,
    required this.experience,
    required this.mana,
    required this.constitution,
    required this.strength,
    required this.agility,
    required this.perception,
    required this.intelligence,
    required this.charisma,
    required this.currentHitPoints,
    required this.currentMana,
  });

  Character copyWith({
    String? name,
    int? strength,
    int? constitution,
    int? agility,
    int? perception,
    int? intelligence,
    int? charisma,
  }) {
    return Character(
      name: name ?? this.name,
      strength: strength ?? this.strength,
      constitution: constitution ?? this.constitution,
      agility: agility ?? this.agility,
      perception: perception ?? this.perception,
      intelligence: intelligence ?? this.intelligence,
      charisma: charisma ?? this.charisma,
      // Ajoute ici les autres propriétés
      backstory: this.backstory,
      imageURL: this.imageURL,
      hitPoints: this.hitPoints,
      level: this.level,
      experience: this.experience,
      mana: this.mana,
      currentHitPoints: this.currentHitPoints,
      currentMana: this.currentMana,
    );
  }


  // Factory constructor pour créer un Character à partir de l'ICharacterRepository
  static Future<Character> fromRepository(ICharacterRepository repository) async {
    return Character(
      name: await repository.Name(),
      backstory: await repository.Backstory(),
      imageURL: await repository.ImageURL(),
      hitPoints: await repository.HitPoints(),
      level: await repository.Level(),
      experience: await repository.Experience(),
      mana: await repository.Mana(),
      constitution: await repository.Constitution(),
      strength: await repository.Strength(),
      agility: await repository.Agility(),
      perception: await repository.Perception(),
      intelligence: await repository.Intelligence(),
      charisma: await repository.Charisma(),
      currentHitPoints: await repository.HitPoints(),
      currentMana: await repository.Mana(),
    );
  }
}

class CharacterWidget extends StatefulWidget {
  final ICharacterRepository repository;

  const CharacterWidget({Key? key, required this.repository}) : super(key: key);

  @override
  State<CharacterWidget> createState() => _CharacterWidgetState();
}

class _CharacterWidgetState extends State<CharacterWidget> {
  late Future<Character> _characterFuture;
  String name = "";
  late TextEditingController _nameController;
  late TextEditingController _backstoryController;
  int strength = 0, constitution = 0, agility = 0, perception = 0, intelligence = 0, charisma = 0;


  @override
  void initState() {
    super.initState();
    _characterFuture = Character.fromRepository(widget.repository);
    _characterFuture.then((character) {
      setState(() {
        name = character.name;
        _nameController = TextEditingController(text: character.name);
        _backstoryController = TextEditingController(text: character.backstory);
        strength = character.strength;
        constitution = character.constitution;
        agility = character.agility;
        perception = character.perception;
        intelligence = character.intelligence;
        charisma = character.charisma;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _backstoryController.dispose();
    super.dispose();
  }

  void _updateStat(String stat, int delta) {setState(() {
      switch (stat) {
        case 'Force':
          strength = (strength + delta).clamp(0, 20); // Empêche d'aller en négatif
          break;
        case 'Constitution':
          constitution = (constitution + delta).clamp(0, 20);
          break;
        case 'Agilité':
          agility = (agility + delta).clamp(0, 20);
          break;
        case 'Perception':
          perception = (perception + delta).clamp(0, 20);
          break;
        case 'Intelligence':
          intelligence = (intelligence + delta).clamp(0, 20);
          break;
        case 'Charisme':
          charisma = (charisma + delta).clamp(0, 20);
          break;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Character>(
      future: _characterFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('Aucune donnée disponible'));
        }

        final character = snapshot.data!;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec image et nom
                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.amber, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(character.imageURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nom du personnage',
                                ),
                                onChanged: (newValue) {
                                  print(newValue);
                                  setState(() {
                                    // Mettre à jour le nom du personnage
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _backstoryController,
                                maxLines: null,
                                decoration : InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Histoire",
                                ),
                                onChanged: (newValue) {
                                  print(newValue);
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),


                Text(
                  'Niveau ${character.level}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // Barres de progression
                _buildProgressBar('PV', character.currentHitPoints, character.hitPoints, Colors.red),
                const SizedBox(height: 8),
                _buildProgressBar('Mana', character.currentMana, character.mana, Colors.blue),
                const SizedBox(height: 8),
                _buildProgressBar('Expérience', character.experience, 10000, Colors.green),

                const SizedBox(height: 24),

                // Attributs
                Text(
                  'Attributs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _buildStat('Force', strength),
                _buildStat('Constitution', constitution),
                _buildStat('Agilité', agility),
                _buildStat('Perception', perception),
                _buildStat('Intelligence', intelligence),
                _buildStat('Charisme', charisma),

                const SizedBox(height: 24),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(String label, int value, int maxValue, Color color) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('$value / $maxValue'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, int value) {
    // Calcul d'une valeur entre 0 et 1 pour l'indicateur
    final normalizedValue = (value / 20).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: LinearProgressIndicator(
              value: normalizedValue,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepPurple, width: 2),
            ),
            child: Center( // Centre le texte dans le cercle
              child: Text(
                '$value',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextButton(onPressed: () => _updateStat(label, 1), child:
                  Text("+")
                ),
                TextButton(onPressed: () => _updateStat(label, -1), child:
                  Text("-")
                )
              ],
            ),
          ),
        ],
      )
    );

  }
}