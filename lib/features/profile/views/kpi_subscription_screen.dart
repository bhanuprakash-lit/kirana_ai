import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/brand_theme.dart';
import '../providers/kpi_provider.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../subscription/providers/subscription_provider.dart';
import '../../subscription/views/paywall_sheet.dart';

class KpiSubscriptionScreen extends ConsumerStatefulWidget {
  const KpiSubscriptionScreen({super.key});

  @override
  ConsumerState<KpiSubscriptionScreen> createState() =>
      _KpiSubscriptionScreenState();
}

class _KpiSubscriptionScreenState extends ConsumerState<KpiSubscriptionScreen> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final asyncData = ref.watch(kpiProvider);
    final notifier = ref.read(kpiProvider.notifier);

    return asyncData.when(
      loading: () => Scaffold(
        backgroundColor: BrandColors.background,
        appBar: AppBar(title: const Text('Your Insights')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: BrandColors.background,
        appBar: AppBar(title: const Text('Error')),
        body: _ErrorView(
          message: err.toString(),
          onRetry: () => ref.read(kpiProvider.notifier).refresh(),
        ),
      ),
      data: (state) {
        // When no subscriptions exist, auto-enter edit mode so that tapping
        // a KPI doesn't immediately flip back to the empty dashboard view.
        if (!_isEditing && state.subscribedIds.isEmpty) {
          Future.microtask(() {
            if (mounted) setState(() => _isEditing = true);
          });
        }
        final showEditMode = _isEditing || state.subscribedIds.isEmpty;

        return Scaffold(
          backgroundColor: BrandColors.background,
          appBar: AppBar(
            title: Text(showEditMode ? 'Manage KPIs' : 'Your Insights'),
            actions: [
              if (!showEditMode)
                IconButton(
                  icon: const Icon(Icons.settings_suggest_rounded),
                  onPressed: () => setState(() => _isEditing = true),
                  tooltip: 'Manage subscriptions',
                ),
              if (showEditMode && state.subscribedIds.isNotEmpty)
                TextButton(
                  onPressed: () async {
                    await notifier.save();
                    setState(() => _isEditing = false);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: BrandColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          body: showEditMode
              ? _KpiSelectionView(
                  state: state,
                  notifier: notifier,
                  onSave: () async {
                    await notifier.save();
                    setState(() => _isEditing = false);
                  },
                )
              : _KpiDashboardView(
                  state: state,
                  onRefresh: () => notifier.refresh(),
                ),
        );
      },
    );
  }
}

class _KpiSelectionView extends ConsumerWidget {
  final KpiState state;
  final KpiNotifier notifier;
  final VoidCallback onSave;

  const _KpiSelectionView({
    required this.state,
    required this.notifier,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grouped = state.groupedRegistry;
    final tier = ref.watch(subInfoProvider).effectiveTier;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${state.subscribedIds.length} KPIs selected',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: BrandColors.primary,
                  ),
                ),
              ),
              TextButton(
                onPressed: notifier.selectAll,
                child: const Text('Select All'),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: notifier.clearAll,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: grouped.keys.length,
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, i) {
              final categoryName = grouped.keys.elementAt(i);
              final items = grouped[categoryName]!;
              final allSelected = items.every(
                (e) => state.subscribedIds.contains(e.kpiId),
              );
              final categoryInfo = _getCategoryInfo(categoryName);

              return Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: i == 0,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: categoryInfo.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      categoryInfo.icon,
                      size: 18,
                      color: categoryInfo.color,
                    ),
                  ),
                  title: Text(
                    categoryName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: categoryInfo.color.withValues(alpha: 0.8),
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        notifier.toggleCategory(categoryName, !allSelected),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(allSelected ? 'Unselect' : 'Select All'),
                  ),
                  children: items.asMap().entries.map((entry) {
                    final kpi = entry.value;
                    final isSelected = state.subscribedIds.contains(kpi.kpiId);
                    final accessible = state.isKpiAccessible(kpi.kpiId, tier);

                    return ListTile(
                      onTap: () {
                        if (!accessible) {
                          showPaywallSheet(
                            context,
                            featureName: 'Pro KPI: ${kpi.name}',
                            featureDescription: kpi.why,
                            featureIcon: Icons.analytics_rounded,
                          );
                          return;
                        }
                        notifier.toggleKpi(kpi.kpiId);
                      },
                      contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      leading: accessible
                          ? Checkbox(
                              value: isSelected,
                              onChanged: (_) => notifier.toggleKpi(kpi.kpiId),
                              activeColor: BrandColors.primary,
                            )
                          : Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF7C3AED,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.lock_outline_rounded,
                                size: 14,
                                color: Color(0xFF7C3AED),
                              ),
                            ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              kpi.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: accessible
                                    ? BrandColors.ink
                                    : BrandColors.muted,
                              ),
                            ),
                          ),
                          if (!accessible)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C3AED),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      subtitle: Text(
                        kpi.why,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: accessible ? null : BrandColors.muted,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        if (state.subscribedIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('Confirm Selections'),
            ),
          ),
      ],
    );
  }
}

