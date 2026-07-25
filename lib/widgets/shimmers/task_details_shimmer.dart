import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TaskDetailsShimmer extends StatelessWidget {
  const TaskDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 80, height: 30, color: Colors.white),
                Container(width: 100, height: 30, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),
            Container(width: double.infinity, height: 40, color: Colors.white),
            const SizedBox(height: 12),
            Container(width: double.infinity, height: 100, color: Colors.white),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(width: 40, height: 40, color: Colors.white),
                  const SizedBox(width: 15),
                  Container(width: 150, height: 20, color: Colors.white),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
