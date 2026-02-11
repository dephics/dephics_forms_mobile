import 'package:flutter/material.dart';
import 'package:survey_app/resources/colors.dart';

class AllSubmittedData extends StatefulWidget {
  const AllSubmittedData({super.key});

  @override
  State<AllSubmittedData> createState() => _AllSubmittedDataState();
}

class _AllSubmittedDataState extends State<AllSubmittedData> {
  final TextEditingController _searchController = TextEditingController();
  
  // Sample data for submitted forms
  final List<SubmittedForm> _submittedForms = [
    SubmittedForm(
      id: 'Data 2344',
      outlet: 'Mandara Kiosk',
      dateTime: '23-04-2026 12:45hrs',
    ),
    SubmittedForm(
      id: 'Data 2343',
      outlet: 'City Center Store',
      dateTime: '23-04-2026 11:30hrs',
    ),
    SubmittedForm(
      id: 'Data 2342',
      outlet: 'Mikocheni Shop',
      dateTime: '23-04-2026 10:15hrs',
    ),
    SubmittedForm(
      id: 'Data 2341',
      outlet: 'Sinza Branch',
      dateTime: '22-04-2026 16:20hrs',
    ),
    SubmittedForm(
      id: 'Data 2340',
      outlet: 'Kariakoo Market',
      dateTime: '22-04-2026 14:10hrs',
    ),
  ];

  List<SubmittedForm> get _filteredForms {
    if (_searchController.text.isEmpty) {
      return _submittedForms;
    }
    return _submittedForms.where((form) =>
      form.id.toLowerCase().contains(_searchController.text.toLowerCase()) ||
      form.outlet.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
    
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.knaufBlue,
        elevation: 0,
        title: const Text(
          'Submitted Forms',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.textOnPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.knaufBlue,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Knauff Customer Survey',
                  style: TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Input Count
                Text(
                  '${_filteredForms.length} inputs',
                  style: const TextStyle(
                    color: AppColors.textOnPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // List of Submitted Forms
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredForms.length,
              itemBuilder: (context, index) {
                final form = _filteredForms[index];
                return SubmittedFormCard(
                  form: form,
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SubmittedFormCard extends StatelessWidget {
  final SubmittedForm form;
  final VoidCallback onTap;

  const SubmittedFormCard({
    super.key,
    required this.form,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    color: AppColors.knaufBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Form Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${form.id} - ${form.outlet}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        form.dateTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Manage Button
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.knaufBlue,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Manage',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubmittedForm {
  final String id;
  final String outlet;
  final String dateTime;

  SubmittedForm({
    required this.id,
    required this.outlet,
    required this.dateTime,
  });
}