import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/brand_theme.dart';
import '../../../../shared/widgets/action_widgets.dart';
import '../../providers/inventory_provider.dart';

Future<bool> showAddCategorySheet(
    BuildContext context, WidgetRef ref) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddCategorySheet(ref: ref),
  );
  return result ?? false;
}

class _AddCategorySheet extends ConsumerStatefulWidget {
  final WidgetRef ref;
  const _AddCategorySheet({required this.ref});

  @override
  ConsumerState<_AddCategorySheet> createState() =>
      _AddCategorySheetState();
}

class _AddCategorySheetState extends ConsumerState<_AddCategorySheet> {
  final _nameCtrl = TextEditingController();
  bool _saving = false;
  bool _success = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Category name is required');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
      _success = false;
    });
    final result = await ref
        .read(inventoryProvider.notifier)
        .addCategory(name);
    if (mounted) {
      if (result) {
        setState(() {
          _saving = false;
          _success = true;
        });
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) Navigator.pop(context, true);
      } else {
        setState(() {
          _saving = false;
          _error = 'Failed to create category. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: BrandColors.border.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('New Category',
              style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: BrandColors.ink)),
          const SizedBox(height: 6),
          const Text('Add a category to organise your products.',
              style:
                  TextStyle(color: BrandColors.muted, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          
          ActionStatusOverlay(
            isSaving: _saving,
            error: _error,
            isSuccess: _success,
            successMessage: 'Category created!',
          ),
          if (_saving || _error != null || _success) const SizedBox(height: 16),

          TextField(
            controller: _nameCtrl,
            autofocus: true,
            enabled: !_saving && !_success,
            decoration: const InputDecoration(
              labelText: 'Category name',
              hintText: 'e.g. Staples, Dairy, Snacks…',
            ),
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: LoadingButton(
              label: 'Create Category',
              isLoading: _saving,
              onPressed: _success ? null : _save,
            ),
          ),
        ],
      ),
    );
  }
}
