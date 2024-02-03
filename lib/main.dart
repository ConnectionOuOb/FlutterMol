import 'config.dart';
import 'object.dart';
import 'storage.dart';
import 'data/test_data.dart';
import 'geometry/draw.dart';
import 'package:flutter/material.dart';

late List<StructureController> controllers;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await clearLocalStoragePDB(testName);
  await saveLocalStoragePDB(testName, testData);
  await loadLocalStoragePDB(testName).then((value) => controllers = value);

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
      appBar: AppBar(
        title: const Text('FlutterMol'),
      ),
      body: Point3dView(
        controllers: controllers,
        width: size.width,
        height: size.height,
        scaleFactor: setting.scale,
      ),
      drawer: editList(),
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
                children: [
                  Row(
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
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (var e in controllers) {
                          e.visible = true;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Show all structure", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        for (var e in controllers) {
                          e.visible = true;
                          e.showType = 0;
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text("Reset", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
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

  Widget editList() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.blue,
            alignment: Alignment.center,
            child: const Text('Setting', style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
          controllers.isEmpty
              ? const ListTile(title: Text('No PDB data'))
              : Column(
                  children: controllers
                      .map(
                        (e) => Container(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              ExpansionTile(
                                title: Text(e.name, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                                children: [
                                  ListTile(
                                    title: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          e.visible = !e.visible;
                                        });
                                      },
                                      child: e.visible ? const Text('Hide structure') : const Text('Show structure'),
                                    ),
                                  ),
                                  ExpansionTile(
                                    title: const Text("Color theme", style: TextStyle(fontSize: 15.0)),
                                    children: colorSS
                                        .asMap()
                                        .entries
                                        .map(
                                          (ss) => ListTile(
                                            title: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  e.showType = ss.key;
                                                });
                                              },
                                              child: Text(ss.value.name, style: const TextStyle(fontSize: 15.0)),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}
