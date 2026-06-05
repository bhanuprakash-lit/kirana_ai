import 'package:flutter/material.dart';
import '../../../../core/theme/brand_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final faqs = [
      _Faq(question: l10n.supFaqQ1, answer: l10n.supFaqA1),
      _Faq(question: l10n.supFaqQ2, answer: l10n.supFaqA2),
      _Faq(question: l10n.supFaqQ3, answer: l10n.supFaqA3),
      _Faq(question: l10n.supFaqQ4, answer: l10n.supFaqA4),
      _Faq(question: l10n.supFaqQ5, answer: l10n.supFaqA5),
      _Faq(question: l10n.supFaqQ6, answer: l10n.supFaqA6),
    ];

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: Text(
          l10n.supFaqTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: BrandColors.ink,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (context, index) => _FaqTile(faq: faqs[index]),
      ),
    );
  }
}

class _Faq {
  final String question;
  final String answer;
  _Faq({required this.question, required this.answer});
}

class _FaqTile extends StatefulWidget {
  final _Faq faq;
  const _FaqTile({required this.faq});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: BrandColors.border.withValues(alpha: 0.5)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (v) => setState(() => _isExpanded = v),
          trailing: Icon(
            _isExpanded
                ? Icons.remove_circle_outline_rounded
                : Icons.add_circle_outline_rounded,
            color: _isExpanded ? BrandColors.primary : BrandColors.muted,
          ),
          title: Text(
            widget.faq.question,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: _isExpanded ? BrandColors.primary : BrandColors.ink,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.faq.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: BrandColors.ink,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
