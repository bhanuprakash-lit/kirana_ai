import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';

class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  ConsumerState<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends ConsumerState<ReportIssueScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'App Bug';
  bool _isSending = false;

  final List<String> _categories = [
    'App Bug',
    'Pricing Issue',
    'Inventory Mismatch',
    'AI Recommendation Feedback',
    'POS Error',
    'Feature Request',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text('Report an Issue', style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Describe the problem',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our team will review your report and fix it as soon as possible.',
              style: TextStyle(color: BrandColors.muted, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Category Dropdown
            const Text(
              'ISSUE CATEGORY',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: BrandColors.muted, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: BrandColors.border.withValues(alpha: 0.5)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: BrandColors.muted),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category, style: const TextStyle(fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedCategory = newValue);
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Title Field
            const Text(
              'SHORT SUMMARY',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: BrandColors.muted, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'e.g. App crashes when scanning barcode',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: BrandColors.border.withValues(alpha: 0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: BrandColors.border.withValues(alpha: 0.5)),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Description Field
            const Text(
              'DETAILED DESCRIPTION',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: BrandColors.muted, letterSpacing: 1),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Provide details on how to reproduce the issue...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: BrandColors.border.withValues(alpha: 0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: BrandColors.border.withValues(alpha: 0.5)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            LoadingButton(
              label: 'Submit Report',
              isLoading: _isSending,
              onPressed: _handleSubmit,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isSending = true);
    
    try {
      final client = ref.read(apiClientProvider);
      await client.post('/kirana/support/report', {
        'category': _selectedCategory,
        'title': _titleController.text,
        'description': _descriptionController.text,
      });

      if (mounted) {
        setState(() => _isSending = false);
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: const Text('Report Submitted', style: TextStyle(fontWeight: FontWeight.w900)),
            content: const Text('Thank you for your feedback. Our team will look into it immediately.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // pop dialog
                  Navigator.pop(context); // pop screen
                },
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit report: $e')),
        );
      }
    }
  }
}
