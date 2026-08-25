import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/add_product_viewmodel.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController(text: 'https://static.vecteezy.com/system/resources/thumbnails/054/876/032/small/mirror-image-snow-capped-mountain-peaks-reflected-in-pristine-lake-free-photo.jpg');
  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AddProductViewModel>(
        builder: (BuildContext context, viewModel , Widget? child) {
          if (viewModel.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Product added successfully!')),
              );
              Navigator.pop(context); // Go back home after creation
            });
          }

          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
          children: [
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          TextField(controller: _imageController, decoration: const InputDecoration(labelText: 'Image URI')),
          const SizedBox(height: 30),
          if (viewModel.errorMessage.isNotEmpty)
          Text(viewModel.errorMessage, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 10),
          viewModel.isSubmitting
          ? const CircularProgressIndicator()
              : ElevatedButton(
          onPressed: () {
          final title = _titleController.text;
          final price = double.tryParse(_priceController.text) ?? 0.0;
          final img = _imageController.text;

          context.read<AddProductViewModel>().submitProduct(title, price, img);
          },
          child: const Text('Submit Product'),
          ),
          ],
          ));
        },),
    );
  }
}
