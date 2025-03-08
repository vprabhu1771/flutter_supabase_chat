import 'package:flutter/material.dart';
import 'package:flutter_supabase_chat/widgets/CustomDrawer.dart';


class HomeScreen extends StatefulWidget {

  final String title;

  const HomeScreen({super.key, required this.title});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: CustomDrawer(parentContext: context),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}