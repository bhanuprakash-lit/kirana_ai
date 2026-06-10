// Kirana AI — iOS home-screen widgets (WidgetKit).
//
// Three widgets mirroring the Android set:
//   • KiranaMediumWidget  (systemMedium) — 4-stat "Today at a glance"
//   • KiranaNewSaleWidget (systemSmall)  — opens the item scanner
//   • KiranaVisionWidget  (systemSmall)  — Vision AI (coming soon)
//
// Data is written by the Flutter app via the `home_widget` plugin into the
// shared App Group UserDefaults (group.com.lohiya.kiranaAi). The keys here MUST
// match what HomeWidgetService writes (lib/core/services/home_widget_service.dart).
//
// SETUP (Mac/Xcode): see docs/IOS_WIDGET_SETUP.md. This file is drop-in source;
// it is added to a Widget Extension target created in Xcode.

import WidgetKit
import SwiftUI

private let appGroupId = "group.com.lohiya.kiranaAi"

private func widgetDefaults() -> UserDefaults? { UserDefaults(suiteName: appGroupId) }
private func str(_ key: String, _ fallback: String = "") -> String {
    widgetDefaults()?.string(forKey: key) ?? fallback
}
private func flag(_ key: String) -> Bool { str(key) == "true" }

// MARK: - Brand colors

private extension Color {
    static let kNavy  = Color(red: 0x24 / 255, green: 0x3B / 255, blue: 0x6B / 255)
    static let kAmber = Color(red: 0xF5 / 255, green: 0x9E / 255, blue: 0x0B / 255)
    static let kSlate = Color(red: 0xAE / 255, green: 0xBB / 255, blue: 0xD4 / 255)
    static let kRed   = Color(red: 0xFC / 255, green: 0xA5 / 255, blue: 0xA5 / 255)
    static let kStamp = Color(red: 0x8A / 255, green: 0x9B / 255, blue: 0xBF / 255)
}

private extension View {
    /// Navy widget background, compatible with iOS 14–16 and the iOS 17+
    /// `containerBackground` requirement.
    @ViewBuilder
    func kBackground() -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(Color.kNavy, for: .widget)
        } else {
            self.background(Color.kNavy)
        }
    }
}

// MARK: - Medium widget (data-driven)

private struct KiranaSnapshot {
    let loggedIn: Bool
    let updated: String
    let emptyMsg: String
    let salesLabel, salesValue, salesSub: String
    let udhaarLabel, udhaarValue, udhaarSub: String
    let udhaarAlert: Bool
    let stockLabel, stockValue, stockSub: String
    let stockAlert: Bool
    let supplierLabel, supplierValue, supplierSub: String
    let supplierAlert: Bool
    let newbillLabel: String

    static func load() -> KiranaSnapshot {
        KiranaSnapshot(
            loggedIn: flag("logged_in"),
            updated: str("updated_at"),
            emptyMsg: str("empty_msg", "Open Kirana AI"),
            salesLabel: str("sales_label", "Today's Sales"),
            salesValue: str("sales_value", "—"),
            salesSub: str("sales_sub"),
            udhaarLabel: str("udhaar_label", "Udhaar Due"),
            udhaarValue: str("udhaar_value", "—"),
            udhaarSub: str("udhaar_sub"),
            udhaarAlert: flag("udhaar_alert"),
            stockLabel: str("stock_label", "Low Stock"),
            stockValue: str("stock_value", "—"),
            stockSub: str("stock_sub", "items"),
            stockAlert: flag("stock_alert"),
            supplierLabel: str("supplier_label", "Pay Today"),
            supplierValue: str("supplier_value", "—"),
            supplierSub: str("supplier_sub"),
            supplierAlert: flag("supplier_alert"),
            newbillLabel: str("newbill_label", "+ New Bill")
        )
    }
}

private struct KiranaEntry: TimelineEntry {
    let date: Date
    let snap: KiranaSnapshot
}

private struct KiranaProvider: TimelineProvider {
    func placeholder(in context: Context) -> KiranaEntry {
        KiranaEntry(date: Date(), snap: .load())
    }
    func getSnapshot(in context: Context, completion: @escaping (KiranaEntry) -> Void) {
        completion(KiranaEntry(date: Date(), snap: .load()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<KiranaEntry>) -> Void) {
        // The app reloads timelines on foreground/background; this is a safety refresh.
        let next = Calendar.current.date(byAdding: .minute, value: 30, to: Date())!
        completion(Timeline(entries: [KiranaEntry(date: Date(), snap: .load())], policy: .after(next)))
    }
}

private struct KiranaMediumView: View {
    let snap: KiranaSnapshot

