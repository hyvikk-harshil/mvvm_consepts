import 'package:flutter/material.dart';
import 'package:mvvm_consepts/const/global_widgets/custom_gradient_appbar.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaction_viewmodel.dart';

class AddTransaction extends StatelessWidget {
  const AddTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final financeProvider = context.watch<TransactionViewModel>();
    TextEditingController titleController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    bool isCredit = false;
    return Scaffold(
      appBar: CustomGradientAppBar(title: "Add Transaction"),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 10,
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            SizedBox(
              height: 50,
            ),
            TextField(
              controller: titleController,
                decoration: InputDecoration(
                    hintText: "Transaction",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none
                    ),
                    fillColor: Colors.blue.withValues(alpha: 0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.auto_graph_outlined))
            ),
            //SizedBox(height: 5,),
            TextField(
              controller: priceController,
                decoration: InputDecoration(
                    hintText: "Amount",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none
                    ),
                    fillColor: Colors.blue.withValues(alpha: 0.1),
                    filled: true,
                    prefixIcon: const Icon(Icons.attach_money_rounded))
            ),
            SizedBox(height: 5,),
            Row(
              children: [
                IconButton.filledTonal(
                    onPressed: (){
                  isCredit = false;
                }, icon: Icon(Icons.add)),
                IconButton.filledTonal(onPressed: (){
                  isCredit = true;
                }, icon: Icon(Icons.remove)),
              ],
            ),

            SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue.shade300,
                ),
                onPressed: () async {
                    await financeProvider.addTransaction(titleController.text, double.parse(priceController.text), isCredit);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text("Enter",style: TextStyle(color: Colors.grey.shade800),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
