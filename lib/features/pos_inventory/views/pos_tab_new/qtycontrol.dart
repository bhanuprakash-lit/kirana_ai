part of '../pos_tab_new.dart';

class _QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QtyControl({
    required this.qty,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
        SizedBox(
          width: 28,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
        _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement),
      ],
    );
  }
}
