import 'package:flutter/material.dart';
import 'package:mvvm_consepts/features/store/viewmodels/product_detail_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }
  void openCheckout(Map<String, dynamic> checkoutOptions) {
    try {
      _razorpay.open(checkoutOptions);
    } catch (e) {
      debugPrint('Razorpay Opening Runtime Crash: $e');
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!mounted) return; // Guard clause to ensure view still exists in context
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Success! ID: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed: ${response.message}"),
        backgroundColor: Colors.red,
      ),
    );
  }
  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductDetailViewModel()..loadProductDetail(widget.productId),
      child: Scaffold(
        appBar: AppBar(elevation: 0),
        body: SafeArea(
          child: Consumer<ProductDetailViewModel>(
            builder: (context, pvm, child) {
              if (pvm.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (pvm.errorMessage.isNotEmpty) {
                return Center(child: Text(pvm.errorMessage));
              }
              if (pvm.product == null) {
                return const Center(child: Text("Product detail not found"));
              }

              final product = pvm.product!;

              return SingleChildScrollView( // Changed from standard Padding Column to prevent overflows
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Left align text professionally
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Hero(
                        tag: 'product-image-${product.id}',
                        child: Image.network(product.image, height: 220, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      product.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 15, color: Colors.black.withValues(alpha: 0.7), height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹${product.price}",
                          style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.w800),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Fetch properties safely parsed through the ViewModel layer
                            final options = pvm.generateRazorpayOptions(product);
                            openCheckout(options);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Pay Now', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
