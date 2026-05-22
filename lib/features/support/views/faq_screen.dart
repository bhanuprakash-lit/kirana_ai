import 'package:flutter/material.dart';
import '../../../../core/theme/brand_theme.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      _Faq(
        question: 'How do I add a new product?',
        answer:
            'You can add products from the POS tab by clicking the + button, or from the Inventory tab. You can also scan a barcode to automatically fetch details if available.',
      ),
      _Faq(
        question: 'How does the Stockout Risk prediction work?',
        answer:
            'Our AI analyzes your past sales velocity and current stock levels. If it predicts you will run out of an item within the next 3-7 days, it flags it as a Stockout Risk.',
      ),
      _Faq(
        question: 'How do I manage customer credit (Khata)?',
        answer:
            'When placing an order, select a customer and choose "Credit" as the payment method. You can view all pending dues in the Finance -> Udhaar tab or Customer Relations section.',
      ),
      _Faq(
        question: 'Can I sync my phone contacts?',
        answer:
            'Yes! Go to Profile -> Customer Relations and click the Sync icon. This will import your regular shoppers into the app for easy credit tracking.',
      ),
      _Faq(
        question: 'What are KPI Subscriptions?',
        answer:
            'KPIs are key business metrics like Revenue, Margin, and Footfall. You can choose which metrics to monitor from the Profile -> Subscription section.',
      ),
      _Faq(
        question: 'How do I generate a daily sales report?',
        answer:
            'You can view today\'s performance on the Dashboard. For detailed past reports, visit the Transaction History section in your Profile.',
      ),
    ];

    return Scaffold(
      backgroundColor: BrandColors.background,
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(fontWeight: FontWeight.w800),
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
