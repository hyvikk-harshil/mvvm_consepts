import 'package:flutter/material.dart';
import '../repositorys/subscription_repository.dart';

/// Handles the subscribe action and exposes the state to the subscription.
class SubscribeButtonViewModel extends ChangeNotifier {
  SubscribeButtonViewModel({required this.subscriptionRepository});

  final SubscriptionRepository subscriptionRepository;

  // Whether the user is subscribed
  bool subscribed = false;
  // Whether the subscription action has failed
  bool error = false;

  // Subscription action
  Future<void> subscribe() async {
    // Ignore taps when subscribed
    if (subscribed) {
      return;
    }

    // Optimistic state.
    // It will be reverted if the subscription fails.
    subscribed = true;
    // Notify listeners to update the UI
    notifyListeners();

    try {
      await subscriptionRepository.subscribe();
    } catch (e) {
      // Revert to the previous state
      subscribed = false;
      // Set the error state
      error = true;
    } finally {
      notifyListeners();
    }
  }
}