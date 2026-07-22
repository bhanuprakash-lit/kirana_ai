/// V1 — per-vertical bottom-navigation presets.
///
/// The nav bar finally reflects the trade: a salon's day starts at the
/// appointment book, an electronics store lives in repairs, a boutique in
/// estimates/orders. Tabs are addressed by semantic id everywhere (deep
/// links, quick actions, FABs) and resolved to an index through the active
/// preset — never by hardcoded position.
///
/// Vision shows for EVERY vertical (per V0.3 the detector-uncovered ones get
/// a coming-soon screen inside the tab), so non-grocery presets run 5 tabs.
enum NavTabId { home, khata, billing, vision, appointments, repairs, orders }

List<NavTabId> navPresetFor(String verticalCode) {
  switch (verticalCode) {
    // Appointment-driven trades: the booking calendar is slot 2.
    case 'services':
    case 'optical':
      return const [
        NavTabId.home,
        NavTabId.appointments,
        NavTabId.billing,
        NavTabId.khata,
        NavTabId.vision,
      ];
    // Repairs (job cards) are the counter's second workflow.
    case 'electronics':
      return const [
        NavTabId.home,
        NavTabId.billing,
        NavTabId.repairs,
        NavTabId.khata,
        NavTabId.vision,
      ];
    // Estimates / returns are the boutique's paperwork.
    case 'apparel':
    case 'footwear':
    // PAI-3 — split out of apparel; same day shape (sell, then paperwork).
    case 'boutique':
    case 'sports_fitness':
    case 'cosmetics':
      return const [
        NavTabId.home,
        NavTabId.billing,
        NavTabId.orders,
        NavTabId.khata,
        NavTabId.vision,
      ];
    // Plain retail: billing first, no extra module tab.
    case 'general':
      return const [
        NavTabId.home,
        NavTabId.billing,
        NavTabId.khata,
        NavTabId.vision,
      ];
    // Bakery runs a grocery-shaped counter day, minus the shelf Vision that
    // only recognises packaged kirana goods.
    case 'bakery':
      return const [
        NavTabId.home,
        NavTabId.billing,
        NavTabId.khata,
        NavTabId.vision,
      ];
    // Grocery — the historical order, unchanged.
    default:
      return const [
        NavTabId.home,
        NavTabId.khata,
        NavTabId.billing,
        NavTabId.vision,
      ];
  }
}
