import 'package:flutter/material.dart';
import 'package:petmeals_local/src/core/app/styles/colors/colors.dart';
import 'package:petmeals_local/src/features/pet/data/models/pet_model.dart';
import 'package:petmeals_local/src/features/pet/presentation/provider/pet_provider.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/detail/history/attentions/deworming.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/detail/history/attentions/grooming.dart';
import 'package:petmeals_local/src/features/pet/presentation/views/detail/history/attentions/vaccine.dart';
import 'package:provider/provider.dart';

class PetHistoryPage extends StatefulWidget {
  const PetHistoryPage({super.key, this.pet});
  final PetModel? pet;

  @override
  State<PetHistoryPage> createState() => _PetHistoryPageState();
}

class _PetHistoryPageState extends State<PetHistoryPage> {
  int segmentView = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final petProvider = context.read<PetProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.pet!.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // PreferredSize(
      //   preferredSize: const Size.fromHeight(60),
      //   child: SafeArea(
      //     child: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         const BackBtn(),
      //         Text(
      //           widget.pet!.name!,
      //           style: const TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(top: 0, left: 24, right: 24),
            height: 32,
            decoration: BoxDecoration(
              color: kTextColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() {
                    segmentView = 0;
                    petProvider.getAttentions(
                      petProvider.pet!.id!,
                    );
                  }),
                  child: Container(
                    height: double.maxFinite,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: segmentView == 0 ? kPrimaryColor : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: const Center(
                      child: Text(
                        "Desparasitación",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kContrastColor,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    segmentView = 1;
                    petProvider.getAttentions(
                      petProvider.pet!.id!,
                    );
                  }),
                  child: Container(
                    height: double.maxFinite,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: segmentView == 1 ? kPrimaryColor : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: const Center(
                      child: Text(
                        "Baño",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kContrastColor,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    segmentView = 2;
                    petProvider.getAttentions(
                      petProvider.pet!.id!,
                    );
                  }),
                  child: Container(
                    height: double.maxFinite,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: segmentView == 2 ? kPrimaryColor : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: const Center(
                      child: Text(
                        "Vacuna",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kContrastColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: segmentView == 0
                ? const DewormingHistory()
                : segmentView == 1
                    ? const GroomingHistory()
                    : const VaccineHistory(),
          ),
        ],
      ),
    );
  }
}
