import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/models/anc_record_model.dart';
import '../../data/repositories/mch_repository.dart';
import '../../widgets/neumorphic_text_field.dart';
import '../../widgets/neumorphic_container.dart';
import '../../utils/app_colors.dart';

class EditRecordScreen extends StatefulWidget {
  final AncRecordModel record;

  const EditRecordScreen({super.key, required this.record});

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Controllers (Basic - Read Only)
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _husbandController;
  late TextEditingController _villageController;
  late TextEditingController _subCenterController; // Add this if needed

  // Controllers (History)
  late TextEditingController _pastHospitalNameController;
  late TextEditingController _pastDistrictController;
  late TextEditingController _pastAbortionWeeksController;
  late TextEditingController
  _pastEventDateController; // For Past Delivery/Abortion Date

  // Controllers (Current)
  late TextEditingController _currentDateController;
  late TextEditingController _abortionWeeksController;

  // Controllers (ASHA)
  late TextEditingController _ashaNameController;
  late TextEditingController _ashaPhoneController;

  // Autocomplete
  late TextEditingController _highRiskController;

  // Values
  String? _selectedGravida;
  String? _selectedPrevMode;
  String? _selectedBirthPlan;
  String? _pastHospitalType;
  String? _pastAbortionPlace;
  String? _currentStatus;
  String? _currentHospitalType;
  String? _currentGender;
  String? _currentDeliveryMode;
  String? _currentAbortionPlace;

  // Options
  final List<String> _gravidaOptions = [
    'Primi',
    'G2',
    'G3',
    'G4',
    'Multigravida',
  ];
  final List<String> _deliveryModeOptions = ['Normal', 'LSCS', 'Abortion'];
  final List<String> _birthPlanOptions = ['Ghanpur Station CHC', 'Jangaon MCH'];
  final List<String> _hospitalTypeOptions = ['Government', 'Private'];
  final List<String> _abortionPlaceOptions = ['Government', 'Private', 'Home'];
  final List<String> _statusOptions = ['Pending', 'Delivered', 'Aborted'];
  final List<String> _genderOptions = ['Male', 'Female'];
  final List<String> _highRiskOptions = [
    'Anemia',
    'Previous LSCS',
    'Short Stature',
    'Previous Abortion',
    'Hypertension',
    'Diabetes',
    'Multigravida',
    'Twin Pregnancy',
  ];

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _nameController = TextEditingController(text: widget.record.name);
    _phoneController = TextEditingController(text: widget.record.contactNumber);
    _husbandController = TextEditingController(text: widget.record.husbandName);
    _villageController = TextEditingController(text: widget.record.village);
    _subCenterController = TextEditingController(text: widget.record.subCentre);

    _pastHospitalNameController = TextEditingController(
      text: widget.record.pastHospitalName,
    );
    _pastDistrictController = TextEditingController(
      text: widget.record.pastDistrict,
    );
    _pastAbortionWeeksController = TextEditingController(
      text: widget.record.pastAbortionWeeks?.toString(),
    );
    _pastEventDateController = TextEditingController(
      text: _formatDate(widget.record.pastEventDate),
    );

    _currentDateController = TextEditingController(
      text: widget.record.deliveryDate != null
          ? _formatDate(widget.record.deliveryDate)
          : (widget.record.abortionDate != null
                ? _formatDate(widget.record.abortionDate)
                : ''),
    );
    _abortionWeeksController = TextEditingController(
      text: widget.record.abortionWeeks?.toString(),
    );

    _ashaNameController = TextEditingController(text: widget.record.ashaName);
    _ashaPhoneController = TextEditingController(
      text: widget.record.ashaContact,
    );
    _highRiskController = TextEditingController(
      text: widget.record.highRiskCause,
    );

