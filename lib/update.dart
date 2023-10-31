import 'package:flutter/material.dart';
import 'product_model.dart';
import 'database_instance.dart';

class updateScreen extends StatefulWidget {
  const updateScreen({super.key, required this.productModel});

  final ProductModel? productModel;

  @override
  State<updateScreen> createState() => _updateScreenState();
}

class _updateScreenState extends State<updateScreen> {
  DatabaseInstance databaseInstance = DatabaseInstance();
  TextEditingController namaController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseInstance.database;
    namaController.text = widget.productModel!.name!;
    kategoriController.text = widget.productModel!.category!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama Produk'),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Nama Produk',
              ),
              controller: namaController,
            ),
            SizedBox(
              height: 20,
            ),
            Text('Kategori'),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Kategori',
              ),
              controller: kategoriController,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                await databaseInstance.update(widget.productModel!.id!, {
                  'name': namaController.text,
                  'category': kategoriController.text,
                  'updateAt': DateTime.now().toString(),
                });
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
