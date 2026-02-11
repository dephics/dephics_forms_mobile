import 'package:flutter/material.dart';
import 'package:survey_app/views/in_form.dart';

import 'package:survey_app/resources/colors.dart';

class AllForms extends StatefulWidget {
  const AllForms({super.key});

  @override
  State<AllForms> createState() => _AllFormsState();
}

class _AllFormsState extends State<AllForms> {
  final List<FormItem> forms = [
    FormItem(
      title: 'Knauff Customer Survey',
      company: 'Cornerstone Limited',
      inputs: 23,
      color: AppColors.knaufBlue,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.knaufBlue,
        automaticallyImplyLeading: false,
        title: const Text(
          'All Forms',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textOnPrimary,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search, color: Colors.white),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: const Icon(Icons.more_vert, color: Colors.white),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: forms.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return InForm();
                  },
                ),
              );
            },
            child: FormCard(form: forms[index]),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   backgroundColor: Colors.blue.shade700,
      //   icon: const Icon(Icons.add),
      //   label: const Text('New Form'),
      // ),
    );
  }
}

class FormCard extends StatelessWidget {
  final FormItem form;

  const FormCard({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.knaufBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return InForm();
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [form.color, form.color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.textOnPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Form Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        form.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        form.company,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Input Count Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: form.inputs > 0
                              ? AppColors.primaryContainer
                              : AppColors.knaufLightGrey,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: form.inputs > 0
                                ? AppColors.primary
                                : AppColors.border,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.input,
                              size: 14,
                              color: form.inputs > 0
                                  ? AppColors.knaufBlue
                                  : AppColors.knaufGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${form.inputs} inputs',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: form.inputs > 0
                                    ? AppColors.knaufBlue
                                    : AppColors.knaufGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormItem {
  final String title;
  final String company;
  final int inputs;
  final Color color;

  FormItem({
    required this.title,
    required this.company,
    required this.inputs,
    required this.color,
  });
}
