import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

Widget buildCalendarShimmer() {
  return SingleChildScrollView(
    child: Column(
      children: [
        // Calendar shimmer
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Shimmer.fromColors(
            baseColor: grey,
            highlightColor: grey.withOpacity(0.3),
            child: Container(
              height: 350,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Header
                  Container(height: 40, color: Colors.white.withOpacity(0.1)),
                  const SizedBox(height: 16),
                  // Calendar grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: 35,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Events list shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: grey,
                highlightColor: grey.withOpacity(0.3),
                child: Container(
                  height: 20,
                  width: 200,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(3, (index) => _buildEventShimmerCard()),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    ),
  );
}

Widget buildTodayShimmer() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        const SizedBox(height: 16),
        ...List.generate(5, (index) => _buildReminderShimmerCard()),
        const SizedBox(height: 100),
      ],
    ),
  );
}

Widget _buildEventShimmerCard() {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Shimmer.fromColors(
      baseColor: grey,
      highlightColor: grey.withOpacity(0.3),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: 100,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildReminderShimmerCard() {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Shimmer.fromColors(
      baseColor: grey,
      highlightColor: grey.withOpacity(0.3),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: 60,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ],
              ),
            ),
            Container(
              width: 60,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
