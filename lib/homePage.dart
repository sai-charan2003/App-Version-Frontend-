 // Ensure correct import
import 'package:app_version_api/base_client.dart';
import 'package:app_version_api/components/data.dart';
import 'package:flutter/material.dart';
import 'package:glossy/glossy.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  var baseClient = BaseClient();  // Corrected naming to match convention

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: FutureBuilder<List<Data>>(
                future: baseClient.getData('69ecb401-8970-4c5c-a359-c4421dcc55ca'),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator()); // Show loading indicator
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {                    
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var dataItem = snapshot.data![index];
                          return GlossyContainer(
                            height: 200,
                            width: 250,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(dataItem.appName ?? 'No Name'),
                                // Add more widgets to display other Data fields if needed
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No data found'));
                    }
                  } else {
                    return Center(child: Text('Unexpected error'));
                  }
                },
              ),
            ),
            Expanded(
              child: Container(
                child: const Center(
                  child: Text(
                    'body',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedWidget(int index) {
    switch (index) {
      case 0:
        return const Text("Messages");
      case 1:
        return const Text("Profile");
      default:
        return const Text("Test");
    }
  }
}

const primaryColor = Color(0xFF685BFF);
const canvasColor = Color(0xFF2E2E48);
const scaffoldBackgroundColor = Color(0xFF464667);
const accentCanvasColor = Color(0xFF3E3E61);
const white = Colors.white;
final actionColor = const Color(0xFF5F5FA7).withOpacity(0.6);

final divider = Divider(color: white.withOpacity(0.3), height: 1);
