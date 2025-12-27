import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/anc_record_model.dart';
import '../../../data/repositories/mch_repository.dart';
import '../../../widgets/neumorphic_text_field.dart';
import '../../../widgets/neumorphic_container.dart';
import '../../../utils/app_colors.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _husbandController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _subCenterController = TextEditingController();
  final _gravidaController = TextEditingController();
  final _prevModeController = TextEditingController(); // e.g., Normal/LSCS
  final _ashaNameController = TextEditingController();
  final _ashaPhoneController = TextEditingController();

  DateTime? _selectedLmp;
  DateTime? _calculatedEdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("New ANC Registration"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("Basic Details"),
              NeumorphicTextField(
                controller: _nameController,
                label: "Beneficiary Name",
                validator: (v) => v?.isEmpty == true ? "Required" : null,
              ),
              const SizedBox(height: 16),
              NeumorphicTextField(
                controller: _husbandController,
                label: "Husband Name",
                validator: (v) => v?.isEmpty == true ? "Required" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: NeumorphicTextField(
                      controller: _ageController,
                      label: "Age",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: NeumorphicTextField(
                      controller: _phoneController,
                      label: "Mobile Number",
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              _buildSectionHeader("Location"),
              NeumorphicTextField(
                controller: _villageController,
                label: "Village",
              ),
              const SizedBox(height: 16),
              NeumorphicTextField(
                controller: _subCenterController,
                label: "Sub Centre",
              ),
              const SizedBox(height: 24),

              _buildSectionHeader("Medical Details"),
               // LMP Picker
                // Date Pickers Row (LMP & EDD)
                Row(
                  children: [
                    // LMP Picker
                    Expanded(
                      child: NeumorphicContainer(
                        onTap: _pickLmpDate,
                        padding: const EdgeInsets.all(12),
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text("LMP Date", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedLmp == null 
                                  ? "Select" 
                                  : DateFormat('dd MMM yyyy').format(_selectedLmp!),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // EDD Picker
                    Expanded(
                      child: NeumorphicContainer(
                        onTap: _pickEddDate,
                        padding: const EdgeInsets.all(12),
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.event_available, size: 16, color: Colors.green),
                                const SizedBox(width: 8),
                                Text("EDD Date", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                             const SizedBox(height: 8),
                            Text(
                               _calculatedEdd == null 
                                   ? "Select" 
                                   : DateFormat('dd MMM yyyy').format(_calculatedEdd!),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: NeumorphicTextField(
                      controller: _gravidaController,
                      label: "Gravida (G)",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: NeumorphicTextField(
                      controller: _prevModeController,
                      label: "Prev. Mode",
                      hint: "Normal / LSCS",
                    ),
                  ),
                ],
              ),
               const SizedBox(height: 24),

              _buildSectionHeader("ASHA Worker"),
               NeumorphicTextField(
                controller: _ashaNameController,
                label: "ASHA Name",
              ),
              const SizedBox(height: 16),
              NeumorphicTextField(
                controller: _ashaPhoneController,
                label: "ASHA Contact",
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 40),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 5,
                  ),
                  onPressed: _submitForm,
                  child: const Text("Register ANC", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Future<void> _pickLmpDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedLmp ?? DateTime.now().subtract(const Duration(days: 60)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedLmp = picked;
        _calculatedEdd = picked.add(const Duration(days: 280)); // +9 months 7 days
      });
    }
  }

  Future<void> _pickEddDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _calculatedEdd ?? DateTime.now().add(const Duration(days: 180)),
      firstDate: DateTime.now().subtract(const Duration(days: 280)), // In case previously pregnant
      lastDate: DateTime.now().add(const Duration(days: 300)),
    );

    if (picked != null) {
      setState(() {
        _calculatedEdd = picked;
        _selectedLmp = picked.subtract(const Duration(days: 280)); // Reverse Calc
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedLmp == null) {
        Get.snackbar("Required", "Please select LMP Date", backgroundColor: AppColors.warning);
        return;
      }

      final repo = Get.find<MchRepository>();
      
      final record = AncRecordModel(
        name: _nameController.text,
        husbandName: _husbandController.text,
        contactNumber: _phoneController.text,
        age: int.tryParse(_ageController.text),
        village: _villageController.text,
        subCentre: _subCenterController.text, 
        gravida: int.tryParse(_gravidaController.text),
        previousDeliveryMode: _prevModeController.text,
        ashaName: _ashaNameController.text,
        ashaContact: _ashaPhoneController.text,
        lmp: _selectedLmp,
        edd: _calculatedEdd,
        status: "Registered",
        regDate: DateTime.now(),
      );

      try {
        await repo.addAncRecord(record);
        
        Get.snackbar(
          "Success", 
          "ANC Registered Successfully!",
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
        
        Get.back(); // Return to previous screen
      } catch (e) {
        Get.snackbar("Error", "Failed to register: $e", backgroundColor: AppColors.error, colorText: Colors.white);
      }
    }
  }
}
