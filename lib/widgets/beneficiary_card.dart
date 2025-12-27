import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/anc_record_model.dart';
import '../utils/app_colors.dart';
import '../widgets/neumorphic_container.dart';
import '../screens/mch/edit_record_screen.dart';

class BeneficiaryCard extends StatelessWidget {
  final AncRecordModel record;

  const BeneficiaryCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    // Check completeness
    final missingFields = _getMissingFields();
    final isComplete = missingFields.isEmpty;

    return NeumorphicContainer(
      margin: const EdgeInsets.only(bottom: 16),
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(16),
      onTap: () => Get.to(() => EditRecordScreen(record: record)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeumorphicContainer(
                padding: const EdgeInsets.all(10),
                boxShape: BoxShape.circle,
                child: Icon(
                  Icons.person,
                  color: isComplete ? AppColors.primary : AppColors.warning,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.name ?? "Unknown Name",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "Husband: ${record.husbandName ?? 'N/A'}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "G${record.gravida ?? '?'} • ${record.previousDeliveryMode ?? 'Unknown Prev Mode'}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
               // Call Button
              if (record.contactNumber != null && record.contactNumber!.isNotEmpty)
                IconButton(
                  onPressed: () => _launchCaller(record.contactNumber!),
                  icon: const Icon(Icons.phone, color: AppColors.success),
                ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     const Text("ASHA Worker", style: TextStyle(fontSize: 12, color: Colors.grey)),
                     Text(
                       record.ashaName ?? "Unknown", 
                       style: const TextStyle(fontWeight: FontWeight.w600),
                     ),
                  ],
                ),
              ),
              if (record.ashaContact != null && record.ashaContact!.isNotEmpty)
                 NeumorphicContainer(
                   onTap: () => _launchCaller(record.ashaContact!),
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                   borderRadius: BorderRadius.circular(8),
                   child: const Row(
                     children: [
                       Icon(Icons.call, size: 16, color: AppColors.primary),
                       SizedBox(width: 8),
                       Text("Call ASHA", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                     ],
                   ),
                 ),
            ],
          ),
          
          if (!isComplete) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, size: 16, color: AppColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Missing: ${missingFields.join(', ')}",
                      style: const TextStyle(color: AppColors.error, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<String> _getMissingFields() {
    List<String> missing = [];
    if (record.village == null || record.village!.isEmpty) missing.add("Village");
    if (record.contactNumber == null || record.contactNumber!.isEmpty) missing.add("Phone");
    if (record.husbandName == null || record.husbandName!.isEmpty) missing.add("Husband");
    if (record.ashaContact == null || record.ashaContact!.isEmpty) missing.add("ASHA Phone");
    if (record.gravida == null) missing.add("Gravida");
    return missing;
  }

  Future<void> _launchCaller(String number) async {
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }
}
