import 'package:flutter/material.dart';

import '../../data/models/anc_record_model.dart';

import '../../widgets/beneficiary_card.dart';

class SubCenterBeneficiaryList extends StatefulWidget {
  final String subCenterName;
  final List<AncRecordModel>? records; // Optional pre-loaded records

  const SubCenterBeneficiaryList({
    super.key, 
    required this.subCenterName,
    this.records,
  });

  @override
  State<SubCenterBeneficiaryList> createState() => _SubCenterBeneficiaryListState();
}

class _SubCenterBeneficiaryListState extends State<SubCenterBeneficiaryList> {
  late Future<List<AncRecordModel>> _beneficiariesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.records != null) {
      _beneficiariesFuture = Future.value(widget.records!);
    } else {
      // NOTE: We haven't implemented getBeneficiariesBySubCenter in FirestoreRepository yet.
      // For now, we assume records are passed in (which MonthDetailsScreen does).
      // If we need standalone lookup, we should add it to repo.
      _beneficiariesFuture = Future.value([]); // Placeholder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.subCenterName),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<AncRecordModel>>(
        future: _beneficiariesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          
          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text("No beneficiaries found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return BeneficiaryCard(record: list[index]);
            },
          );
        },
      ),
    );
  }
}
