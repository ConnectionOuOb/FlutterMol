import 'geometry/controller.dart';
import 'geometry/point.dart';
import 'storage.dart';
import 'data/query.dart';
import 'data/subject.dart';
import 'package:flutter/material.dart';

double scale = 8;
bool isDebug = true;
late StructureController controller;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await clearLocalStoragePDB();

  if (isDebug) {
    await saveLocalStoragePDB(query, subject);
  }

  await loadLocalStoragePDB().then((value) => controller = value);
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Point3dView(
        controller: controller,
        width: size.width,
        height: size.height,
        scaleFactor: scale,
      ),
    );
  }
}
