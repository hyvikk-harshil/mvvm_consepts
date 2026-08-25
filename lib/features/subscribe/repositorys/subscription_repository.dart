class SubscriptionRepository {
  Future<void> subscribe() async {
    // Simulate a network request
    await Future.delayed(const Duration(seconds: 2));
    // Fail after one second
    throw Exception('Failed to subscribe');
  }
}