    _mapDropdowns();
  }

  void _mapDropdowns() {
    _selectedGravida = _matchOption(
      widget.record.gravida?.toString(),
      _gravidaOptions,
    );
    // Fallback logic for Gravida Int -> String
    if (_selectedGravida == null && widget.record.gravida != null) {
      if (widget.record.gravida == 1) {
        _selectedGravida = 'Primi';
      } else if (widget.record.gravida! >= 5)
        _selectedGravida = 'Multigravida';
      else
        _selectedGravida = 'G${widget.record.gravida}';
    }

    _selectedPrevMode = _matchOption(
      widget.record.previousDeliveryMode,
      _deliveryModeOptions,
    );
    _selectedBirthPlan = _matchOption(
      widget.record.birthPlan,
      _birthPlanOptions,
    );
    _pastHospitalType = _matchOption(
      widget.record.pastHospitalType,
      _hospitalTypeOptions,
    );
    _pastAbortionPlace = _matchOption(
      widget.record.pastAbortionPlace,
      _abortionPlaceOptions,
    );

    if (widget.record.status == 'Delivered') {
      _currentStatus = 'Delivered';
    } else if (widget.record.status == 'Aborted')
      _currentStatus = 'Aborted';
    else
      _currentStatus = 'Pending';

    _currentHospitalType = _matchOption(
      widget.record.deliveryHospitalType,
      _hospitalTypeOptions,
    );
    _currentGender = _matchOption(widget.record.babyGender, _genderOptions);
    _currentDeliveryMode = _matchOption(widget.record.deliveryMode, [
      'Normal',
      'LSCS',
    ]);
    _currentAbortionPlace = _matchOption(
      widget.record.abortionPlace,
      _abortionPlaceOptions,
    );
  }

  String? _matchOption(String? value, List<String> options) {
    if (value == null || value.isEmpty) return null;
    final match = options.firstWhereOrNull(
      (opt) => opt.toLowerCase() == value.toLowerCase(),
    );
    return match ?? (options.contains(value) ? value : null);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd-MM-yyyy').format(date);
  }

  DateTime? _parseDate(String dateStr) {
    try {
      return DateFormat('dd-MM-yyyy').parseLoose(dateStr);
    } catch (_) {
      return null;
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = _formatDate(picked);
      });
      // Try to auto-calc weeks if applicable (only simple logic for now, as specific calc wasn't fully defined)
    }
  }

  Future<void> _updateRecord() async {
    // Validate all steps "irrespective of sequence"
    if (!_isBasicValid || !_isHistoryValid || !_isCurrentValid || !_isAshaValid) {
       Get.snackbar(
         "Validation Error", 
         "Please check all steps. Some fields are invalid.",
         backgroundColor: AppColors.error,
         colorText: Colors.white,
       );
       return;
    }

    if (_formKey.currentState!.validate()) {
       final repo = Get.find<MchRepository>();

      int? gravidaInt = int.tryParse(
        _selectedGravida?.replaceAll(RegExp(r'[^0-9]'), '') ?? '',
      );
      if (_selectedGravida == 'Primi') {
        gravidaInt = 1;
      } else if (_selectedGravida == 'Multigravida')
        gravidaInt = 5;

      final currentEventDate = _parseDate(_currentDateController.text);
      final pastEventDate = _parseDate(_pastEventDateController.text);

      // Create updated model manually (since we didn't generate copyWith)
      final updatedRecord = AncRecordModel(
        // ID & Immutable (or ReadOnly)
        id: widget.record.id,
        subCentre: widget.record.subCentre,
        ancId: widget.record.ancId,
        name: widget.record.name,
        contactNumber: widget.record.contactNumber,
        husbandName: widget.record.husbandName,
        village: widget.record.village,
        age: widget.record.age,
        lmp: widget.record.lmp,
        edd: widget.record.edd,
        
        // Editable Fields
        gravida: gravidaInt,
        previousDeliveryMode: _selectedPrevMode,
        highRiskCause: _highRiskController.text,
        birthPlan: _selectedBirthPlan,
        ashaName: _ashaNameController.text,
        ashaContact: _ashaPhoneController.text,
        
        // Past History
        pastHospitalName: _pastHospitalNameController.text,
        pastHospitalType: _pastHospitalType,
        pastDistrict: _pastDistrictController.text,
        pastAbortionPlace: _pastAbortionPlace,
        pastAbortionWeeks: int.tryParse(_pastAbortionWeeksController.text),
        pastEventDate: pastEventDate,
        
        // Current Outcome
        status: _currentStatus ?? 'Pending',
        deliveryHospitalType: _currentHospitalType,
        babyGender: _currentGender,
        deliveryMode: _currentDeliveryMode,
        deliveryDate: _currentStatus == 'Delivered' ? currentEventDate : null,
        abortionDate: _currentStatus == 'Aborted' ? currentEventDate : null,
        abortionWeeks: int.tryParse(_abortionWeeksController.text),
        abortionPlace: _currentAbortionPlace,
        
        // Fields not in form but part of model
        deliveryAddress: widget.record.deliveryAddress, // Maybe should update if delivered?
        district: widget.record.district,
        phcName: widget.record.phcName,
      );

      await repo.addAncRecord(updatedRecord); // Handles update if ID exists
      Get.back();
      Get.snackbar(
        "Success",
        "Record Updated",
        backgroundColor: AppColors.success,
        colorText: Colors.white,
      );
    }
  }

  // Validation Getters
  // Validation Getters
  bool get _isBasicValid =>
      _nameController.text.isNotEmpty &&
      _husbandController.text.isNotEmpty &&
      _villageController.text.isNotEmpty &&
      _phoneController.text.length == 10;

  bool get _isHistoryValid {
    if (_selectedGravida == null) return false;
    if (_selectedGravida == 'Primi') return true;

    // G2+
    if (_selectedPrevMode == null) return false;
    if (_selectedPrevMode == 'Abortion') {
      return _pastEventDateController.text.isNotEmpty &&
          _pastAbortionPlace != null;
    } else {
      // Normal/LSCS
      return _pastEventDateController.text.isNotEmpty &&
          _pastHospitalNameController.text.isNotEmpty &&
          _pastHospitalType != null;
    }
  }

  bool get _isCurrentValid {
    if (_currentStatus == null) return false;
    if (_currentStatus == 'Pending') return true;

    if (_currentStatus == 'Delivered') {
      return _currentDateController.text.isNotEmpty &&
          _currentDeliveryMode != null &&
          _currentHospitalType != null &&
          _currentGender != null;
    } else {
      // Aborted
      return _currentDateController.text.isNotEmpty &&
          _currentAbortionPlace != null;
    }
  }

  // ASHA valid even if empty? Or strict? Code above assumes name required.
  // Phone optional but if present must be 10.
  bool get _isAshaValid => 
    _ashaNameController.text.isNotEmpty &&
    (_ashaPhoneController.text.isEmpty || _ashaPhoneController.text.length == 10);

  @override
  Widget build(BuildContext context) {
    // Custom Stepper Logic using PageView or plain Stepper.
    // Standard Stepper is easiest for "Wizard" feel.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Record"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 3) {
                setState(() => _currentStep += 1);
              } else {
                _updateRecord();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              } else {
                Get.back();
              }
            },
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        child: NeumorphicContainer(
                          onTap: details.onStepCancel,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          borderRadius: BorderRadius.circular(30),
                          child: const Center(child: Text("Back")),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: NeumorphicContainer(
                        onTap: details.onStepContinue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        borderRadius: BorderRadius.circular(30),
                        child: Center(
                          child: Text(
                            _currentStep == 3 ? "Update" : "Next",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            stepIconBuilder: (stepIndex, stepState) {
              final double progress = _getStepProgress(stepIndex);
              final bool isComplete = progress == 1.0;
              final bool isActive = _currentStep == stepIndex;

              // Colors
              final Color emptyColor = Colors.red.shade100;
              final Color progressColor = const Color(0xFF00C853); // Vibrant Green
              final Color textColor = isComplete ? progressColor : Colors.red.shade800;

              return SizedBox(
                width: 40, // Slightly larger for better visibility
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background & Border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // Canvas for colors to pop
                        border: Border.all(
                           // Active step gets a highlight border, otherwise neutral or status color
                          color: isActive ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                          width: isActive ? 4 : 0, 
                        ),
                      ),
                    ),
                    // Progress Indicator
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: progress == 0 ? 0.05 : progress, // Show at least a sliver to verify visibility
                        backgroundColor: emptyColor, 
                        valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                        strokeWidth: 4,
                      ),
                    ),
                    // Content
                    if (isComplete)
                       Icon(Icons.check, size: 18, color: progressColor)
                    else
                       Text(
                          "${stepIndex + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text("Basic"),
                content: _buildBasicInfoStep(),
                isActive: _currentStep >= 0,
                state: _getStepState(0),
              ),
              Step(
                title: const Text("History"),
                content: _buildhistoryStep(),
                isActive: _currentStep >= 1,
                state: _getStepState(1),
              ),
              Step(
                title: const Text("Current"),
                content: _buildCurrentStep(),
                isActive: _currentStep >= 2,
                state: _getStepState(2),
              ),
              Step(
                title: const Text("ASHA"),
                content: _buildAshaStep(),
                isActive: _currentStep >= 3,
                state: _getStepState(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  StepState _getStepState(int index) {
      if (_getStepProgress(index) == 1.0) return StepState.complete;
      if (_currentStep == index) return StepState.editing;
      return StepState.indexed;
  }

  double _getStepProgress(int index) {
    if (index == 0) {
       int total = 4;
       int completed = 0;
       if (_nameController.text.isNotEmpty) completed++;
       if (_husbandController.text.isNotEmpty) completed++;
       if (_villageController.text.isNotEmpty) completed++;
       if (_phoneController.text.length == 10) completed++;
       return completed / total;
    }
    if (index == 1) {
       // History
       if (_selectedGravida == null) return 0.0;
       if (_selectedGravida == 'Primi') return 1.0;
       
       // G2+
       if (_selectedPrevMode == null) return 0.2; // Selected Gravida
       
       if (_selectedPrevMode == 'Abortion') {
          int subTotal = 2; // Date, Place (Weeks optional?)
          int subComplete = 0;
          if (_pastEventDateController.text.isNotEmpty) subComplete++;
          if (_pastAbortionPlace != null) subComplete++;
          // Base 0.4 + (sub / subTotal * 0.6)
          return 0.4 + (subComplete / subTotal * 0.6);
       } else {
          // Normal/LSCS
          int subTotal = 3; // Date, HospName, HospType
          int subComplete = 0;
          if (_pastEventDateController.text.isNotEmpty) subComplete++;
          if (_pastHospitalNameController.text.isNotEmpty) subComplete++;
          if (_pastHospitalType != null) subComplete++;
           return 0.4 + (subComplete / subTotal * 0.6);
       }
    }
    if (index == 2) {
       // Current
       if (_currentStatus == null) return 0.0;
       if (_currentStatus == 'Pending') {
          return _selectedBirthPlan != null ? 1.0 : 0.5;
       }
       if (_currentStatus == 'Delivered') {
          int subTotal = 4; // Date, Mode, HospType, Gender
          int subComplete = 0;
          if (_currentDateController.text.isNotEmpty) subComplete++;
          if (_currentDeliveryMode != null) subComplete++;
          if (_currentHospitalType != null) subComplete++;
          if (_currentGender != null) subComplete++;
          return 0.2 + (subComplete / subTotal * 0.8);
       }
       if (_currentStatus == 'Aborted') {
          int subTotal = 2; // Date, Place
          int subComplete = 0;
          if (_currentDateController.text.isNotEmpty) subComplete++;
          if (_currentAbortionPlace != null) subComplete++;
          return 0.2 + (subComplete / subTotal * 0.8);
       }
    }
    if (index == 3) {
       // ASHA
       return _ashaNameController.text.isNotEmpty ? 1.0 : 0.0;
    }
    return 0.0;
  }

  Widget _buildBasicInfoStep() {
    return Column(
      children: [
        AbsorbPointer(
          child: NeumorphicTextField(
            label: "Name",
            controller: _nameController,
          ),
        ),
        const SizedBox(height: 16),
        NeumorphicTextField(
          label: "Phone",
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) {
            if (v == null || v.isEmpty) return "Required";
            if (v.length != 10) return "Must be 10 digits";
            return null;
          },
        ),
        const SizedBox(height: 16),
        NeumorphicTextField(
          label: "Husband Name",
          controller: _husbandController,
        ),
        const SizedBox(height: 16),
        NeumorphicTextField(label: "Village", controller: _villageController),
        const SizedBox(height: 16),
        AbsorbPointer(
          child: NeumorphicTextField(
            label: "Sub Center",
            controller: _subCenterController,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Name and Sub Center are read-only.",
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildhistoryStep() {
    return Column(
      children: [
        _buildNeomorphicDropdown(
          label: "Gravida",
          value: _selectedGravida,
          items: _gravidaOptions,
          onChanged: (val) => setState(() {
            _selectedGravida = val;
            // Reset downstream if Primi
            if (val == 'Primi') {
              _selectedPrevMode = null;
              _pastHospitalNameController.clear();
              // etc
            }
          }),
        ),

        // Only show history if NOT Primi
        if (_selectedGravida != 'Primi' && _selectedGravida != null) ...[
          const SizedBox(height: 16),
          _buildNeomorphicDropdown(
            label: "Prev. Delivery Mode",
            value: _selectedPrevMode,
            items: _deliveryModeOptions,
            onChanged: (val) => setState(() => _selectedPrevMode = val),
          ),

          if (_selectedPrevMode == 'Abortion') ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context, _pastEventDateController),
              child: AbsorbPointer(
                child: NeumorphicTextField(
                  label: "Abortion Date",
                  controller: _pastEventDateController,
                  hint: "DD-MM-YYYY",
                ),
              ),
            ),
            const SizedBox(height: 16),
            NeumorphicTextField(
              label: "Abortion Weeks",
              controller: _pastAbortionWeeksController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            _buildNeomorphicDropdown(
              label: "Place of Abortion",
              value: _pastAbortionPlace,
              items: _abortionPlaceOptions,
              onChanged: (val) => setState(() => _pastAbortionPlace = val),
            ),
          ] else if (_selectedPrevMode != null) ...[
            // Normal or LSCS
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context, _pastEventDateController),
              child: AbsorbPointer(
                child: NeumorphicTextField(
                  label: "Delivery Date",
                  controller: _pastEventDateController,
                  hint: "DD-MM-YYYY",
                ),
              ),
            ),
            const SizedBox(height: 16),
            NeumorphicTextField(
              label: "Hospital Name",
              controller: _pastHospitalNameController,
            ),
            const SizedBox(height: 16),
            _buildNeomorphicDropdown(
              label: "Hospital Type",
              value: _pastHospitalType,
              items: _hospitalTypeOptions,
              onChanged: (val) => setState(() => _pastHospitalType = val),
            ),
            const SizedBox(height: 16),
            NeumorphicTextField(
              label: "Hospital Address",
              controller: _pastDistrictController,
            ), // Using pastDistrict for Address
          ],
        ],

        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 16),
        _buildNeomorphicAutocomplete(
          label: "High Risk Cause",
          controller: _highRiskController,
          options: _highRiskOptions,
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    return Column(
      children: [
        _buildNeomorphicDropdown(
          label: "Status",
          value: _currentStatus,
          items: _statusOptions,
          onChanged: (val) => setState(() => _currentStatus = val),
        ),

        if (_currentStatus == 'Delivered') ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context, _currentDateController),
            child: AbsorbPointer(
              child: NeumorphicTextField(
                label: "Delivery Date",
                controller: _currentDateController,
                hint: "DD-MM-YYYY",
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildNeomorphicDropdown(
            label: "Delivery Mode",
            value: _currentDeliveryMode,
            items: ['Normal', 'LSCS'],
            onChanged: (val) => setState(() => _currentDeliveryMode = val),
          ),
          const SizedBox(height: 16),
          _buildNeomorphicDropdown(
            label: "Hospital Type",
            value: _currentHospitalType,
            items: _hospitalTypeOptions,
            onChanged: (val) => setState(() => _currentHospitalType = val),
          ),
          const SizedBox(height: 16),
          _buildNeomorphicDropdown(
            label: "Baby Gender",
            value: _currentGender,
            items: _genderOptions,
            onChanged: (val) => setState(() => _currentGender = val),
          ),
        ] else if (_currentStatus == 'Aborted') ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context, _currentDateController),
            child: AbsorbPointer(
              child: NeumorphicTextField(
                label: "Abortion Date",
                controller: _currentDateController,
                hint: "DD-MM-YYYY",
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildNeomorphicDropdown(
            label: "Abortion Place",
            value: _currentAbortionPlace,
            items: _abortionPlaceOptions,
            onChanged: (val) => setState(() => _currentAbortionPlace = val),
          ),
          const SizedBox(height: 16),
          NeumorphicTextField(
            label: "Abortion Weeks",
            controller: _abortionWeeksController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ] else ...[
          // Pending
          const SizedBox(height: 16),
          _buildNeomorphicDropdown(
            label: "Birth Plan",
            value: _selectedBirthPlan,
            items: _birthPlanOptions,
            onChanged: (val) => setState(() => _selectedBirthPlan = val),
          ),
        ],
      ],
    );
  }

  Widget _buildAshaStep() {
    return Column(
      children: [
        NeumorphicTextField(
          label: "ASHA Name",
          controller: _ashaNameController,
        ),
        const SizedBox(height: 16),
        NeumorphicTextField(
          label: "ASHA Contact",
          controller: _ashaPhoneController,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) {
             // Optional but if entered must be 10
             if (v != null && v.isNotEmpty && v.length != 10) return "Must be 10 digits";
             return null;
          },
        ),
      ],
    );
  }

  Widget _buildNeomorphicDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        NeumorphicContainer(
          borderRadius: BorderRadius.circular(12),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text("Select"),
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNeomorphicAutocomplete({
    required String label,
    required TextEditingController controller,
    required List<String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<String>(
              initialValue: TextEditingValue(text: controller.text),
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return options;
                }
                return options.where((String option) {
                  return option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              onSelected: (String selection) {
                controller.text = selection;
              },
              fieldViewBuilder:
                  (context, textController, focusNode, onFieldSubmitted) {
                    // Ensure controller stays in sync
                    if (controller.text != textController.text) {
                      textController.text = controller.text;
                    }
                    textController.addListener(() {
                      controller.text = textController.text;
                    });
                    return NeumorphicContainer(
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: textController,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type or select...",
                        ),
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(option),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
