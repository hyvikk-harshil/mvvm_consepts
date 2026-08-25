import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm_consepts/features/store/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../viewmodels/delete_product_viewmodel.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final productViewModel = context.watch<ProductViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProductViewModel>().loadProduct(),
          ),
        ],
      ),

      body: _buildBody(productViewModel),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          context.push('/add_product');
        },
        shape: BeveledRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(25))),
        child: Text("add",style: TextStyle(fontSize: 10),),),
    ); 
  }

  Widget _buildBody(ProductViewModel productViewModel){
    if(productViewModel.isLoading) {
      ///Shimmer Skeleton
      return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        final product = productViewModel.product[index];
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: Image.network(
              product.image,
              width: 50,
              errorBuilder: (_, _, child) => const Icon(Icons.error),
            ),
            title: Text(product.title),
            subtitle: Text(product.price.toString()),
            trailing: const Icon(Icons.delete, color: Colors.white),
          ),
        );
      },
    );
    }
    if(productViewModel.errorMessage.isNotEmpty) return Center(child: Text(productViewModel.errorMessage),);

    return ListView.builder(
        itemCount: productViewModel.product.length,
        itemBuilder: (context, index){
          final product = productViewModel.product[index];
          return ListTile(
            trailing:
            // IconButton(
            //     onPressed: (){
            //       context.push('/edit/${product.id}', extra: product,);
            //     },
            //     icon: Icon(Icons.edit,size: 15,)
            // ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Delete Product?'),
                    content: const Text('Are you sure you want to remove this item?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext); // Close the dialog box container
                          context.read<DeleteProductViewmodel>().removeProduct(product.id);
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            leading: Hero(
              tag: 'product-image-${product.id}',
              child: Image.network(
                product.image,
                width: 50,
                errorBuilder: (_, _, child) => const Icon(Icons.error),
              ),
            ),
            title: Text(product.title),
            subtitle: Text('₹${product.price}'),
            onTap: () {
              context.push('/detail/${product.id}');
            },
          );
        }
    );
   }
}