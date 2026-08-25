import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../viewmodels/transaction_viewmodel.dart';

class TransactionView extends StatefulWidget {
  const TransactionView({super.key});
  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://flutter.dev'),
      );
  }

  @override
  Widget build(BuildContext context) {
    final financeProvider = context.watch<TransactionViewModel>();
    return Scaffold(
      body: Center(
        child: financeProvider.isLoading
            ?CircularProgressIndicator()
            :Column(
          mainAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Card(
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Balance: \$${financeProvider.totalBalance.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: IconButton.outlined(
                      onPressed: (){
                        context.push("/add_transaction");
                      },
                      icon: Icon(Icons.add_task,color: Colors.green.shade800,)),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: financeProvider.transaction.length,
                itemBuilder:(context, index) {
                  final tx = financeProvider.transaction[index];
                  return Dismissible(
                    key: ValueKey(tx),
                    background: Card(
                        color: Colors.red[100]),
                    onDismissed: (direction) {
                      financeProvider.removeTransaction(tx.id);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        color: Colors.blue.shade100,
                        //clipBehavior: .hardEdge,
                        shadowColor: Colors.indigo,
                        child: InkWell(
                          onTap: (){},
                          child: ListTile(
                            title: Text(tx.title),
                            trailing: Text('${tx.isExpence ? "-" : "+"}\$${tx.amount.toStringAsFixed(2)}',
                              style: TextStyle(color: tx.isExpence?Colors.red:Colors.green),),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}