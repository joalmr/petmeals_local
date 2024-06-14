import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petmeals_local/src/features/pet/presentation/provider/pet_provider.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/home/widgets/stream_pet.home.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription subscription;

  @override
  void initState() {
    final petProvider = context.read<PetProvider>();
    subscription = petProvider.loadStream().listen((value) {
      if (value.isNotEmpty) {
        petProvider.runPet(value.first);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> _pullRefresh() async {
    final petProvider = context.read<PetProvider>();
    petProvider.loadStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: const SafeArea(
          child: Column(
            children: [
              // SaludoWidget(),
              SizedBox(height: 12),
              StreamPetWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
