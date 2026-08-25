import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm_consepts/features/subscribe/viewmodels/subscribed_view_model.dart';
import '../repositorys/subscription_repository.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({super.key});
  @override
  Widget build(BuildContext context) {
    List<String> title = ['Map','Banner Ad', 'Interstitial Ad','Rewarded Ad'];
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              SubscribeButton(
                viewModel: SubscribeButtonViewModel(
                  subscriptionRepository: SubscriptionRepository(),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: title.length,
                    itemBuilder: (context,index){
                    return Container(color: Colors.yellow,
                      child: ListTile(
                        trailing: Text(title[index]),
                        onTap: (){
                          if(index==0)context.push('/google_map');
                          if(index==1)context.push('/banner_ad');
                          if(index==2)context.push('/interstitial_ad');
                          if(index==3)context.push('/rewarded_ad');
                        },
                      ),
                    );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class SubscribeButton extends StatefulWidget {
  const SubscribeButton({super.key, required this.viewModel});
  /// Subscribe button view model.
  final SubscribeButtonViewModel viewModel;
  @override
  State<SubscribeButton> createState() => _SubscribeButtonState();
}
class _SubscribeButtonState extends State<SubscribeButton> {

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChange);
    super.dispose();
  }
  /// Listen to ViewModel changes.
  void _onViewModelChange() {
    // If the subscription action has failed
    if (widget.viewModel.error) {
      // Reset the error state
      widget.viewModel.error = false;
      // Show an error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to subscribe')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return FilledButton(
          onPressed: widget.viewModel.subscribe,
          style: widget.viewModel.subscribed
              ? SubscribeButtonStyle.subscribed
              : SubscribeButtonStyle.unsubscribed,
          child: widget.viewModel.subscribed
              ? const Text('Subscribed')
              : const Text('Subscribe'),
        );
      },
    );
  }
}
class SubscribeButtonStyle {
  static const unsubscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.blue),
  );

  static const subscribed = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.green),
  );
}