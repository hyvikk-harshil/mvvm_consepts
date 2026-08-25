import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/viewmodels/update_product_viewmodel.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';

class ProductUpdateScreen extends StatefulWidget {
  final ProductModel productToEdit;
  const ProductUpdateScreen({super.key, required this.productToEdit});
  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  late TextEditingController _titleConteroller;
  late TextEditingController _priceController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleConteroller = TextEditingController(text: widget.productToEdit.title);
    _priceController = TextEditingController(text: widget.productToEdit.price.toString());
    _imageController = TextEditingController(text: widget.productToEdit.image);
  }
  @override
  void dispose() {
  _titleConteroller.dispose();
  _priceController.dispose();
  _imageController.dispose();
   super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Existing product'),),
      body: Consumer<UpdateProductViewmodel>(
        builder: (context, vm, _) {
          if (vm.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop();
            });
          }

          // Your existing UI code stays exactly the same below...
          return Padding(
            padding: const EdgeInsets.all(16.0), // Added padding for better look
            child: Column(
              children: [
                TextField(controller: _titleConteroller, decoration: const InputDecoration(labelText: 'product title'),),
                TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'product price'), keyboardType: TextInputType.number,),
                TextField(controller: _imageController, decoration: const InputDecoration(labelText: 'image URL'),),
                const SizedBox(height: 30,),
                if(vm.errorMessage.isNotEmpty) Text(vm.errorMessage, style: const TextStyle(color: Colors.red),),
                const SizedBox(height: 10,),
                vm.isUpdating
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    final title = _titleConteroller.text;
                    final price = double.tryParse(_priceController.text) ?? 0.0;
                    final img = _imageController.text;

                    context.read<UpdateProductViewmodel>().modifyProduct(widget.productToEdit.id, title, price, img);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
