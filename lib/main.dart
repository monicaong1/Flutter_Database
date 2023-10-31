import 'package:database_flutter/create.dart';
import 'package:database_flutter/update.dart';
import 'package:flutter/material.dart';
import 'database_instance.dart';
import 'product_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter SqlFlite'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseInstance databaseInstance = DatabaseInstance();

  Future initDatabase() async {
    await databaseInstance.database;
    setState(() {});
  }

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    databaseInstance = DatabaseInstance();
    initDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const CreateScreen();
                })).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: RefreshIndicator(
            onRefresh: _refreshData,
            // ignore: unnecessary_null_comparison
            child: databaseInstance != null
                ? FutureBuilder<List<ProductModel>>(
                    future: databaseInstance.all(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text("Tidak Ada Data"),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title:
                                  Text(snapshot.data![index].name.toString()),
                              subtitle: Text(
                                  snapshot.data![index].category.toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (builder) {
                                        return updateScreen(
                                            productModel:
                                                snapshot.data![index]);
                                      })).then((value) {
                                        setState(() {});
                                      });
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      databaseInstance
                                          .delete(snapshot.data![index].id!);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
                : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  )));
  }
}
