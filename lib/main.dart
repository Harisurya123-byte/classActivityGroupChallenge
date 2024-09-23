import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  String mood = "Neutral";
  Color petColor = Colors.yellow;
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Automatically increase hunger every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      _autoIncreaseHunger();
      _checkWinLossConditions();
    });
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetColor();
      _updateMood();
      _checkWinLossConditions();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetColor();
      _updateMood();
      _checkWinLossConditions();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel >= 100) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }

  // Auto increase hunger every 30 seconds
  void _autoIncreaseHunger() {
    setState(() {
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      if (hungerLevel >= 100) {
        happinessLevel = (happinessLevel - 20).clamp(0, 100);
      }
    });
  }

  // Change pet color based on happiness level
  void _updatePetColor() {
    if (happinessLevel > 70) {
      petColor = Colors.green;  // Happy
    } else if (happinessLevel >= 30) {
      petColor = Colors.yellow; // Neutral
    } else {
      petColor = Colors.red;    // Unhappy
    }
  }

  // Update pet mood based on happiness level
  void _updateMood() {
    if (happinessLevel > 70) {
      mood = "Happy 😊";
    } else if (happinessLevel >= 30) {
      mood = "Neutral 😐";
    } else {
      mood = "Unhappy 😔";
    }
  }

  // Set a custom name for the pet
  void _setPetName() {
    setState(() {
      petName = nameController.text;
    });
  }

  // Check win/loss conditions
  void _checkWinLossConditions() {
    if (happinessLevel >= 80) {
      // Win if happiness stays above 80 for 3 minutes
      Future.delayed(Duration(minutes: 3), () {
        if (happinessLevel >= 80) {
          _showWinDialog();
        }
      });
    } else if (hungerLevel >= 100 && happinessLevel <= 10) {
      // Game over if hunger is 100 and happiness is 10
      _showGameOverDialog();
    }
  }

  // Show win dialog
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('You Win!'),
        content: Text('Your pet is very happy!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your pet is unhappy and hungry!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Pet name input field
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter Pet Name'),
            ),
            ElevatedButton(
              onPressed: _setPetName,
              child: Text('Set Pet Name'),
            ),
            SizedBox(height: 16.0),

            // Display pet's name
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),

            // Display happiness level
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),

            // Display hunger level
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),

            // Display pet's mood
            Text(
              'Mood: $mood',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 32.0),

            // Play button
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),

            // Feed button
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