class _KpiDashboardView extends ConsumerWidget {
  final KpiState state;
  final Future<void> Function() onRefresh;

  const _KpiDashboardView({required this.state, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.subscribedData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.analytics_outlined,
              size: 64,
              color: BrandColors.muted,
            ),
            const SizedBox(height: 16),
            const Text(
              'No active KPIs',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your subscriptions to see insights',
              style: TextStyle(color: BrandColors.muted),
            ),
          ],
        ),
      );
    }

    final grouped = state.groupedSubscribedData;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grouped.keys.length,
        itemBuilder: (context, i) {
          final categoryName = grouped.keys.elementAt(i);
          final items = grouped[categoryName]!;
          final categoryInfo = _getCategoryInfo(categoryName);

          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: true,
              tilePadding: EdgeInsets.zero,
              leading: Icon(
                categoryInfo.icon,
                color: categoryInfo.color,
                size: 20,
              ),
              title: Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: BrandColors.ink,
                ),
              ),
              children: items.asMap().entries.map((entry) {
                final kpi = entry.value;
                final registryItem = state.registry.firstWhere(
                  (r) => r.kpiId == kpi.kpiId,
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CompactKpiTile(
                    kpi: kpi,
                    index: entry.key,
                    categoryColor: categoryInfo.color,
                    onTap: () => _showKpiDetail(
                      context,
                      ref,
                      kpi,
                      registryItem,
                      categoryInfo,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  void _showKpiDetail(
    BuildContext context,
    WidgetRef ref,
    KpiData kpi,
    KpiRegistryItem registry,
    _CategoryInfo categoryInfo,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _KpiDetailBottomSheet(
        kpi: kpi,
        registry: registry,
        categoryInfo: categoryInfo,
      ),
    );
  }
}

class _KpiDetailBottomSheet extends ConsumerStatefulWidget {
  final KpiData kpi;
  final KpiRegistryItem registry;
  final _CategoryInfo categoryInfo;

  const _KpiDetailBottomSheet({
    required this.kpi,
    required this.registry,
    required this.categoryInfo,
  });

  @override
  ConsumerState<_KpiDetailBottomSheet> createState() =>
      _KpiDetailBottomSheetState();
}

class _KpiDetailBottomSheetState extends ConsumerState<_KpiDetailBottomSheet> {
  Map<String, dynamic>? _detailData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    if (widget.registry.endpoint == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final data = await ref
        .read(kpiProvider.notifier)
        .fetchKpiDetail(widget.registry.endpoint!);

    if (mounted) {
      setState(() {
        _detailData = data;
        _isLoading = false;
        if (data == null) _error = 'Failed to load live insights';
      });
    }
  }

  Future<void> _launchWhatsApp(String message) async {
    final url = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(message)}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Widget? _buildSmartAction(BuildContext context, WidgetRef ref) {
    final endpoint = widget.registry.endpoint ?? '';
    String? label;
    IconData? icon;
    VoidCallback? onTap;

    if (endpoint.contains('stock') ||
        endpoint.contains('inventory') ||
        endpoint.contains('readiness')) {
      label = 'Manage Inventory';
      icon = Icons.inventory_2_rounded;
      onTap = () {
        Navigator.pop(context); // Close bottom sheet
        context.go('/home');
        ref.read(dashboardTabProvider.notifier).switchTab(2);
        ref.read(dashboardSubTabProvider.notifier).setSubTab(1);
      };
    } else if (endpoint.contains('udhar') ||
        endpoint.contains('customer') ||
        endpoint.contains('credit')) {
      label = 'Send Reminders';
      icon = Icons.mark_email_unread_rounded;
      onTap = () => _launchWhatsApp(
        'Hi, this is a reminder regarding your business with us. Please check your latest updates.',
      );
    } else if (endpoint.contains('revenue') || endpoint.contains('sales')) {
      label = 'New Sale';
      icon = Icons.point_of_sale_rounded;
      onTap = () {
        Navigator.pop(context); // Close bottom sheet
        context.go('/home');
        ref.read(dashboardTabProvider.notifier).switchTab(2);
        ref.read(dashboardSubTabProvider.notifier).setSubTab(0);
      };
    }

    if (label == null) return null;

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          backgroundColor: widget.categoryInfo.color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: BrandColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BrandColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: widget.categoryInfo.color.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                widget.categoryInfo.icon,
                                color: widget.categoryInfo.color,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.kpi.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: BrandColors.ink,
                                    ),
                                  ),
                                  Text(
                                    widget.registry.category,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: widget.categoryInfo.color,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _SectionHeader(
                          title: 'AI Summary',
                          icon: Icons.auto_awesome_rounded,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                BrandColors.primary.withValues(alpha: 0.05),
                                Colors.white,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: BrandColors.primary.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.registry.why,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: BrandColors.ink,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Divider(height: 24),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.support_agent_rounded,
                                    size: 14,
                                    color: BrandColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Powered by ${widget.registry.aiAgent}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: BrandColors.primary,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SectionHeader(
                                    title: 'Target',
                                    icon: Icons.track_changes_rounded,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.registry.target,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: BrandColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SectionHeader(
                                    title: 'Baseline',
                                    icon: Icons.flag_rounded,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.registry.baseline,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: BrandColors.ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        _SectionHeader(
                          title: 'Live Data Breakdown',
                          icon: Icons.bar_chart_rounded,
                        ),
                        const SizedBox(height: 12),

                        if (_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (_error != null)
                          _ErrorView(message: _error!, onRetry: _fetchDetail)
                        else if (_detailData != null) ...[
                          _DetailGrid(data: _detailData!),
                          if (_detailData!['ml_insights'] != null) ...[
                            const SizedBox(height: 24),
                            _SectionHeader(
                              title: 'MI Insights',
                              icon: Icons.psychology_rounded,
                            ),
                            const SizedBox(height: 12),
                            _MlInsightsView(
                              insights: _detailData!['ml_insights'],
                            ),
                          ],
                        ] else
                          const Text(
                            'No dynamic insights available for this KPI.',
                          ),

                        _buildSmartAction(context, ref) ??
                            const SizedBox.shrink(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: BrandColors.muted),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: BrandColors.muted,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _DetailGrid extends StatelessWidget {
  final Map<String, dynamic> data;
  const _DetailGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final excludedKeys = {
      'kpi_id',
      'kpi_key',
      'kpi_name',
      'store_id',
      'store_name',
      'period_days',
      'period_from',
      'period_to',
      'target',
      'trend',
      'last_updated',
      'primary_field',
      'primary_value',
      'ml_insights',
    };
    final entries = data.entries
        .where(
          (e) =>
              !excludedKeys.contains(e.key) &&
              e.value is! List &&
              e.value is! Map,
        )
        .toList();

    if (entries.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final key = entries[i].key.replaceAll('_', ' ').titleCase;
        final val = entries[i].value;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BrandColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                key,
                style: const TextStyle(
                  fontSize: 9,
                  color: BrandColors.muted,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
              ),
              Text(
                _formatVal(val),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: BrandColors.ink,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatVal(dynamic v) {
    if (v is double) return v.toStringAsFixed(1);
    return v.toString();
  }
}

class _MlInsightsView extends StatelessWidget {
  final dynamic insights;
  const _MlInsightsView({required this.insights});

  @override
  Widget build(BuildContext context) {
    if (insights is! Map) return Text(insights.toString());

    final map = insights as Map<String, dynamic>;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: map.entries.map((e) {
          if (e.value is List)
            return const SizedBox.shrink(); // Skip complex lists for now
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.key.replaceAll('_', ' ').titleCase,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BrandColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  e.value.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: BrandColors.ink,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

extension StringExtension on String {
  String get titleCase => split(' ')
      .map(
        (e) => e.isEmpty
            ? ''
            : '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}',
      )
      .join(' ');
}

class _CompactKpiTile extends StatelessWidget {
  final KpiData kpi;
  final int index;
  final Color categoryColor;
  final VoidCallback onTap;

  const _CompactKpiTile({
    required this.kpi,
    required this.index,
    required this.categoryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final trendColor = kpi.trendDirection == 'up'
        ? BrandColors.success
        : kpi.trendDirection == 'down'
        ? BrandColors.error
        : BrandColors.muted;

    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BrandColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Positioned(
                  right: 16,
                  bottom: 40,
                  top: 16,
                  width: 60,
                  child: CustomPaint(
                    painter: _SparklinePainter(
                      color: trendColor,
                      isUp: kpi.trendDirection == 'up',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.insights_rounded,
                              size: 20,
                              color: categoryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kpi.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: BrandColors.ink,
                                  ),
                                ),
                                if (kpi.trendPctChange != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Row(
                                      children: [
                                        Icon(
                                          kpi.trendDirection == 'up'
                                              ? Icons.trending_up_rounded
                                              : Icons.trending_down_rounded,
                                          size: 12,
                                          color: trendColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${kpi.trendPctChange!.abs().toStringAsFixed(1)}% vs last period',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: trendColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatValue(kpi.value),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: BrandColors.ink,
                                ),
                              ),
                              const Text(
                                'current',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: BrandColors.muted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Why this value?',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: categoryColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 10,
                            color: categoryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 40 * index))
        .slideX(begin: 0.05, end: 0);
  }

  String _formatValue(dynamic v) {
    if (v == null) return '—';
    if (v is double) {
      if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L';
      if (v >= 1000) return '₹${(v / 1000).toStringAsFixed(1)}K';
      return '₹${v.toStringAsFixed(1)}';
    }
    if (v is int) {
      if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
      return v.toString();
    }
    return v.toString();
  }
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  final bool isUp;

  _SparklinePainter({required this.color, required this.isUp});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (isUp) {
      path.moveTo(0, size.height * 0.7);
      path.quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.7,
        size.width * 0.5,
        size.height * 0.4,
      );
      path.quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.2,
        size.width,
        size.height * 0.1,
      );
    } else {
      path.moveTo(0, size.height * 0.3);
      path.quadraticBezierTo(
        size.width * 0.3,
        size.height * 0.3,
        size.width * 0.5,
        size.height * 0.6,
      );
      path.quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.8,
        size.width,
        size.height * 0.9,
      );
    }

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width, isUp ? size.height * 0.1 : size.height * 0.9),
      2.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CategoryInfo {
  final IconData icon;
  final Color color;
  const _CategoryInfo(this.icon, this.color);
}

_CategoryInfo _getCategoryInfo(String category) {
  final cat = category.toLowerCase();
  if (cat.contains('finance'))
    return const _CategoryInfo(
      Icons.account_balance_rounded,
      Color(0xFF0891B2),
    );
  if (cat.contains('sales'))
    return const _CategoryInfo(Icons.shopping_bag_rounded, Color(0xFFEA580C));
  if (cat.contains('customer'))
    return const _CategoryInfo(Icons.people_rounded, Color(0xFF7C3AED));
  if (cat.contains('inventory'))
    return const _CategoryInfo(Icons.inventory_2_rounded, Color(0xFF059669));
  if (cat.contains('risk'))
    return const _CategoryInfo(Icons.warning_rounded, Color(0xFFDC2626));
  if (cat.contains('operations'))
    return const _CategoryInfo(
      Icons.settings_suggest_rounded,
      Color(0xFF4B5563),
    );
  if (cat.contains('insights'))
    return const _CategoryInfo(Icons.stars_rounded, BrandColors.primary);
  return const _CategoryInfo(Icons.analytics_rounded, BrandColors.muted);
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: BrandColors.muted,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: BrandColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
