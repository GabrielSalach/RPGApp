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
  });

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

  @override
  void initState() {
    super.initState();
    _characterFuture = Character.fromRepository(widget.repository);
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
                Center(
                  child: Column(
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
                      const SizedBox(height: 16),
                      Text(
                        character.name,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Niveau ${character.level}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Barres de progression
                _buildProgressBar('PV', character.hitPoints, 100, Colors.red),
                const SizedBox(height: 8),
                _buildProgressBar('Mana', character.mana, 100, Colors.blue),
                const SizedBox(height: 8),
                _buildProgressBar('Expérience', character.experience, 10000, Colors.green),

                const SizedBox(height: 24),

                // Attributs
                Text(
                  'Attributs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                _buildStatRow('Force', character.strength),
                _buildStatRow('Constitution', character.constitution),
                _buildStatRow('Agilité', character.agility),
                _buildStatRow('Perception', character.perception),
                _buildStatRow('Intelligence', character.intelligence),
                _buildStatRow('Charisme', character.charisma),

                const SizedBox(height: 24),

                // Histoire
                Text(
                  'Histoire',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  character.backstory,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
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
}