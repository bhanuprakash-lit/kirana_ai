part of '../udhaar_tab_new.dart';

class _SettledSection extends StatefulWidget {
  final List<_CustomerUdhaar> groups;
  const _SettledSection({required this.groups});

  @override
  State<_SettledSection> createState() => _SettledSectionState();
}

class _SettledSectionState extends State<_SettledSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: BrandColors.surfaceTint,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: BrandColors.muted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.finSettledSectionTitle(widget.groups.length),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: BrandColors.muted,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: BrandColors.muted,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            ...widget.groups.map(
              (g) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: BrandColors.muted.withValues(
                        alpha: 0.15,
                      ),
                      child: Text(
                        g.customerName.isNotEmpty
                            ? g.customerName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: BrandColors.muted,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        g.customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: BrandColors.ink,
                        ),
                      ),
                    ),
                    Text(
                      l10n.finSettled,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BrandColors.success,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