    var body: some View {
        Group {
            if snap.loggedIn {
                content
            } else {
                Text(snap.emptyMsg)
                    .font(.system(size: 13))
                    .foregroundColor(.kSlate)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .kBackground()
        .widgetURL(URL(string: "kiranaai://w?tab=overview"))
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text("Kirana").foregroundColor(.white).bold()
                Text("AI").foregroundColor(.kAmber).bold().padding(.leading, 3)
                Spacer()
                Text(snap.updated).font(.system(size: 10)).foregroundColor(.kStamp)
            }
            HStack(spacing: 12) {
                cell(snap.salesValue, snap.salesLabel, snap.salesSub, false,
                     "kiranaai://w?tab=overview")
                cell(snap.udhaarValue, snap.udhaarLabel, snap.udhaarSub, snap.udhaarAlert,
                     "kiranaai://w?tab=finance&subtab=0")
            }
            HStack(spacing: 12) {
                cell(snap.stockValue, snap.stockLabel, snap.stockSub, snap.stockAlert,
                     "kiranaai://w?tab=pos&subtab=1")
                cell(snap.supplierValue, snap.supplierLabel, snap.supplierSub, snap.supplierAlert,
                     "kiranaai://w?tab=finance&subtab=1")
            }
            linkWrap("kiranaai://w?tab=pos&subtab=0&action=scan") {
                Text(snap.newbillLabel)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.kNavy)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.kAmber)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private func cell(_ value: String, _ label: String, _ sub: String,
                      _ alert: Bool, _ url: String) -> some View {
        linkWrap(url) {
            VStack(alignment: .leading, spacing: 1) {
                Text(value).font(.system(size: 19, weight: .bold)).foregroundColor(.white)
                Text(label).font(.system(size: 11)).foregroundColor(.kSlate)
                Text(sub).font(.system(size: 10)).foregroundColor(alert ? .kRed : .kSlate)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// Per-region deep links use `Link` (iOS 17+). On older iOS the whole-widget
    /// `.widgetURL` (overview) applies instead.
    @ViewBuilder
    private func linkWrap<Content: View>(_ url: String,
                                         @ViewBuilder _ content: () -> Content) -> some View {
        if #available(iOS 17.0, *), let u = URL(string: url) {
            Link(destination: u) { content() }
        } else {
            content()
        }
    }
}

struct KiranaMediumWidget: Widget {
    let kind = "KiranaMediumWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: KiranaProvider()) { entry in
            KiranaMediumView(snap: entry.snap)
        }
        .configurationDisplayName("Today at a glance")
        .description("Sales, udhaar dues, low stock and supplier payments.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Small action widgets (static)

private struct ActionEntry: TimelineEntry { let date: Date }

private struct ActionProvider: TimelineProvider {
    func placeholder(in context: Context) -> ActionEntry { ActionEntry(date: Date()) }
    func getSnapshot(in context: Context, completion: @escaping (ActionEntry) -> Void) {
        completion(ActionEntry(date: Date()))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<ActionEntry>) -> Void) {
        completion(Timeline(entries: [ActionEntry(date: Date())], policy: .never))
    }
}

private struct ActionTile: View {
    let systemIcon: String
    let iconColor: Color
    let label: String
    let labelColor: Color
    let url: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemIcon).font(.system(size: 30)).foregroundColor(iconColor)
            Text(label).font(.system(size: 10, weight: .bold)).foregroundColor(labelColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .kBackground()
        .widgetURL(URL(string: url))
    }
}

struct KiranaNewSaleWidget: Widget {
    let kind = "KiranaNewSaleWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ActionProvider()) { _ in
            ActionTile(systemIcon: "qrcode.viewfinder", iconColor: .white,
                       label: "New Sale", labelColor: .kAmber,
                       url: "kiranaai://w?tab=pos&subtab=0&action=scan")
        }
        .configurationDisplayName("New Sale")
        .description("Start a new sale — opens the item scanner.")
        .supportedFamilies([.systemSmall])
    }
}

struct KiranaVisionWidget: Widget {
    let kind = "KiranaVisionWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ActionProvider()) { _ in
            ActionTile(systemIcon: "sparkles", iconColor: .kAmber,
                       label: "Vision AI", labelColor: .white,
                       url: "kiranaai://w?tab=overview&action=vision")
        }
        .configurationDisplayName("Vision AI")
        .description("Vision AI — scan and recognise products (coming soon).")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Bundle

@main
struct KiranaWidgetBundle: WidgetBundle {
    var body: some Widget {
        KiranaMediumWidget()
        KiranaNewSaleWidget()
        KiranaVisionWidget()
    }
}
