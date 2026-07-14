# Kirana AI — User Manual

A complete, plain-language guide for store owners using the Kirana AI app.
This manual walks you through every screen, every button, and what happens
when you tap it — including all the newer features for non-grocery shops
(clothing, footwear, electronics, optical, salons/services and more).

> Looking for how the camera "shelf scanning" works in detail? See the
> separate **[Vision AI User Guide](VISION_AI_USER_GUIDE.md)**.
> Developer documentation lives in [`DEVELOPER_GUIDE.md`](DEVELOPER_GUIDE.md).

**Last updated:** July 2026 · Covers multi-vertical stores, product variants,
GST billing, the Vision AI tab, and all the operations/marketing modules.

---

## Table of Contents

1. [Before You Start](#1-before-you-start)
2. [What Kind of Shop Are You? (Verticals)](#2-what-kind-of-shop-are-you-verticals)
3. [First Launch — Splash Screen](#3-first-launch--splash-screen)
4. [Sign Up — Onboarding](#4-sign-up--onboarding)
5. [Logging In](#5-logging-in)
6. [Choosing Your Trial Plan](#6-choosing-your-trial-plan)
7. [The Home Dashboard & Bottom Tabs](#7-the-home-dashboard--bottom-tabs)
8. [Tab 1 — Home (Overview)](#8-tab-1--home-overview)
9. [Tab 2 — Khata (Finance)](#9-tab-2--khata-finance)
10. [Tab 3 — Billing (POS / Stock / Purchase)](#10-tab-3--billing-pos--stock--purchase)
11. [Tab 4 — Vision (Camera Stock)](#11-tab-4--vision-camera-stock)
12. [Product Variants (Sizes, Colours, Models)](#12-product-variants-sizes-colours-models)
13. [GST & Tax on Bills](#13-gst--tax-on-bills)
14. [The Profile Screen — Your Control Centre](#14-the-profile-screen--your-control-centre)
15. [Customers Section](#15-customers-section)
16. [Operations Section](#16-operations-section)
    - [Staff](#161-staff)
    - [Estimates & Returns](#162-estimates--returns)
    - [Stock Racks](#163-stock-racks)
    - [Job Cards / Repairs](#164-job-cards--repairs)
    - [Warranty & Serials](#165-warranty--serials)
    - [GST Report](#166-gst-report)
17. [Sales & Marketing Section](#17-sales--marketing-section)
    - [My Baskets](#171-my-baskets)
    - [Loyalty & Offers](#172-loyalty--offers)
    - [Services & Appointments](#173-services--appointments)
18. [Analytics Section](#18-analytics-section)
    - [KPI Subscriptions](#181-kpi-subscriptions)
    - [Transaction History](#182-transaction-history)
    - [Store Comparison](#183-store-comparison)
19. [Store & Account Section](#19-store--account-section)
    - [Switch Store](#191-switch-store)
    - [Language](#192-language)
    - [Store Settings](#193-store-settings)
    - [Configuration](#194-configuration)
    - [Password & Security](#195-password--security)
20. [Plan & Support Section](#20-plan--support-section)
    - [Subscription & Plans](#201-subscription--plans)
    - [Cashflow Support](#202-cashflow-support)
    - [Help & Support](#203-help--support)
21. [Notifications](#21-notifications)
22. [Signing Out](#22-signing-out)
23. [Troubleshooting](#23-troubleshooting)
24. [Quick Glossary](#24-quick-glossary)

---

## 1. Before You Start

**What you need:**

- An Android phone (the app is optimised for Android; iOS is in testing).
- A working SIM with an active mobile number for OTP verification.
- An internet connection — the app needs the server to load products,
  place orders and sync data.
- Permission to use your phone's location, camera, contacts and microphone.
  The app asks for each only the first time you use the related feature.

**What the symbols in this manual mean:**

| Symbol | Meaning |
| --- | --- |
| **Tap** | A single press on a button, icon, or row. |
| **Long-press** | Press and hold for about one second. |
| **Swipe left / right** | Drag your finger left or right on a row. |
| **Pull down** | Drag the screen downward from the top — refreshes the data. |
| 🔒 **Pro** | Feature only on the Pro plan. The app shows an upgrade prompt on Basic. |
| 🏷️ **Vertical** | Feature only appears for certain shop types (see §2). |

---

## 2. What Kind of Shop Are You? (Verticals)

Kirana AI is no longer only for grocery shops. When you sign up you pick your
**store type**, and the app quietly rearranges itself to suit that kind of
business. Behind the scenes each store type maps to one of **seven behaviour
profiles** ("verticals"):

| Store types you can pick | Vertical | What changes |
| --- | --- | --- |
| Kirana / General, Supermarket, Provision, Fruits & Veg, Pharmacy, Bakery & Sweets | **Grocery** | Expiry dates, loose/by-weight selling, kg/g/L units, the Vision camera tab |
| Clothing & Apparel, Boutique, Mono-brand | **Apparel** | Size/colour **variants**, no expiry/loose, GST fields |
| Footwear | **Footwear** | Size variants (pairs), GST |
| Mobile & Electronics | **Electronics** | Model/storage variants, **serial/IMEI + warranty**, GST |
| Optical | **Optical** | Variants, **warranty**, **appointments**, prescriptions |
| Salon & Parlour, Sports & Fitness | **Services** | **Appointments & memberships**, services catalogue, no stock-by-weight |
| Fancy & Gift, Stationery & Books | **General** | Simple piece-based selling |

You don't need to memorise this. The practical effect is:

- **A grocery shop** sees expiry dates, loose-weight billing and the Vision
  camera tab, exactly as before.
- **A clothing/footwear/electronics/optical shop** sees size/colour/model
  choices ("variants"), GST fields on products, and — where relevant —
  warranty tracking, job cards and appointments.
- **A salon/fitness studio** sees an Appointments calendar and a services
  menu instead of a grocery-style stock list.

Menu rows and tabs that don't apply to your shop simply don't appear. You can
change your store type later from **Profile → Store Settings** if you picked
the wrong one.

---

## 3. First Launch — Splash Screen

When you open the app you see the Kirana AI logo on a deep-blue background
with the tagline *"Smart business, smarter you"* and a small spinner. This
screen lasts about 1.6 seconds while the app checks:

1. **Whether the app is temporarily disabled** by the team (a maintenance
   message appears if so).
2. **Whether you've completed onboarding.** If not, you go to Onboarding.
3. **Whether your store has been blocked** (a block screen with the reason).
4. **Whether you have a valid login session** (sessions last 30 days). If
   valid, you go straight to the dashboard; otherwise to the Login screen.

You never interact with this screen — it only decides where to send you.

---

## 4. Sign Up — Onboarding

This appears the first time you open the app, or when you tap **Create one**
on the login screen. A progress indicator at the top shows which step you're
on.

### Step 1 — Welcome

Three auto-rotating slides introduce the app. Tap **Get Started** to
continue, or **Already have an account? Sign In** to log in.

### Step 2 — Verify Your Phone Number

1. **Enter phone number** — type your 10-digit mobile number (the **+91**
   prefix is fixed) and tap **Send OTP**.
2. **Enter the OTP** — type the 6-digit code from the SMS. It auto-submits on
   the sixth digit. **Resend OTP** is available if it doesn't arrive.
3. **Choose a username** — letters, numbers and underscores only, 3–30
   characters. The app checks availability as you type (green tick = free,
   red cross = taken). Tap **Continue**.

> If your number is already registered, verification takes you straight to
> the dashboard and skips the rest of onboarding.

### Step 3 — Tell Us About Your Store

| Field | What to enter |
| --- | --- |
| Owner's full name | Your name, e.g. *Ramesh Kumar*. |
| Store name | Display name, e.g. *Sri Lakshmi Stores*. |
| Email address | A valid email — used for receipts and support. |
| **Store type** | Pick from the full list (Kirana, Supermarket, Clothing, Footwear, Electronics, Optical, Salon, Fitness, Stationery, Bakery, and more). **This sets your vertical (§2).** |
| Estimated daily customers | A whole number, e.g. *40*. Helps the AI tune predictions. |

Tap **Continue**.

### Step 4 — Where Is Your Store Located?

- Tap **Detect My Location** to fill address and city from GPS, **or**
- Type **Store address** and **City / District** manually.

Both an address and a city are required. Tap **Continue**.

### Step 5 — Review & Agree

Read the **Terms & Conditions** and **Privacy Policy** cards, tick both
checkboxes, then tap **Complete Setup**. Your account is created, your device
is registered for notifications, and you land on the trial-plan screen (new
accounts) or the dashboard.

---

## 5. Logging In

If you already have an account, the Login screen has two tabs.

### Tab 1 — Phone OTP (recommended)

Type your registered 10-digit number, tap **Send OTP** (or keep typing — it
sends automatically after 10 digits), then type the 6-digit code. Login
completes on the sixth digit.

### Tab 2 — Username

Type your username and password (tap the eye icon to reveal it), then tap
**Sign In**. Wrong details show *"Incorrect username or password."*; network
problems show *"Could not connect to the server."*

**"Don't have an account? Create one"** at the bottom starts Onboarding.

---

## 6. Choosing Your Trial Plan

The first time you sign in on a brand-new account you see **Welcome to Kirana
AI — Choose a plan to trial free**.

| Plan | Price | What you get |
| --- | --- | --- |
| **Basic** | ₹200 / month | POS & Sales · Inventory · Finance & Udhaar · KPI Insights (3 per category) · AI Recommendations |
| **Pro** (*ALL FEATURES*) | ₹500 / month | Everything in Basic + all KPI categories + Vendor/Procurement + Vision AI camera tab + Cashflow Support (up to ₹10 L) + Customer Growth |

Tap a card to select it, then tap **Request Basic Trial** / **Request Pro
Trial**. Your request goes to the team for approval.

**Pending Activation:** while waiting you see *"Trial Request Received!"* with
an orange hourglass. Approval usually takes a few hours; you get a push
notification when it's active. Pull down to re-check. You can sign out with
*"Sign in to a different account"* near the bottom.

---

## 7. The Home Dashboard & Bottom Tabs

After your trial is active you land on the main dashboard. The **bottom tabs**
depend on your shop type:

| Icon | Tab | Purpose | Who sees it |
| --- | --- | --- | --- |
| 🏠 | **Home** | Daily overview, AI insights, today's sales | Everyone |
| 📖 | **Khata** | Customer credit (udhaar) & supplier credit | Everyone |
| 🏬 | **Billing** | POS / Inventory / Procurement | Everyone |
| 🎯 | **Vision** | Camera stock counting (see §11) | Grocery-family shops on Pro |

Tap a tab to switch; each keeps its scroll position. If your trial expires
without a paid plan, an **Upgrade Wall** covers the dashboard until you
subscribe.

---

## 8. Tab 1 — Home (Overview)

Scrolling top to bottom:

1. **Greeting header** — "Good morning/afternoon/evening, *Your Name*", the
   date, your store name, and a **notification bell** (top right).
2. **Morning Briefing ribbon** (only if something is urgent) — a coloured
   strip summarising the day's most important alerts. Tap it to jump to
   Inventory.
3. **Pro Alerts strip** 🔒 — coloured chips for overdue udhaar, low stock,
   expiring items, etc. Tap a chip to jump to its source.
4. **Intelligence cards** — four AI cards: **Fast Moving**, **Stockout
   Risk**, **Reorder Required**, **High Profit**. Tap one to open a full
   ranked list.
5. **Today's Sales card** — revenue billed today, number of orders, average
   order value.
6. **KPI summary row** — the KPIs you've subscribed to as live metric cards
   (empty until you pick some in Profile → KPI Subscriptions).
7. **Store Overview card** — footfall, budget, daily budget, SKU count.

**What you can do:** pull down to refresh · tap the bell for notifications ·
tap an intelligence card to drill in · tap **+ New Sale** (floating button)
to jump to POS billing.

---

## 9. Tab 2 — Khata (Finance)

A two-tab screen for tracking credit. The header always shows **Monthly
Sales** and **Monthly SKUs**.

### Sub-tab A — Udhaar (Customer Credit)

Customers who took goods on credit.

- A summary card shows total outstanding across all customers.
- A list of every customer with an open balance.

**Actions:**

- **+ New Udhaar** — record a credit entry: customer name (or tap the
  contact-picker), phone, amount. Tap **Save**.
- **Tap a customer** to see their full credit history (every credit and
  payment with timestamps).
- **WhatsApp reminder icon** — opens WhatsApp with a pre-written reminder.
- **Record Payment** — when a customer pays back, open the row, tap **Record
  Payment**, enter the amount, confirm. The balance updates immediately.
- You can set an optional **due date** on a credit so overdue amounts stand
  out.

### Sub-tab B — Suppliers (Distributor Credit)

Money you owe suppliers.

- Total payable at the top, then each supplier with their outstanding amount.
- Tap a supplier to see the individual purchase orders. Mark a purchase
  **paid** to clear it.

---

## 10. Tab 3 — Billing (POS / Stock / Purchase)

The heart of daily operations. The header shows a green **POS Online** or red
**POS Offline** badge. Three sub-tabs:

| Icon | Sub-tab | Purpose |
| --- | --- | --- |
| 🧾 | **Billing** | Sell products to a customer |
| 📦 | **Stock** | Manage your inventory |
| 🚚 | **Purchase** | Suppliers & purchase orders 🔒 Pro |

### 10.1 Billing (POS)

#### Top bar

| Icon | Action |
| --- | --- |
| Search field | Type a product name, brand, or barcode; tap a match to add. |
| 🎁 Gift (amber) | **Scan referral QR** brought by a new customer. |
| 📷 QR (blue) | **Scan barcode** — continuous barcode scanning. |
| 🧾 Receipt | Today's orders sheet. |
| 🔄 Refresh | Reload products from the server. |

#### AI entry strip 🔒

Two Pro pills below the search bar:

- **Voice Order** 🎙️ — record a customer reading out their order; the AI turns
  it into a cart. For non-grocery shops the AI also captures details like
  size, colour or model.
- **Handwrite** ✍️ — photograph a handwritten list; the AI parses it into cart
  items.

Pro users see a daily counter (e.g. "Voice 4/10"); others see a lock.

#### Building a cart

- **By search:** type a name, tap **+** on a row. For **loose items**
  (grocery, sold by weight), a dialog asks for the quantity.
- **By variant:** if a product has sizes/colours/models, a **variant picker**
  appears so you choose the exact one — stock is deducted from that variant
  (see §12).
- **By barcode:** tap the blue QR icon, point at barcodes; each scan adds to a
  list. Unknown barcodes offer **Add as New** or **Link to Existing Item**.
  Tap **Add to Cart** when done.

#### Bundles & Deals (empty cart)

When the cart is empty, the screen shows **Bundles & Deals** — your own
baskets (sky-blue cards) and AI-suggested campaigns. Each card shows an
in-stock pill (e.g. "5/6") and an **Add to Cart** button that adds all
available items in one tap. Tap **Refresh AI** for new suggestions.

#### The cart

Each row shows image, name, brand, unit price, a −/number/+ control and the
line total. **Swipe left** to remove a row. **Clear** empties the cart (asks
first). A **FREQUENTLY BOUGHT TOGETHER** strip suggests up to 5 add-ons.

#### Checkout

- **Customer banner** — tap to pick a customer (search, or **+ New**,
  including from phone contacts). A selected customer shows as a coloured
  strip.
- **Loyalty & coupons** 🔒 — if the customer has loyalty points or a valid
  coupon, you can redeem points or apply a coupon here (see §17.2).
- **Subtotal** and item count, then **Place Order · ₹xxx**.

Tapping Place Order opens the **Order dialog**: cart summary, payment method
(Cash / UPI / Card / Credit), and — for GST-registered non-grocery shops — a
tax breakup (see §13). Optionally choose **Billed by** (which staff member
made the sale) if you use the Staff module. Confirm to:

- Save the order and deduct stock (from the exact variant).
- Add to the customer's khata if paid on Credit.
- Award loyalty points if loyalty is on.
- Clear the cart and update today's sales.

#### Today's Orders

Tap the receipt icon to list every order placed today. Tap a row for its full
receipt, which you can **Share** on WhatsApp.

### 10.2 Stock (Inventory)

Manage your product catalogue and stock levels.

- **Search field** and a **barcode scanner** (edits an existing item, or opens
  the new-product form if unknown).
- **Category chips** filter the list; **+N more** expands, **Show Less**
  collapses.
- Products grouped by category. Each row shows a category icon, name, brand,
  stock label (e.g. "35 units", "2.5 kg"), colour-coded **red** (out) or
  **orange** (low).
- **Tap a row** to edit name, price, MRP, stock, category, expiry (grocery),
  barcode — and **GST/HSN** (non-grocery, §13) and **variants** (§12).
- **Long-press a product** to open its **rack location** sheet (§16.3).

#### Adding a new product

Tap the orange **+** button.

- **Stage 1 — Search** the global catalogue (11,000+ products with barcodes,
  images and MRP). Tap a match to pre-fill, or **Load More**.
- **Stage 2 — Variant form.** The first variant row is always present; tap
  **Add Variant** for more (different sizes/weights/colours/models). Each
  variant has its attributes, barcode, price, MRP, opening stock, and — where
  relevant — expiry (grocery) or GST/HSN (non-grocery). Create a category
  inline with **+ Add new category**. Tap **Save**.

Units in the dropdown match your shop type (kg/g/L for grocery, pair/set for
footwear, etc.).

#### Camera stock-in (grocery)

On an empty inventory you can tap **Snap Shelves** to photograph your shelves
and let the app fill in stock automatically. From a stocked inventory, use the
camera restock option to **add** counted stock. See the
[Vision AI User Guide](VISION_AI_USER_GUIDE.md).

### 10.3 Purchase (Procurement) 🔒 Pro

Not on Pro? This tab shows a paywall. On Pro, two sections:

- **Suppliers** — list with name, phone, category. **+ Add** to create one
  (import from Contacts supported); tap to edit.
- **Recent Purchases** — every purchase order with status (*Ordered /
  Received / Paid / Unpaid*). **+ Add** to record line items (product, qty,
  cost price) with optional notes and due date. **Scan Invoice** photographs a
  paper invoice and lets the AI extract supplier, items and amounts.
- Tap a purchase to **Mark as Received** (adds stock) or **Mark as Paid**
  (clears it from Khata → Suppliers).

---

## 11. Tab 4 — Vision (Camera Stock) 🔒 Pro 🏷️ Grocery

Grocery-family shops on Pro get a fourth tab, **Vision**, which uses your
phone camera to count stock and work out what sold — without scanning each
item. Because it's a bigger feature, it has its own complete guide:

➡️ **[Vision AI User Guide](VISION_AI_USER_GUIDE.md)**

In short, Vision has three sub-tabs:

- **Shelf Scan** — photograph shelves in the morning and again in the evening;
  the app counts products in each and the difference is "what sold today".
- **Results** — the day's sold list (morning count − evening count per
  product).
- **Counter** — a live camera at the billing counter that tallies items as
  they cross a line.

Non-grocery shops don't see this tab.

---

## 12. Product Variants (Sizes, Colours, Models)

For clothing, footwear, electronics and optical shops, one "product" usually
comes in several forms — a shirt in S/M/L/XL, a phone in 128 GB/256 GB, a
frame in two colours. Kirana AI models these as **variants**.

**When adding a product** (§10.2), each variant row captures the distinguishing
attributes for your shop type:

- **Apparel:** size, colour.
- **Footwear:** size (pairs).
- **Electronics:** model, storage/RAM.
- **Optical:** type/power.

Each variant has its **own price, MRP and stock**. Grocery shops effectively
have a single hidden variant, so nothing changes for them.

**At the POS**, when you add such a product a **variant picker** appears so you
sell the exact one, and stock is deducted from that specific variant. You can
manage variants later from the product's edit sheet in the Stock tab.

Variant-based KPIs — **sell-through %**, **size-curve/size-mix**, **markdown
%** and **GMROI** — become available for these shops (turned on by the team per
vertical; see §18.1).

---

## 13. GST & Tax on Bills

Non-grocery shops (and GST-registered stores) can bill with GST.

- **On a product** (Stock → add/edit): a **GST rate** and **HSN code** field.
- **Pricing is inclusive** — the price you enter already includes GST; the app
  extracts the tax portion for the bill breakup.
- **At checkout**, the order dialog and the receipt show a **tax breakup**
  ("Incl. GST") so the customer sees the base amount and the GST.
- A **GST Report** (Profile → Operations, §16.6) summarises collected GST for
  filing.

If you leave GST fields blank, bills behave exactly as before (no tax line).

---

## 14. The Profile Screen — Your Control Centre

Tap the profile icon (top of the Overview tab). The Profile screen groups
everything into labelled sections. **Rows that don't apply to your shop type or
plan are hidden**, so your screen may show fewer rows than listed here.

At the top:

- **Header card** — avatar, your name, store name, and a **subscription badge**
  (Trial / Basic / Pro / Pending) with days remaining.
- **Cashflow Support banner** 🔒 — apply for ₹50 K–₹10 L business finance
  (§20.2).

The sections, in order, are: **Customers · Operations · Sales & Marketing ·
Analytics · Store & Account · Plan & Support · Admin** (admin role only). Each
is covered below. At the very bottom: the **Sign Out** button and the app
version.

---

## 15. Customers Section

### Customer Growth (Referrals) 🔒 Pro

Turn customers into a referral engine.

- **+ New Campaign** — name, referrer reward (₹), new-customer discount (%),
  optional expiry. Save.
- Tap a campaign → **Share QR** to print and display near your counter.
- **Redemption:** a new customer brings the QR → at POS tap the **gift icon**
  and scan it → enter their name/phone → the discount applies and the referrer
  is credited after checkout.

### Customer Relations

A directory of everyone who has bought from you.

- **Search bar** + **segment chips**: Regular, Occasional, Impulse, Bulk,
  Credit, Inactive.
- Each row: name, phone, segment badge, total spent, last visit.
- **Sync icon** imports phone contacts not already in the system (you review
  first). **+** adds a customer manually.
- **Inactive customers** get a **WhatsApp re-engagement** button.

**Customer Detail** (tap a customer): balance / total spent / total orders;
**Customer Info** (household size, join date, **Area/Association** link);
**Purchase History**; **Profile & Wishlist** (see below); Edit/Delete.

**Profile & Wishlist** (part of "Customer 360"): store extra details relevant
to your shop — **prescription** (optical), **style profile** (apparel), **size
profile** — and keep a **wishlist** of products the customer wants, so you can
follow up when they're back in stock.

### Area Associations

Track nearby places that send you customers (apartments, hostels, schools,
offices, colonies).

- **My Areas** tab — add an area (type, name, estimated households, notes);
  toggle **Active**; delete.
- **Customer Heatmap** tab — per area: 90-day revenue, orders, average order
  value, customer count, and a share bar. Link a customer to an area from their
  Customer Detail screen.

---

## 16. Operations Section

Day-to-day running of the store. Which rows appear depends on your shop type.

### 16.1 Staff

Manage your team, attendance and tasks.

- **Team list** — each member with role and (if set) commission %.
- **Add / Edit staff** — name, phone, role, **commission %**, active toggle.
- **Attendance** — mark present/absent per day (one entry per day) with quick
  chips.
- **Tasks** — a checklist you can add to, tick off, and swipe to delete.
- **Sales by staff** — when you pick **Billed by** at checkout (§10.1), each
  member's **sales this month** and **commission ₹** (sales × %) show on their
  card. The **staff-performance KPI** uses this.

### 16.2 Estimates & Returns

A tabbed screen for quotes and returns.

**Estimates (proforma / quotations):**

- Create a multi-line estimate (pick products with prices, or free-text rows),
  with an optional validity date.
- Open an estimate to see items, totals and **status chips** (draft → sent →
  accepted/rejected).
- **Convert to sale** — an accepted estimate pre-fills the POS cart so you can
  check out normally; the estimate is then linked to the order.
- **Share** the estimate to the customer on WhatsApp.

**Returns:**

- A unified, read-only **returns history** — item names, the original order,
  refund amount, and **restocked / return-to-vendor** badges.
- **Log return** (floating button) → pick the original order (search by
  customer/phone) → the return sheet opens with the order's items. Choose items,
  set the refund (defaults to what was paid), mark it an exchange if needed.
  Resaleable stock is added back; damaged stock is logged to the vendor.
- The order-details screen shows a "returns on this bill" card once a return
  exists.

### 16.3 Stock Racks

Find where a product physically lives in your shop.

- Default view is a **list of racks with item counts**; tap a rack to see its
  contents. Search for a rack by name.
- **Place stock** — pick a product with the normal product picker (or scan its
  barcode), choose a rack label and quantity.
- Row actions: **change quantity**, **move to another rack**, **remove**.
- From the **Stock tab**, long-press any product to open its rack sheet and
  **Set location** — this is the fast "where is product X?" lookup.

### 16.4 Job Cards / Repairs 🏷️ Non-grocery

For alterations, repairs and pre-orders (tailoring, device repair, optical
fitting, etc.).

- **Type chips** — alteration / repair / pre-order.
- **Create a job card** — pick the customer, describe the work, set a promised
  date and time.
- **Status workflow** — move each card through its stages (e.g. received → in
  progress → ready → delivered).

This row is hidden for grocery shops.

### 16.5 Warranty & Serials 🏷️ Electronics / Optical

Track serial numbers/IMEIs and warranty claims.

**Serials tab:**

- A list of registered units — **product name & variant, sold date,
  warranty-until badge** (active / expiring / expired), status.
- **Search** and **status filter**.
- **Add serial** — pick a product and scan/enter the serial (you can register
  serials outside of a sale).

**Warranty claims tab:**

- Claim cards show the customer, created date and days open, with **status
  chips**.
- Create a claim by picking the serial and describing the issue.

The **warranty-claim-rate KPI** is driven by this module.

### 16.6 GST Report 🏷️ Non-grocery

A summary of GST collected over a period, broken down for filing. Uses the
GST/HSN data on your products and the tax extracted at checkout (§13).

> Registered kirana stores also file GST — if you need this and it's hidden,
> set your store type appropriately in Store Settings, or contact support.

---

## 17. Sales & Marketing Section

### 17.1 My Baskets

Saved item bundles you can add to a POS cart in one tap.

- **+ New Basket** — name, description, add items (search + quantity), optional
  flat bundle price, optional valid-until date. Save.
- Active baskets appear in the POS empty-cart "Bundles & Deals" section; tap
  **Add to Cart** to add all in-stock items.
- Baskets can carry **tiered bundle pricing** (e.g. Bronze/Silver/Gold), and a
  savings banner shows the customer how much they save.
- Edit by tapping a row; delete via the bin icon; the **Active** toggle
  controls POS visibility.
- **Alert** pushes a one-time notification about the basket to nearby customers
  🔒 (throttled to once per day).

### 17.2 Loyalty & Offers

A points-and-coupons programme for your customers.

**Loyalty settings:**

- Turn loyalty on and set how points are **earned** (per ₹ spent) and the
  **tiers** (e.g. Silver/Gold/Platinum) with their thresholds.

**Coupons:**

- Create coupons (fixed ₹ or % off, validity), and manage them from the
  **Coupon Manager**.

**In use:**

- Customers earn points automatically on each sale.
- At **POS checkout** you can **redeem points** or **apply a coupon**.
- A customer's **loyalty card** (points balance and tier) shows in their
  Customer Detail. You can capture their **birthday / anniversary** for
  occasion offers.

### 17.3 Services & Appointments 🏷️ Services / Optical

For salons, fitness studios, opticals and any appointment-based business.

- **Services catalogue** — define the services you offer (name, price,
  duration).
- **Appointments** — a day-by-day calendar. **Book** an appointment (customer,
  service, time), then mark it **completed**, **cancelled** or **no-show**.
- **Memberships** — sell prepaid packs (e.g. "10 sessions") and track sessions
  used.

The **service-revenue** and **appointment-utilisation** KPIs are driven by
this module.

---

## 18. Analytics Section

### 18.1 KPI Subscriptions

Choose which business metrics appear as cards on your Home Dashboard.

- **First visit** opens in **edit mode** with all KPIs grouped by category
  (Sales, Inventory, Finance, Customer, and more on Pro).
- **Tap a KPI card** to toggle it on/off. Locked KPIs show a **PRO** badge; the
  first 3 KPIs in each non-core category are available on Basic/Trial.
- **Vertical-specific KPIs** — apparel/footwear/electronics shops get metrics
  like **sell-through %, size-curve, markdown %, GMROI**; services shops get
  **service revenue** and **appointment utilisation**; multi-store owners get
  **zone/city comparison**; and so on. Which of these are available is set by
  the team per shop type and can change without an app update.
- Tap **Done** to save. Returning later opens in **view mode** with live
  values; the settings icon returns to edit mode.

### 18.2 Transaction History

A complete log of every POS sale.

- **Filters:** date range (presets + custom), payment method, status.
- Each row: date/time, order ID, customer, item count, total, payment badge.
- Tap a row for the full itemised order (with any discounts, tax, loyalty,
  customer details) and a **Share** button for WhatsApp.

### 18.3 Store Comparison 🏷️ Multi-store

If you own **more than one store**, this screen compares them.

- Revenue bars per store, and **zone/city/area** tiles comparing performance
  across your chain.
- The **zone-comparison KPI** is driven by this.

Grouping stores into a chain is done by the team (admin-only); once grouped,
this row appears automatically for owners with multiple stores.

---

## 19. Store & Account Section

### 19.1 Switch Store

If you run **multiple stores** under one login, this opens a **store
switcher**. Pick a store to make it active; the app re-loads that store's
products, customers and billing. (Your active store is remembered until you
switch again.)

### 19.2 Language

Opens a **language picker**. The app is fully translated into **7 languages**
(English plus major Indian languages). Pick one and the whole app switches
immediately, including Indic fonts.

### 19.3 Store Settings

Edit your store's public details: **store name, address, business category
(store type), operating hours**. Changing the **store type** here can change
your vertical (§2). Tap **Save**.

### 19.4 Configuration

Personal preferences:

- **Default payment method** — pre-selects at checkout.
- **AI suggestion settings** — toggle types of AI suggestions.
- **Notification preferences** — which push notifications you receive (low
  stock, expiry, udhaar reminders, trial/billing alerts).
- **Quiet hours** — a daily window where non-critical notifications are
  suppressed.

Changes save automatically.

### 19.5 Password & Security

- **Current password** (if one is already set), **New password** (min 6
  chars), **Confirm**. Tap **Update Password**.
- Phone-OTP users who never set a password can add one here — useful for
  logging in on a second device without OTP.

---

## 20. Plan & Support Section

### 20.1 Subscription & Plans

- Shows your current plan (Trial / Basic / Pro / Pending), the next billing
  date (paid plans) or a trial countdown.

| Plan | Monthly | Per day |
| --- | --- | --- |
| Free Trial | Free for 14 days | — |
| Basic | ₹200 | ~₹7 |
| Pro | ₹500 | ~₹17 |

- **Get Basic / Get Pro** starts Google Play Billing; your plan activates
  within seconds of payment.
- **Restore Purchases** re-syncs an existing subscription after a reinstall or
  new phone.
- Paid plans show **Cancel Subscription** (downgrades to Free at the end of the
  billing cycle).
- Trial reminders ping you once a day when under 7 days remain (toggle in
  Configuration → Notifications).

### 20.2 Cashflow Support 🔒 Pro

Apply for business financing between ₹50,000 and ₹10,00,000.

- Shows eligibility criteria, financing range and indicative interest.
- **Get Started** → a form (some fields pre-filled from your profile),
  requested amount and repayment period → **Submit**.
- You'll see *"Application received — we'll get back to you within 48 hours"*,
  and the screen shows the status of previous applications.

### 20.3 Help & Support

- **FAQ** — common questions and answers.
- **Report an Issue** — a categorised form (App bug, Pricing, Inventory, AI
  recommendation, POS error, Feature request) → **Submit**.
- **Chat with us** — coming soon.
- **Email Support** — opens your mail app pre-filled with your store ID and app
  version for `support@lohiyaai.com`.

---

## 21. Notifications

You receive push notifications even when the app is closed.

| Event | What it looks like |
| --- | --- |
| Trial ending soon | *"Your trial ends in 3 days — upgrade now"* |
| Subscription activated | *"Welcome to Pro!"* |
| Udhaar reminder sent | *"Reminder sent to Ramesh — ₹450 pending"* |
| Low stock 🔒 | *"Atta is running low — 2 units left"* |
| Expiry warning 🔒 | *"3 items expire this week"* |
| Trial approved | *"Your trial is now active — start billing"* |
| Vision scan ready 🔒 | *"Evening scan done — see what sold today"* |

Tapping a notification opens the relevant screen (udhaar reminder → that
customer's khata, low stock → Inventory, Vision → the Vision tab, etc.).

**View all notifications:** tap the **bell icon** on the Overview/POS/Finance
screens. Each entry is dated, tappable and clearable.

---

## 22. Signing Out

**Profile → scroll to the bottom → Sign Out (red button).**

- Your session and both auth tokens (Kirana + POS) are cleared from this
  device; you return to the Login screen.
- Your data on the server (orders, inventory, customers, settings) is
  untouched, and you skip onboarding next time.

Sign back in with the same phone number or username/password to restore
everything.

---

## 23. Troubleshooting

**"POS Offline" badge** — the app can't reach the POS service. Check your
internet, pull down to retry; if it stays red, sign out and back in to
re-issue your POS token.

**Login OTP not arriving** — confirm SIM signal, wait 30 s, tap **Resend
OTP**; or use the Username tab.

**Search returns no products** — tap **🔄 Refresh** in the top bar; if still
zero, you may not have added inventory yet — use the orange **+** in Stock.

**Stock count looks wrong after a sale** — pull down on Stock to refresh; if it
persists, edit the product and correct the stock manually. For variant
products, check you're looking at the right variant (§12).

**Barcode / serial scan won't detect** — clean the camera lens, add light,
hold steady. For serials, use the Add-serial sheet's scan option (§16.5).

**Variant picker doesn't appear** — the product may have only one variant, or
your shop type doesn't use variants (grocery). Add variants from the product's
edit sheet.

**GST line not showing on bills** — GST appears only when a product has a GST
rate set and your shop type supports tax (§13).

**Vision tab is missing** — it's Pro-only and grocery-family-only. See the
[Vision AI User Guide](VISION_AI_USER_GUIDE.md) for the full checklist.

**Voice / Handwrite says "Daily limit reached"** — Pro has a daily quota
(shown as e.g. "Voice 0/10"); it resets at midnight local time.

**Trial says "Pending" for a long time** — approvals are usually within a few
hours. Keep notifications on and pull down on the pending screen to re-check.

**App is blocked / disabled** — a full-screen message means the team has
temporarily disabled the app or flagged your store. The reason and a support
contact are shown; wait or reach out to support.

**Anything else** — Profile → Help & Support → Report an Issue, or email
`support@lohiyaai.com` (the Email Support option pre-fills your store ID, owner
name and app version).

---

## 24. Quick Glossary

| Term | Meaning |
| --- | --- |
| **Vertical / Store type** | The kind of shop you run; decides which features appear (§2). |
| **Udhaar / Khata** | Customer credit — goods taken now, paid later. |
| **POS** | Point of Sale — the billing screen. |
| **SKU** | A distinct product line you stock. |
| **Variant** | A specific size/colour/model of a product (§12). |
| **HSN / GST** | Tax classification code and rate on a product (§13). |
| **Estimate / Proforma** | A price quote you hand a customer before the sale (§16.2). |
| **Serial / IMEI** | The unique number identifying an electronic unit (§16.5). |
| **KPI** | A business metric card on your dashboard (§18.1). |
| **Basket** | A saved bundle of items sold together (§17.1). |
| **Vision** | Counting stock with your phone camera (§11 and the Vision guide). |
