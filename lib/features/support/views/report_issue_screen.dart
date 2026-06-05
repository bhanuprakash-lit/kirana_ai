import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
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
    'Other',
  ];

  AppLocalizations get _l10n =>
      lookupAppLocalizations(ref.read(localeProvider));

  String _categoryLabel(AppLocalizations l10n, String value) {
    switch (value) {
      case 'App Bug':
        return l10n.supCategoryAppBug;
      case 'Pricing Issue':
        return l10n.supCategoryPricing;
      case 'Inventory Mismatch':
        return l10n.supCategoryInventory;
      case 'AI Recommendation Feedback':
        return l10n.supCategoryAiFeedback;
      case 'POS Error':
        return l10n.supCategoryPosError;
      case 'Feature Request':
        return l10n.supCategoryFeatureRequest;
      case 'Other':
        return l10n.supCategoryOther;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.supReportTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.supReportHeading,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.supReportSubheading,
              style: const TextStyle(color: BrandColors.muted, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // Category Dropdown
            Text(
              l10n.supReportCategoryLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: BrandColors.muted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: BrandColors.border.withValues(alpha: 0.5),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: BrandColors.muted,
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        _categoryLabel(l10n, category),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
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
            Text(
              l10n.supReportSummaryLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: BrandColors.muted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: l10n.supReportSummaryHint,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: BrandColors.border.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: BrandColors.border.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Description Field
            Text(
              l10n.supReportDescriptionLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: BrandColors.muted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: l10n.supReportDescriptionHint,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: BrandColors.border.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: BrandColors.border.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            LoadingButton(
              label: l10n.supReportSubmit,
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
        SnackBar(
          content: Text(AppLocalizations.of(context).supReportFillFields),
        ),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              _l10n.supReportSubmittedTitle,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            content: Text(_l10n.supReportSubmittedBody),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // pop dialog
                  Navigator.pop(context); // pop screen
                },
                child: Text(
                  _l10n.supOk,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_l10n.supReportSubmitFailed(e.toString()))),
        );
      }
    }
  }
}
