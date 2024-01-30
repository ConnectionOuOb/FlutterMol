import 'storage.dart';
import 'data/query.dart';
import 'data/subject.dart';
import 'package:flutter/material.dart';

bool isDebug = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await clearLocalStoragePDB();

  if (isDebug) {
    await saveLocalStoragePDB(query, subject);
  }

  loadLocalStoragePDB();
  runApp(const FlutterMol());
}

class FlutterMol extends StatelessWidget {
  const FlutterMol({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterMol',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
