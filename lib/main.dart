import 'setting.dart';
import 'storage.dart';
import 'data/query.dart';
import 'data/subject.dart';
import 'geometry/point.dart';
import 'geometry/controller.dart';
import 'package:flutter/material.dart';

Setting setting = Setting(4.5, 1.5);
late List<StructureController> controllers;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await clearLocalStoragePDB();
  await saveLocalStoragePDB(query, subject);
  await loadLocalStoragePDB().then((value) => controllers = value);

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
        controllers: controllers,
        width: size.width,
        height: size.height,
        scaleFactor: setting.scale,
      ),
      bottomNavigationBar: BottomAppBar(height: 60, child: controlBar()),
    );
  }

  Widget controlBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (setting.scale > setting.ratio) {
                setting.scale -= setting.ratio;
              }
            });
          },
          icon: Icon(Icons.zoom_out, color: setting.scale > setting.ratio ? Colors.black : Colors.grey),
        ),
        controllers.isEmpty
            ? const Text('No PDB data')
            : Row(
                children: controllers
                    .map(
                      (e) => TextButton(
                        onPressed: () {
                          setState(() {
                            e.visible = !e.visible;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: e.visible ? Colors.white : Colors.grey,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(e.name, style: const TextStyle(color: Colors.black)),
                        ),
                      ),
                    )
                    .toList(),
              ),
        IconButton(
          onPressed: () {
            setState(() {
              setting.scale += setting.ratio;
            });
          },
          icon: const Icon(Icons.zoom_in),
        ),
      ],
    );
  }
}
