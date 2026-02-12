import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:survey_app/config/report_api_config.dart';
import 'package:survey_app/models/outlet_report_payload.dart';
import 'package:survey_app/resources/outlet_categories.dart';
import 'package:survey_app/resources/tanzania_regions.dart';
import 'package:survey_app/services/outlet_report_service.dart';
import 'package:http/http.dart' as http;
import 'package:survey_app/resources/colors.dart';

class OutletInteractionReportScreen extends StatefulWidget {
  const OutletInteractionReportScreen({super.key});

  @override
  State<OutletInteractionReportScreen> createState() =>
      _OutletInteractionReportScreenState();
}

class _OutletInteractionReportScreenState
    extends State<OutletInteractionReportScreen> {
  // Global form key used to validate and submit the form.
  final _formKey = GlobalKey<FormState>();

  // Controllers for all text input fields in the form.
  final TextEditingController _outletNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _gpsController = TextEditingController(
    text: '-6.7924, 39.2083',
  );
  final TextEditingController _challengesController = TextEditingController();
  final TextEditingController _topCompetitorController =
      TextEditingController();
  final TextEditingController _additionalNotesController =
      TextEditingController();

  // Dropdown field values.
  String? _selectedCategory;
  String? _selectedRegion;
  String _selectedCountryCode = '+255';

  // Radio button values for product awareness questions.
  bool? _customerAware;
  bool? _outletHasProducts;
  bool? _orderPlaced;

  // UI state for location lookup.
  bool _isGettingLocation = false;

  final OutletReportService _reportService = OutletReportService();

  // Checkbox values for Knauf products available at the outlet.
  final Map<String, bool> _availableProducts = {
    'Double Elephant': false,
    'Easy Board': false,
    'Finish Bora': false,
    'Joint Bora': false,
    'Knauf Wall Put': false,
    'Knauf Metal Profile': false,
  };

  // Checkbox values for products requested in the order (YES case).
  final Map<String, bool> _orderedProducts = {
    'Double Elephant': false,
    'Easy Board': false,
    'Finish Bora': false,
    'Joint Bora': false,
    'Knauf Wall Put': false,
    'Knauf Metal Profile': false,
  };

  // Quantity controllers for each ordered product.
  final Map<String, TextEditingController> _productQuantities = {
    'Double Elephant': TextEditingController(),
    'Easy Board': TextEditingController(),
    'Finish Bora': TextEditingController(),
    'Joint Bora': TextEditingController(),
    'Knauf Wall Put': TextEditingController(),
    'Knauf Metal Profile': TextEditingController(),
  };

  // Checkbox values for competitor products available at the outlet.
  final Map<String, bool> _competitorProducts = {
    'BBG Board': false,
    'JK Wall Putty': false,
    'Dragon Board / Wall Put': false,
    'Shunline Board': false,
    'Oles Board': false,
    'Thailand': false,
    'Magic White Skim Wall Put': false,
    'HK Wall Putty': false,
    'NKY Board': false,
    'Any Other Products': false,
  };

  // Checkbox values for customer feedback / maoni options.
  final Map<String, bool> _customerFeedbackOptions = {
    'Knauf Products are in high Quality / Ubora wa bidhaa zenu uko juu, Kongole!':
        false,
    'Concern on Listing Price / Price Indifferences / Bei za bidhaa zenu kwa jumla ni tofauti tofauti':
        false,
    'Provide Seminars to Local Fundis / Fanyeni semina za mafundi': false,
    'Increase Product Distribution / Ongeza uzalishaji na usambazaji': false,
    'Rethink on Wholesales Incentives / Weka offer zaidi kwa Wasambazaji':
        false,
    'Invest on Marketing Promotions / Bidhaa zenu hazijulikani': false,
    'Products are not Fast Moving / Bidhaa zenu hazitembuki haraka': false,
    'Any other feedback / Maoni tofauti na hayo': false,
    'Sell on Credit / Tunaomba kukopeswa bidhaa zenu': false,
    'Provide Free Sample / Tutoe sample madukani': false,
  };

  // Checkbox values for branding materials left at the outlet.
  final Map<String, bool> _brandingMaterials = {
    'Poster': false,
    'Fliers': false,
  };

  // Possible order status values (YES case) as per web form.
  final List<String> _orderStatuses = const [
    'Pending / Haijapelekwa',
    'Delivered / Imepelekwa',
  ];

  String? _selectedOrderStatus;

  // File uploads
  String _outletPicture = 'No file chosen';
  String _brandedPicture = 'No file chosen';

  @override
  void dispose() {
    _outletNameController.dispose();
    _phoneController.dispose();
    _districtController.dispose();
    _streetController.dispose();
    _gpsController.dispose();
    _challengesController.dispose();
    _topCompetitorController.dispose();
    _additionalNotesController.dispose();
    
    // Dispose product quantity controllers
    for (final controller in _productQuantities.values) {
      controller.dispose();
    }
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.knaufBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        // title: const Text(
        //   'Hello, CornerStone',
        //   style: TextStyle(color: AppColors.textOnPrimary, fontSize: 16),
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textOnPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header hero section for the report title and description.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.primaryContainer,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KNAUF TANZANIA',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 2,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Outlet Interaction Report',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Document every visit with photos, availability insights, and customer feedback in one modern interface.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Main form content area.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Outlet contact details section.
                    _buildOutletContactSection(),
                    const SizedBox(height: 16),
                    // Location & verification section.
                    _buildLocationVerificationSection(),
                    const SizedBox(height: 16),
                    // Knauf product awareness section.
                    _buildProductAwarenessSection(),
                    const SizedBox(height: 16),
                    // Competitor landscape section.
                    _buildCompetitorLandscapeSection(),
                    const SizedBox(height: 16),
                    // Customer feedback section.
                    _buildCustomerFeedbackSection(),
                    const SizedBox(height: 16),
                    // Order status and branding materials section.
                    _buildOrderStatusSection(),
                    const SizedBox(height: 16),
                    // Additional free-text notes section.
                    _buildAdditionalNotesSection(),
                    const SizedBox(height: 24),
                    // Primary submit button for the whole form.
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Uses the geolocator package to get the current device coordinates and
  // populate the GPS coordinates text field in a user-friendly way.
  Future<void> _useCurrentLocation() async {
    try {
      setState(() {
        _isGettingLocation = true;
      });

      // Ensure location services are enabled on the device.
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location services are disabled. Please enable GPS.'),
          ),
        );
        return;
      }

      // Check and request location permission at runtime.
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission denied. Cannot get GPS.'),
          ),
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission permanently denied. Please enable it in system settings.',
            ),
          ),
        );
        return;
      }

      // Get the most accurate current position available.
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Format to 5 decimal places (approx ~1m precision) for readability.
      final formatted =
          '${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}';

      if (!mounted) return;
      setState(() {
        _gpsController.text = formatted;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
    } finally {
      if (!mounted) return;
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  Widget _buildOutletContactSection() {
    // Section: Basic outlet contact information (name, phone, category).
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Outlet Contact',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildTextField(
            label: 'Outlet name / Jina la Duka',
            controller: _outletNameController,
            hintText: 'Outlet name',
          ),
          const SizedBox(height: 16),
          _buildPhoneField(),
          const SizedBox(height: 16),
          _buildDropdownField(
            label: 'Outlet category / Aina ya Duka',
            value: _selectedCategory,
            items: outletCategories,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationVerificationSection() {
    // Section: Physical location details, GPS, and outlet photos.
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location & Verification',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildDropdownField(
            label: 'Region / Mkoa',
            value: _selectedRegion,
            items: tanzaniaRegions,
            onChanged: (value) {
              setState(() {
                _selectedRegion = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'District / Wilaya',
            controller: _districtController,
            hintText: 'District',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Street of outlet / Mtaa wa duka',
            controller: _streetController,
            hintText: 'Street',
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                label: 'GPS coordinates',
                controller: _gpsController,
                hintText: '-6.7924, 39.2083',
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isGettingLocation ? null : _useCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.buttonTextPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isGettingLocation
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.buttonTextPrimary,
                            ),
                          ),
                        )
                      : const Text('Use current location'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildFileUpload(
            label: 'Outlet picture / Picha ya Duka',
            description: 'Take a clear photo of storefront.',
            fileName: _outletPicture,
            onPressed: () async{
              FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
              if (result != null) {
                List<File> files = result.paths.map((path) => File(path!)).toList();
                var pazs = result.paths;
                uploadFiles(result.paths);
              } else {
                // User canceled the picker
              }
              setState(() {
                _outletPicture = 'storefront.jpg';
              });
            },
          ),
          const SizedBox(height: 16),
          _buildFileUpload(
            label: 'Outlet picture after branding',
            description: 'Capture branded materials on site.',
            fileName: _brandedPicture,
            onPressed: () {
              setState(() {
                _brandedPicture = 'branded.jpg';
              });
            },
          ),
        ],
      ),
    );
  }

   Future<void> uploadFiles(List<String?> paths) async {
  var uri = Uri.parse("https://cornerstone.core.tz/promo/upload-files");
  var request = http.MultipartRequest("POST", uri);

  // Add text fields
  request.fields['user_id'] = 'yekonga_user_1';

  // Add multiple files
  for (var path in paths) {
    var file = await http.MultipartFile.fromPath('files', path??"");
    request.files.add(file);
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    debugPrint("Uploaded!: ${response.contentLength}");
    print("Uploaded!");
  } else {
    print("Failed with status: ${response.statusCode}");
  }
}
              

  Widget _buildProductAwarenessSection() {
    // Section: Awareness and availability of Knauf products.
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Awareness',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildRadioGroup(
            label: 'Customer aware about Knauf products?',
            value: _customerAware,
            onChanged: (value) {
              setState(() {
                _customerAware = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildRadioGroup(
            label: 'Outlet has Knauf products?',
            value: _outletHasProducts,
            onChanged: (value) {
              setState(() {
                _outletHasProducts = value;
              });
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Knauf products available / Bidhaa zilizopo',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildProductCheckboxes(),
          const SizedBox(height: 24),
          _buildTextField(
            label: 'Challenges stocking Knauf products? / Changamoto',
            controller: _challengesController,
            hintText: '',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // Section widget: Competitor product availability and insights.
  Widget _buildCompetitorLandscapeSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Competitor Landscape',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Competitors product availability / Bidhaa za Washindani *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          _buildCompetitorCheckboxes(),
          const SizedBox(height: 24),
          _buildTextField(
            label: 'Top selling competitor product & why?',
            controller: _topCompetitorController,
            hintText: '',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // Section widget: structured customer feedback / maoni options.
  Widget _buildCustomerFeedbackSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customer Feedback / Maoni',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildCustomerFeedbackCheckboxes(),
        ],
      ),
    );
  }

  // Section widget: order status (did customer place an order?) and branding materials.
  Widget _buildOrderStatusSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildRadioGroup(
            label: 'Did customer press order?',
            value: _orderPlaced,
            onChanged: (value) {
              setState(() {
                _orderPlaced = value;
              });
            },
          ),
          const SizedBox(height: 24),
          if (_orderPlaced == true) ...[
            const Text(
              'Order products requested *',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            _buildOrderedProductsCheckboxes(),
            const SizedBox(height: 24),
            _buildDropdownField(
              label: 'Status of order / Hali ya order',
              value: _selectedOrderStatus,
              items: _orderStatuses,
              onChanged: (value) {
                setState(() {
                  _selectedOrderStatus = value;
                });
              },
            ),
            const SizedBox(height: 24),
          ],
          // Note: For the "No" case, we only capture branding materials left (per spec).
          if (_orderPlaced != null) ...[
            const Text(
              'Branding materials left',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            _buildBrandingMaterialsCheckboxes(),
          ],
        ],
      ),
    );
  }

  // Section widget: any additional notes the field team wants to record.
  Widget _buildAdditionalNotesSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: _buildTextField(
        label: 'Additional Notes',
        controller: _additionalNotesController,
        hintText: 'Anything else to record',
        maxLines: 4,
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.inputFocusedBorder,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget: phone number input with country code dropdown.
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone number of outlet / Namba ya Simu',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorder),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.cardBackground,
              ),
              child: Row(
                children: [
                  Image.network(
                    'https://flagcdn.com/w40/tz.png',
                    width: 24,
                    height: 16,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 24,
                        height: 16,
                        color: AppColors.success,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedCountryCode,
                    underline: const SizedBox(),
                    items: ['+255', '+254', '+256']
                        .map(
                          (code) =>
                              DropdownMenuItem(value: code, child: Text(code)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCountryCode = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: '712 345 678',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.inputFocusedBorder,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Format: 000 000 000',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Helper widget: reusable dropdown field with label and hint.
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.inputFocusedBorder,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          hint: Text(
            value == null
                ? 'Select ${label.split('/')[0].trim().toLowerCase()}'
                : '',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Helper widget: file upload-style button with helper description text.
  Widget _buildFileUpload({
    required String label,
    required String description,
    required String fileName,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.inputBorder),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Choose File',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              Text(
                fileName,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // Helper widget: yes/no radio group used in multiple sections.
  Widget _buildRadioGroup({
    required String label,
    required bool? value,
    required Function(bool?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.inputBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              RadioListTile<bool>(
                title: const Text('Yes'),
                value: true,
                groupValue: value,
                onChanged: onChanged,
                activeColor: AppColors.buttonPrimary,
              ),
              Divider(height: 1, color: AppColors.inputBorder),
              RadioListTile<bool>(
                title: const Text('No'),
                value: false,
                groupValue: value,
                onChanged: onChanged,
                activeColor: AppColors.buttonPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper widget: checklist of Knauf products available at the outlet.
  Widget _buildProductCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Double Elephant'),
          value: _availableProducts['Double Elephant'],
          onChanged: (value) {
            setState(() {
              _availableProducts['Double Elephant'] = value!;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Easy Board'),
          value: _availableProducts['Easy Board'],
          onChanged: (value) {
            setState(() {
              _availableProducts['Easy Board'] = value!;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Finish Bora'),
          value: _availableProducts['Finish Bora'],
          onChanged: (value) {
            setState(() {
              _availableProducts['Finish Bora'] = value!;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Joint Bora'),
          value: _availableProducts['Joint Bora'],
          onChanged: (value) {
            setState(() {
              _availableProducts['Joint Bora'] = value!;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Knauf Wall Put'),
          value: _availableProducts['Knauf Wall Put'],
          onChanged: (value) {
            setState(() {
              _availableProducts['Knauf Wall Put'] = value!;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Knauf Metal Profile'),
          value: _availableProducts['Knauf Metal Profile'],
          onChanged: (value) {
            setState(() {
              _availableProducts['Knauf Metal Profile'] = value!;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  // Helper widget: checklist of ordered products with quantity fields when customer places an order.
  Widget _buildOrderedProductsCheckboxes() {
    return Column(
      children: [
        _buildOrderedProductItem('Double Elephant'),
        _buildOrderedProductItem('Easy Board'),
        _buildOrderedProductItem('Finish Bora'),
        _buildOrderedProductItem('Joint Bora'),
        _buildOrderedProductItem('Knauf Wall Put'),
        _buildOrderedProductItem('Knauf Metal Profile'),
      ],
    );
  }

  // Helper widget for individual product with checkbox and quantity field
  Widget _buildOrderedProductItem(String productName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: _orderedProducts[productName],
            onChanged: (value) {
              setState(() {
                _orderedProducts[productName] = value ?? false;
              });
            },
            activeColor: AppColors.knaufBlue,
          ),
          Expanded(
            child: Text(
              productName,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          if (_orderedProducts[productName] == true)
            SizedBox(
              width: 80,
              child: TextField(
                controller: _productQuantities[productName],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Qty',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.inputFocusedBorder, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to build order quantities map
  Map<String, int>? _buildOrderQuantities() {
    final Map<String, int> quantities = {};
    
    for (final entry in _orderedProducts.entries) {
      if (entry.value == true) { // if product is selected
        final quantityText = _productQuantities[entry.key]?.text;
        final quantity = int.tryParse(quantityText ?? '') ?? 0;
        if (quantity > 0) {
          quantities[entry.key] = quantity;
        }
      }
    }
    
    return quantities.isEmpty ? null : quantities;
  }

  // Helper method to validate competitor checkboxes
  bool _validateCompetitorProducts() {
    return _competitorProducts.values.any((selected) => selected == true);
  }

  // Helper method to validate ordered products checkboxes
  bool _validateOrderedProducts() {
    return _orderedProducts.values.any((selected) => selected == true);
  }

  // Helper method to show validation error dialog
  void _showValidationErrorDialog(String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // Can't close by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Required Fields Missing',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: AppColors.knaufBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper widget: checklist of competitor products available at the outlet.
  Widget _buildCompetitorCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('BBG Board'),
          value: _competitorProducts['BBG Board'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['BBG Board'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('JK Wall Putty'),
          value: _competitorProducts['JK Wall Putty'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['JK Wall Putty'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Dragon Board / Wall Put'),
          value: _competitorProducts['Dragon Board / Wall Put'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['Dragon Board / Wall Put'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Shunline Board'),
          value: _competitorProducts['Shunline Board'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['Shunline Board'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Oles Board'),
          value: _competitorProducts['Oles Board'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['Oles Board'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Thailand'),
          value: _competitorProducts['Thailand'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['Thailand'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Magic White Skim Wall Put'),
          value: _competitorProducts['Magic White Skim Wall Put'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['Magic White Skim Wall Put'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('HK Wall Putty'),
          value: _competitorProducts['HK Wall Putty'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['HK Wall Putty'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('NKY Board'),
          value: _competitorProducts['NKY Board'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['NKY Board'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          title: const Text('Any Other Products'),
          value: _competitorProducts['Any Other Products'],
          onChanged: (value) {
            setState(() {
              _competitorProducts['Any Other Products'] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  // Helper widget: checklist of customer feedback / maoni options.
  Widget _buildCustomerFeedbackCheckboxes() {
    return Column(
      children: _customerFeedbackOptions.keys.map((key) {
        return CheckboxListTile(
          title: Text(key),
          value: _customerFeedbackOptions[key],
          onChanged: (value) {
            setState(() {
              _customerFeedbackOptions[key] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  // Helper widget: checklist of branding materials left at the outlet.
  Widget _buildBrandingMaterialsCheckboxes() {
    return Column(
      children: _brandingMaterials.keys.map((key) {
        return CheckboxListTile(
          title: Text(key),
          value: _brandingMaterials[key],
          onChanged: (value) {
            setState(() {
              _brandingMaterials[key] = value ?? false;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  /// Builds the API payload from current form state.
  /// Only non-null / provided values are included in [OutletReportPayload.toMap].
  OutletReportPayload _buildPayload() {
    final knaufSelected = _availableProducts.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    final competitorSelected = _competitorProducts.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    final feedbackSelected = _customerFeedbackOptions.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    final orderProductsSelected = _orderedProducts.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
    final brandingSelected = _brandingMaterials.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    return OutletReportPayload(
      projectId: ReportApiConfig.projectId,
      date: DateTime.now().toIso8601String().split('T').first,
      activator: '',
      outletName: _outletNameController.text.trim().isEmpty
          ? null
          : _outletNameController.text.trim(),
      outletPhone: _phoneController.text.trim().isEmpty
          ? null
          : '$_selectedCountryCode ${_phoneController.text.trim()}',
      outletPicture: null,
      outletStreet: _streetController.text.trim().isEmpty
          ? null
          : _streetController.text.trim(),
      region: _selectedRegion,
      district: _districtController.text.trim().isEmpty
          ? null
          : _districtController.text.trim(),
      category: _selectedCategory,
      awareKnauf: _customerAware == null
          ? null
          : (_customerAware! ? 'Yes' : 'No'),
      productAvailability: _outletHasProducts == null
          ? null
          : (_outletHasProducts! ? 'Yes' : 'No'),
      knaufProducts: knaufSelected.isEmpty ? null : knaufSelected,
      stockingChallenges: _challengesController.text.trim().isEmpty
          ? null
          : _challengesController.text.trim(),
      competitorProducts: competitorSelected.isEmpty
          ? null
          : competitorSelected,
      competitorOther: null,
      competitorTopSeller: _topCompetitorController.text.trim().isEmpty
          ? null
          : _topCompetitorController.text.trim(),
      customerFeedback: feedbackSelected.isEmpty ? null : feedbackSelected,
      customerFeedbackOther: null,
      orderPressed: _orderPlaced == null
          ? null
          : (_orderPlaced! ? 'Yes' : 'No'),
      orderProducts: orderProductsSelected.isEmpty
          ? null
          : orderProductsSelected,
      orderQuantities: _buildOrderQuantities(),
      orderStatus: _selectedOrderStatus,
      brandingMaterials: brandingSelected.isEmpty ? null : brandingSelected,
      outletPictureAfter: null,
      notes: _additionalNotesController.text.trim().isEmpty
          ? null
          : _additionalNotesController.text.trim(),
      gpsCoordinates: _gpsController.text.trim().isEmpty
          ? null
          : _gpsController.text.trim(),
    );
  }

  /// Shows a progress dialog, submits the report, then closes and shows result.
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      _showValidationErrorDialog('Please fill in all required fields');
      return;
    }

    // Validate competitor products checkbox
    if (!_validateCompetitorProducts()) {
      _showValidationErrorDialog('Please select at least one competitor product');
      return;
    }

    // Validate ordered products checkbox (only if order was placed)
    if (_orderPlaced == true && !_validateOrderedProducts()) {
      _showValidationErrorDialog('Please select at least one product to order');
      return;
    }

    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _SubmitProgressDialog(message: 'Submitting report…'),
    );

    try {
      // await _reportService.submitReport(_buildPayload());
      var payload = _buildPayload();
      final variables = payload.toMap();
      var respo = await YeGenV2().spShoot(query: "", variables: variables);
      debugPrint("Responsee: $respo");
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Report submitted successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submit failed: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // Section widget: primary form submit button.
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitReport,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: AppColors.buttonTextPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Submit Report',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

/// Full-screen style progress dialog used during report submission.
class _SubmitProgressDialog extends StatelessWidget {
  const _SubmitProgressDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
