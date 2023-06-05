import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class createTweetScreen extends ConsumerStatefulWidget {
  const createTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _createTweetScreenState();
}

class _createTweetScreenState extends ConsumerState<createTweetScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // body: ,
    );
  }
}