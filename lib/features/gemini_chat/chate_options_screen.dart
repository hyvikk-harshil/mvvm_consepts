import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mvvm_consepts/const/global_widgets/drawer/navigation_drawer.dart';
import '../../const/global_widgets/custom_gradient_appbar.dart';

class ChatOptionsScreen extends StatefulWidget {
  const ChatOptionsScreen({super.key});

  @override
  State<ChatOptionsScreen> createState() => _ChatOptionsScreenState();
}

class _ChatOptionsScreenState extends State<ChatOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      appBar: CustomGradientAppBar(title: "Different Chat's"),
      drawer: NavDrawer(),
      body: Expanded(
        child: Column(
          children: [
            SizedBox(height: 5,),
            Text("Gemini Chat's using Google AI Flutter SDK(google_generative_ai)",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.surface),),
            SizedBox(height: 10,),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.all_inclusive, color: Theme.of(context).colorScheme.surface),
                    onPressed: () {
                      // Navigates cleanly out to the standalone Chat Inbox screen
                      context.push("/gemini-chat");
                    },
                  ),
                  Text("  : Single chat log at a time",style: TextStyle(color: Theme.of(context).colorScheme.surface),)
                ],
              ),
            ),
            Card(
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.all_inclusive, color: Theme.of(context).colorScheme.surface),
                    onPressed: () {
                      // Navigates cleanly out to the standalone Chat Inbox screen
                      context.push("/multi-turn-chat-logs");
                    },
                  ),
                  Text("  : Multiple Chat with Gemini Module",style: TextStyle(color: Theme.of(context).colorScheme.surface),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
