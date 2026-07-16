import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfessionalRatingWidget extends StatelessWidget {
  final double rating;
  const ProfessionalRatingWidget({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          rating.toStringAsFixed(1), // يعرض رقم عشري واحد، مثلاً 4.5
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const Gap(3),
        const Icon(Icons.star_rounded, color: Colors.orange, size: 15),
      ],
    );
  }
}
