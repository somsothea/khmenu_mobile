// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'counter_logic.dart';

class AboutStateScreen extends StatelessWidget {
  int _counter = 0;

  AboutStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _counter = context.watch<CounterLogic>().counter;

    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().decrease();
              debugPrint("counter: $_counter");
            },
            icon: Icon(Icons.remove),
          ),
          IconButton(
            onPressed: () {
              context.read<CounterLogic>().increase();
              debugPrint("counter: $_counter");
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(5), // Set margin to 5px
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mission",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                "We offer free digital menu platform for traders, without any hidden fees or complicated contracts. Our goal is to provide a straightforward and cost-effective solution that meets the needs of your business, allowing you to focus on delivering exceptional digital experiences to your customers.",
                textAlign: TextAlign.justify, // Align text to justify
              ),
              SizedBox(height: 20), // Added spacing
              Text(
                "Our Team",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 10),
              _buildTeamCards(), // Call to the new method that builds the team cards
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard(String name, String position, String description,
      String profileImagePath) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 226, 207, 207),
              const Color.fromARGB(255, 155, 144, 144)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(profileImagePath),
              backgroundColor: Colors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    position,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCards() {
    return Column(
      children: [
        _buildTeamCard(
            "Heng Sombo",
            "Developer",
            "Sombo is the visionary behind KH Menu, guiding the requirements.",
            "https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_640.png"),
        _buildTeamCard(
            "Som Sothea",
            "Developer",
            "Sothea drives the development of KH Menu with a keen eye for detail.",
            "https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_640.png"),
      ],
    );
  }
}
