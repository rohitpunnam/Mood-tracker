import 'package:flutter/material.dart';

void main() {
  runApp(const MoodTracker());
}

class MoodTracker extends StatelessWidget {
  const MoodTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MoodPage(),
    );
  }
}

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  String selectedMood = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 30),

            const Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                moodButton("😊", "Happy"),

                moodButton("🙂", "Good"),

                moodButton("😐", "Okay"),

                moodButton("😔", "Sad"),

                moodButton("😡", "Angry"),
              ],
            ),

            const SizedBox(height: 50),

            Text(
              selectedMood.isEmpty
                  ? "No mood selected"
                  : "Today's mood: $selectedMood",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: selectedMood.isEmpty
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mood saved!"),
                        ),
                      );
                    },
              child: const Text("Save Mood"),
            ),
          ],
        ),
      ),
    );
  }

  Widget moodButton(String emoji, String mood) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMood = mood;
        });
      },

      child: Column(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 35),
          ),

          const SizedBox(height: 5),

          Text(mood),
        ],
      ),
    );
  }
}