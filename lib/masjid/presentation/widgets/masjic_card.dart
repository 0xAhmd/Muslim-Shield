import 'package:azkar/masjid/data/models/masjid.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'distance_badge.dart';

class MasjidCard extends StatelessWidget {
  final MasjidModel masjid;
  final String formattedDistance;
  final bool isClosest;
  final VoidCallback onTap;
  final VoidCallback onDirectionsTap;

  const MasjidCard({
    super.key,
    required this.masjid,
    required this.formattedDistance,
    this.isClosest = false,
    required this.onTap,
    required this.onDirectionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: grey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isClosest
                    ? primary.withOpacity(0.3)
                    : primary.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: isClosest
                  ? [
                      BoxShadow(
                        color: primary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with mosque icon and distance
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isClosest
                            ? primary.withOpacity(0.2)
                            : primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.mosque, color: primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (isClosest) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'CLOSEST',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Expanded(
                                child: Text(
                                  masjid.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DistanceBadge(
                      distance: formattedDistance,
                      isClosest: isClosest,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Address (if available)
                if (masjid.address != null && masjid.address!.isNotEmpty) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: textColor.withOpacity(0.7),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          masjid.address!,
                          style: TextStyle(
                            color: textColor.withOpacity(0.9),
                            fontSize: 14,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Coordinates info
                Row(
                  children: [
                    Icon(
                      Icons.my_location,
                      color: textColor.withOpacity(0.7),
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${masjid.latitude.toStringAsFixed(4)}, ${masjid.longitude.toStringAsFixed(4)}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: 'View Location',
                        icon: Icons.map,
                        onTap: onTap,
                        isPrimary: true, // Optional: make it colored
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isPrimary ? primary : background,
            borderRadius: BorderRadius.circular(10),
            border: isPrimary
                ? null
                : Border.all(color: primary.withOpacity(0.3), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isPrimary ? Colors.white : primary, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? Colors.white : primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
