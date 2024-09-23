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
  int energyLevel = 50;
  String mood = "Neutral";
  Color petColor = Colors.yellow;
  String selectedActivity = 'Rest';
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Automatically increase hunger and decrease energy every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      _autoIncreaseHunger();
      _autoDecreaseEnergy();
      _checkWinLossConditions();
    });
  }

  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updateEnergy(-10);  // Playing decreases energy
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
      _updateEnergy(5);  // Feeding increases energy
      _updatePetColor();
      _updateMood();
      _checkWinLossConditions();
    });
  }

  // Function to handle activity selection
  void _performActivity() {
    setState(() {
      if (selectedActivity == 'Play') {
        _playWithPet();
      } else if (selectedActivity == 'Rest') {
        _updateEnergy(15);  // Resting increases energy
        _updateHappiness();
      } else if (selectedActivity == 'Feed') {
        _feedPet();
      }
      _checkWinLossConditions();
    });
  }

  // Function to update energy based on activity
  void _updateEnergy(int change) {
    energyLevel = (energyLevel + change).clamp(0, 100);
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

  // Auto decrease energy every 30 seconds
  void _autoDecreaseEnergy() {
    setState(() {
      energyLevel = (energyLevel - 5).clamp(0, 100);
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

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Update hunger when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
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
      Future.delayed(Duration(minutes: 3), () {
        if (happinessLevel >= 80) {
          _showWinDialog();
        }
      });
    } else if (hungerLevel >= 100 && happinessLevel <= 10) {
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Pet name input field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Enter Pet Name'),
                ),
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

              // Display energy level (LinearProgressIndicator)
              Text(
                'Energy Level',
                style: TextStyle(fontSize: 20.0),
              ),
              LinearProgressIndicator(
                value: energyLevel / 100,
                minHeight: 20.0,
                backgroundColor: Colors.grey[300],
                color: petColor,
              ),
              SizedBox(height: 32.0),

              // Display pet's mood
              Text(
                'Mood: $mood',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 32.0),

              // Dropdown menu for activity selection
              DropdownButton<String>(
                value: selectedActivity,
                items: <String>['Play', 'Rest', 'Feed'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedActivity = newValue!;
                  });
                },
              ),
              SizedBox(height: 16.0),

              // Perform activity button
              ElevatedButton(
                onPressed: _performActivity,
                child: Text('Perform Activity'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
