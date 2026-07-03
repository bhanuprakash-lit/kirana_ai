part of '../udhaar_tab_new.dart';

class UdhaarTab extends ConsumerWidget {
  const UdhaarTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(financeProvider);
    final l10n = AppLocalizations.of(context);

    return asyncData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(20),
        child: ListShimmer(itemCount: 6),
      ),
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: BrandColors.error),
            const SizedBox(height: 16),
            Text(
              l10n.finFailedLoadUdhaar,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.finCheckConnection,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(financeProvider.notifier).refresh(),
              child: Text(l10n.finRetry),
            ),
          ],
        ),
      ),
      data: (data) {
        // Group the flat khata list by customer so each customer shows as one
        // expandable card instead of one row per udhaar sale. Active customers
        // (with an open balance) come first, sorted by largest balance; fully
        // settled customers drop into a muted collapsed section.
        final groups = _groupByCustomer(data.udhaarList);
        final active = groups.where((g) => !g.isSettled).toList()
          ..sort((a, b) => b.totalBalance.compareTo(a.totalBalance));
        final settled = groups.where((g) => g.isSettled).toList();
        return RefreshIndicator.adaptive(
          onRefresh: () => ref.read(financeProvider.notifier).refresh(),
          color: BrandColors.primary,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _UdhaarStatsCard(stats: data.stats),
              const SizedBox(height: 16),
              if (data.udhaarList.isNotEmpty) ...[
                _SmartRemindersBanner(
                  highRisk: ref.watch(highRiskUdhaarCountProvider),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SmartRemindersScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.finCustomerDues,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _showAddUdhaarSheet(context, ref),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: Text(l10n.finNewUdhaar),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (data.udhaarList.isEmpty)
                const _EmptyUdhaar()
              else ...[
                for (final group in active) _CustomerUdhaarCard(group: group),
                if (settled.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _SettledSection(groups: settled),
                ],
              ],
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _showAddUdhaarSheet(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AddUdhaarSheet(
        ref: ref,
        nameController: nameController,
        amountController: amountController,
        phoneController: phoneController,
        onContactPick: (name, p) {
          nameController.text = name;
          phoneController.text = p;
        },
      ),
    );
  }
}
