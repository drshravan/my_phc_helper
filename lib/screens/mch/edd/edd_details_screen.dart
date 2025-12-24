import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:my_phc_helper/data/database/database.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:my_phc_helper/utils/app_colors.dart';
import 'package:intl/intl.dart';

class EddDetailsScreen extends StatefulWidget {
  final AncRecord record;
  const EddDetailsScreen({super.key, required this.record});

  @override
  State<EddDetailsScreen> createState() => _EddDetailsScreenState();
}

class _EddDetailsScreenState extends State<EddDetailsScreen> {
  // Controllers and State
  bool isEditing = false;

  // Calculate completion percentage based on filled fields
  double get completionPercentage {
    int total = 10; // Key fields
    int filled = 0;
    if (widget.record.name?.isNotEmpty == true) filled++;
    if (widget.record.contactNumber?.isNotEmpty == true) filled++;
    if (widget.record.lmp != null) filled++;
    if (widget.record.edd != null) filled++;
    if (widget.record.village?.isNotEmpty == true) filled++;
    if (widget.record.age != null) filled++;
    if (widget.record.gravida != null) filled++;
    if (widget.record.ashaName?.isNotEmpty == true) filled++;
    if (widget.record.status == 'Delivered') {
      if (widget.record.deliveryDate != null) filled++;
      if (widget.record.deliveryMode?.isNotEmpty == true) filled++;
    } else {
      filled += 2; // Bonus if not delivered yet but other fields done
    }

    // Cap at 1.0
    double val = filled / total;
    return val > 1.0 ? 1.0 : val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.record.name ?? "Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() => isEditing = !isEditing);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCompletionIndicator(),
            const SizedBox(height: 24),
            _buildSectionHeader("Basic Info"),
            _buildInfoRow("ANC ID", widget.record.ancId),
            _buildInfoRow("Village", widget.record.village),
            _buildInfoRow("SubCentre", widget.record.subCentre),
            _buildInfoRow("Contact", widget.record.contactNumber),
            const Divider(),
            _buildSectionHeader("Medical Info"),
            _buildInfoRow(
              "LMP",
              widget.record.lmp != null
                  ? DateFormat('dd-MM-yyyy').format(widget.record.lmp!)
                  : '-',
            ),
            _buildInfoRow(
              "EDD",
              widget.record.edd != null
                  ? DateFormat('dd-MM-yyyy').format(widget.record.edd!)
                  : '-',
            ),
            _buildInfoRow("Gravida", widget.record.gravida?.toString()),
            _buildInfoRow("High Risk", widget.record.highRiskCause),
            const Divider(),
            _buildSectionHeader("Delivery Status"),
            _buildInfoRow("Status", widget.record.status),
            if (widget.record.status == 'Delivered') ...[
              _buildInfoRow("Date", widget.record.deliveryDate?.toString()),
              _buildInfoRow("Mode", widget.record.deliveryMode),
              _buildInfoRow("Place", widget.record.deliveryAddress),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile Completion",
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearPercentIndicator(
          lineHeight: 14.0,
          percent: completionPercentage,
          center: Text(
            "${(completionPercentage * 100).toInt()}%",
            style: const TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          barRadius: const Radius.circular(7),
          backgroundColor: Colors.grey[300],
          progressColor: AppColors.primary,
          animation: true,
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.secondary,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
