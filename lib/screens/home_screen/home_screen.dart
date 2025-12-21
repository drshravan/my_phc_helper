import 'package:flutter/material.dart';
import 'package:my_phc_helper/data/static/static.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to PHC Malkapur'),
        
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Subcenters:", style: TextStyle(fontSize: 20,color: const Color.fromARGB(255, 0, 247, 243), fontWeight: FontWeight.bold),),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: subcenters.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Center(
                      child: Text(subcenters[index]),
                    ),
                  );
                },
                ),
            ),
          ],
        ),
      )
    );
  }
}