import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/currency_viewmodel.dart';

class CurrencyConvertView extends StatefulWidget {
  const CurrencyConvertView({super.key});
  @override
  State<CurrencyConvertView> createState() => _CurrencyConvertViewState();
}

class _CurrencyConvertViewState extends State<CurrencyConvertView> {
  @override
  void initState(){
    super.initState();
    //Future.microtask(()=>context.read<CurrencyViewModel>().loadExchangeRates());

    // Safe way to reference context immediately after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // Guard check
      context.read<CurrencyViewModel>().loadExchangeRates();
    });
  }
  @override
  Widget build(BuildContext context) {
    //final currencyProvider = context.watch<CurrencyViewModel>();
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.black,
        title: Text("Live currency (USD based)",style: TextStyle(color: Colors.white),),
      ),
      body: Consumer<CurrencyViewModel>(
          builder: (_,currencyPro,child){
            if(currencyPro.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if(currencyPro.errorMessage != null){
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    spacing: 10,
                    mainAxisAlignment: .center,
                    children: [
                      Icon(Icons.warning_amber,size: 30,color: Colors.red,),
                      Text(currencyPro.errorMessage!,style: TextStyle(color: Colors.red),),
                      ElevatedButton.icon(
                          onPressed: (){
                            currencyPro.loadExchangeRates();
                          },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final rates = currencyPro.currencyModelData?.rates??{};
            final currencyKeys = rates.keys.toList();

            return ListView.builder(
                itemCount: currencyKeys.length,
                itemBuilder: (context, index){
                  final currencyCode = currencyKeys[index];
                  final convertedValue = currencyPro.convert(100.0, currencyCode);

                  return ListTile(
                    title: Text("100 USD to $currencyCode"),
                    trailing: Text(convertedValue.toStringAsFixed(2),
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  );
                });
          }
      ),

    );
  }
}
