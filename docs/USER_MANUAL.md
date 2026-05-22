# Kirana AI — User Manual

A complete, step-by-step guide for store owners using the Kirana AI app.
This manual walks you through every screen, every button, and what happens
when you tap it.

> Looking for a quick feature overview instead? See [`FEATURES.md`](FEATURES.md).
> Developer documentation lives in [`DEVELOPER_GUIDE.md`](DEVELOPER_GUIDE.md).

---

## Table of Contents

1. [Before You Start](#1-before-you-start)
2. [First Launch — Splash Screen](#2-first-launch--splash-screen)
3. [Sign Up — The 5-Step Onboarding](#3-sign-up--the-5-step-onboarding)
4. [Logging In](#4-logging-in)
5. [Choosing Your Trial Plan](#5-choosing-your-trial-plan)
6. [The Home Dashboard](#6-the-home-dashboard)
7. [Tab 1 — Home (Overview)](#7-tab-1--home-overview)
8. [Tab 2 — Khata (Finance)](#8-tab-2--khata-finance)
9. [Tab 3 — Billing (POS / Stock / Purchase)](#9-tab-3--billing-pos--stock--purchase)
10. [Profile](#10-profile)
11. [Customer Relations](#11-customer-relations)
12. [Area Associations](#12-area-associations)
13. [Customer Growth (Referrals)](#13-customer-growth-referrals)
14. [KPI Subscriptions](#14-kpi-subscriptions)
15. [My Baskets](#15-my-baskets)
16. [Transaction History](#16-transaction-history)
17. [Store Settings](#17-store-settings)
18. [Configuration](#18-configuration)
19. [Password & Security](#19-password--security)
20. [Subscription & Plans](#20-subscription--plans)
21. [Cashflow Support](#21-cashflow-support)
22. [Help & Support](#22-help--support)
23. [Notifications](#23-notifications)
24. [Signing Out](#24-signing-out)
25. [Troubleshooting](#25-troubleshooting)

---

## 1. Before You Start

**What you need:**

- An Android phone (the app is currently optimised for Android; iOS is in
  testing).
- A working SIM card with an active mobile number for OTP verification.
- An internet connection — the app needs to reach the server to load products,
  place orders, and sync data.
- Permission to access your phone's location, camera, contacts, and
  microphone. The app asks for each only when you first use the related
  feature.

**What the icons in this manual mean:**

| Symbol | Meaning |
| --- | --- |
| **Tap** | A single press on a button, icon, or row. |
| **Long-press** | Press and hold for about one second. |
| **Swipe left / right** | Drag your finger left or right on a row. |
| **Pull down** | Drag the screen downward from the top — this refreshes the data. |
| 🔒 **Pro** | Feature only available on the Pro plan. The app will show an upgrade prompt if you try to use it on Basic. |

---

## 2. First Launch — Splash Screen

When you open the app for the first time, you see the Kirana AI logo on a
deep-blue background with the tagline *"Smart business, smarter you"* and a
small loading spinner. This screen lasts about 1.6 seconds while the app
checks:

1. **Whether the app is temporarily disabled.** If the LohiyaAI team has
   pushed an emergency shutdown notice, you see a full-screen message
   explaining why and what to do.
2. **Whether you have completed onboarding before.** If not, you are sent to
   the Onboarding screens (see §3).
3. **Whether your store has been individually blocked.** If yes, you see a
   block screen with the reason.
4. **Whether you have a valid login session.** A session lasts 30 days — if
   it has not expired, you go straight to the Home Dashboard. Otherwise you
   land on the Login screen.

**You never need to interact with this screen.** It is purely a routing
screen.

---

## 3. Sign Up — The 5-Step Onboarding

This appears the very first time you open the app, or any time you tap
**Create one** on the login screen.

The top of the screen shows a progress indicator: 4 small dots and a label
like "1/4" on the right. You can use the back arrow at the top-left to go
back one step (except on Step 1 and Step 2 — they cannot be backed out of).

### Step 1 of 5 — Welcome

Three auto-rotating slides introduce the app:

1. *Welcome to Kirana AI* — your smart business partner.
2. *Smart Inventory Management* — track stock and get low-stock alerts.
3. *Grow Your Business* — AI insights and analytics.

The slides change automatically every 4 seconds, but you can swipe between
them.

**Buttons:**
- **Get Started** (large blue button) — proceeds to Step 2.
- **Already have an account? Sign In** — takes you to the Login screen.

### Step 2 of 5 — Verify Your Phone Number

This step has three sub-stages.

**Sub-stage A: Enter phone number.**

- A field labelled "Phone number" with a fixed **+91** prefix.
- Type your 10-digit Indian mobile number.
- Tap **Send OTP**.

The app sends a 6-digit code to your phone via SMS.

**Sub-stage B: Enter the OTP.**

- A "6-digit OTP" field — type the code from your SMS.
- The app auto-submits as soon as you enter the sixth digit. You can also
  tap **Verify** manually.
- **Resend OTP** is available if the code didn't arrive (you may need to
  wait a few seconds).
- The back arrow above the field returns you to the phone-number entry.

If verification succeeds **and your phone number is already registered**,
you skip the rest of onboarding entirely and go straight to the dashboard.
Otherwise you continue to Sub-stage C.

**Sub-stage C: Choose a username.**

- A green badge confirms your phone number is verified.
- A "Username" field. Rules:
  - Letters, numbers, and underscores only.
  - Minimum 3 characters, maximum 30.
- As you type, the app checks availability in the background. A green tick
  means the name is free; a red cross means it's taken.
- Tap **Continue** to move on. If the username is taken or too short, the
  app shows an inline error.

### Step 3 of 5 — Tell Us About Your Store

Fields:

| Field | What to enter |
| --- | --- |
| Owner's full name | Your full name, e.g. *Ramesh Kumar*. |
| Store name | The display name of your store, e.g. *Sri Lakshmi Stores*. |
| Email address | A valid email — used for receipts and support. |
| Business type | Dropdown: *Grocery Store (Kirana)*, *General Store*, *Provision Store*, *Fruits & Vegetables*, *Medical / Pharmacy*, *Stationery & Books*, *Others*. |
| Estimated daily customers | A whole number, e.g. *40*. Helps the AI tune its predictions. |

Tap **Continue** when done. Each field is required, and the form won't
proceed until they are all filled in correctly.

### Step 4 of 5 — Where Is Your Store Located?

You can either:

- Tap **Detect My Location** — the app uses GPS and reverse-geocodes the
  coordinates to fill in your address and city automatically. A small green
  badge appears showing the detected location.
- *Or* fill in **Store address** and **City / District** manually. The app
  will use OpenStreetMap to look up coordinates from your address when you
  continue.

Both an address and a city are required.

Tap **Continue** to proceed.

### Step 5 of 5 — Review & Agree

Two cards summarise the **Terms & Conditions** and the **Privacy Policy**.
Read them, then tick the two checkboxes:

- *I have read and agree to the Terms & Conditions.*
- *I agree to the Privacy Policy.*

Tap **Complete Setup**. The app creates your account on the server,
registers your device for notifications, and takes you to the Home
Dashboard (or to the trial-plan screen if your account is new).

---

## 4. Logging In

If you already have an account and you're not signed in, the app shows the
**Login** screen with two tabs.

### Tab 1 — Phone OTP (recommended)

- Type your registered 10-digit phone number (the +91 prefix is fixed).
- Tap **Send OTP**, or just keep typing — the OTP is sent automatically as
  soon as you finish 10 digits.
- A 6-digit OTP field appears. Type the code from your SMS.
- The login completes automatically when you enter the sixth digit.

If your phone number is not yet registered, the app shows an error and
points you to onboarding instead.

### Tab 2 — Username

- Type the username you chose during signup (e.g. *lohiyastore123*).
- Type your password. Tap the eye icon to show/hide it.
- Tap **Sign In**.

Wrong username/password shows *"Incorrect username or password. Please try
again."* Network problems show *"Could not connect to the server."*

**"Don't have an account? Create one"** at the bottom takes you to the
Onboarding screens.

---

## 5. Choosing Your Trial Plan

The very first time you sign in to a brand-new account, you see the
**Welcome to Kirana AI — Choose a plan to trial free** screen.

There are two cards:

| Plan | Price | What you get |
| --- | --- | --- |
| **Basic** | ₹200 / month | POS & Sales · Inventory · Finance & Udhaar · KPI Insights (3 per category) · AI Recommendations |
| **Pro** (*ALL FEATURES*) | ₹500 / month | Everything in Basic + All KPI Categories + Vendor & Procurement Management + Cashflow Support (up to ₹10 L) + Customer Growth Engine |

Tap one card to select it (it gets a coloured border and check). Then tap
**Request Basic Trial** / **Request Pro Trial**. Your request goes to the
LohiyaAI team for approval.

**Pending Activation screen:** while your request is being reviewed you see
*"Trial Request Received!"* with an orange hourglass icon. This usually
takes a few hours. You receive a push notification when it's approved.

You can sign out of this screen using *"Sign in to a different account"*
near the bottom.

---

## 6. The Home Dashboard

After your trial is active you land on the main dashboard. It has **three
bottom tabs**:

| Icon | Tab name | Purpose |
| --- | --- | --- |
| 🏠 | **Home** | Daily overview, AI insights, today's sales |
| 📓 | **Khata** | Customer credit (udhaar) and supplier credit |
| 🏬 | **Billing** | POS / Inventory / Procurement |

Tap a tab to switch. The three sections preserve their scroll position when
you switch back.

If your trial has expired without a paid plan, you see an **Upgrade Wall**
covering the dashboard until you subscribe.

---

## 7. Tab 1 — Home (Overview)

### What you see

Scrolling from top to bottom:

1. **Greeting header**
   - "Good morning / afternoon / evening, *Your Name*"
   - The current date (e.g. "May 22, 2026").
   - Your store name.
   - A **notification bell** at the top right — tap to open the
     notifications screen.

2. **Morning Briefing ribbon** (only if there is something urgent)
   A coloured gradient strip summarising the most important alerts of the
   day. Tap it to jump to the Inventory tab.

3. **Pro Alerts strip** *(Pro only)*
   A horizontal row of coloured chips for overdue udhaar, low stock,
   expiring items, etc. Tap any chip to jump to its source screen.

4. **Intelligence cards** — four AI cards in a row:
   - **Fast Moving** — products selling fastest right now.
   - **Stockout Risk** — items the AI predicts will run out in 3–7 days.
   - **Reorder Required** — items below your minimum stock threshold.
   - **High Profit** — products with the best margins.
   Tap any card to open a full ranked list of items in that category.

5. **Today's Sales card**
   Total revenue billed today, number of orders, and average order value.

6. **KPI summary row**
   Your subscribed KPIs as live metric cards. If you haven't subscribed to
   any yet, this row is empty — tap "Customise" or visit Profile → KPI
   Subscriptions.

7. **Store Overview card**
   Footfall, budget, daily budget, and SKU count.

### What you can do

- **Pull down** anywhere in the list to refresh all data.
- **Tap the bell** to open the notifications screen.
- **Tap an intelligence card** to drill into a full list of products for
  that category.
- **Tap the "+ New Sale" floating button** (bottom right) — jumps straight
  to the POS billing screen.

---

## 8. Tab 2 — Khata (Finance)

A two-tab screen for tracking credit.

The **header** shows two stats at all times:
- **Monthly Sales** — total amount billed this month.
- **Monthly SKUs** — number of distinct products sold this month.

Below the header, two sub-tabs:

### Sub-tab A — Udhaar (Customer Credit)

Customers who took goods on credit.

**What you see:**
- A summary card with the total outstanding amount across all customers.
- A list of every customer with an open balance, showing how much they
  owe and when they took it.

**What you can do:**

- **+ New Udhaar** (top right) — opens a sheet to record a new credit
  entry.
  - **Customer name** (free text) — or tap the contact-picker icon to
    select from your phone contacts.
  - **Phone number**.
  - **Amount** in rupees.
  - You can also tap an existing customer from the list to auto-fill name
    and phone.
  - Tap **Save** to record. The list refreshes.

- **Tap a customer row** to see their full credit history — every credit
  taken, every payment received, with timestamps.

- **WhatsApp reminder icon** on a row — opens WhatsApp with a pre-written
  reminder message addressed to that customer.

- **Mark as received** action — when a customer pays back, tap the row,
  then "Record Payment", enter the amount they paid, and confirm. The
  balance updates immediately.

- **Pull down** to refresh.

### Sub-tab B — Suppliers (Distributor Credit)

Money you owe to your suppliers.

**What you see:**
- Total payable summary at the top.
- A list of each supplier with the total outstanding amount.

**What you can do:**
- **Tap a supplier** to see the individual purchase orders that make up the
  balance.
- Mark a purchase as **paid** to clear it from the outstanding list.

---

## 9. Tab 3 — Billing (POS / Stock / Purchase)

This is the heart of day-to-day operations. The screen has its own header
showing **POS / Inventory** and either a green *"POS Online"* badge or a
red *"POS Offline"* badge.

Below the header are **three sub-tabs**:

| Icon | Sub-tab | Purpose |
| --- | --- | --- |
| 🧾 | **Billing** | Sell products to a customer |
| 📦 | **Stock** | Manage your inventory |
| 🚚 | **Purchase** | Suppliers and purchase orders *(Pro only)* |

A notification bell is always in the top-right.

### 9.1 Sub-tab: Billing (POS)

This is where you ring up sales.

#### Top bar

From left to right:

| Icon | Action |
| --- | --- |
| Search field | Type a product name, brand, or barcode. Matching products appear in a dropdown — tap to add. |
| 🎁 **Gift icon** (amber) | **Scan referral QR** — opens the camera to scan a referral code brought by a new customer. |
| 📷 **QR icon** (blue) | **Scan barcode** — opens continuous barcode scanning (see §9.1.4). |
| 📜 **Receipt icon** | Today's orders sheet — every order billed today. |
| 🔄 **Refresh icon** | Reload products from the server. Use if you just updated stock from another device. |

#### AI entry strip (below the search bar)

Two pills, both Pro-gated:

- **Voice Order** 🎙️ — record a customer reading out their order, the AI
  transcribes it into a cart automatically.
- **Handwrite** ✍️ — photograph a handwritten list, the AI parses it into
  cart items.

Pro users see a daily counter (e.g. "Voice (4/10)") showing remaining
quota. Non-Pro users see a lock icon — tapping shows the upgrade sheet.

#### 9.1.1 Building a cart by search

1. Tap the search field and type a product name (e.g. "atta").
2. A panel appears below the search bar showing matching products with
   their price and stock level.
3. Tap the **+** button on a row to add one unit to the cart.
4. For **loose items** (sold by weight/volume), a dialog asks for the
   quantity. Type the weight, tap **Add to Cart**.
5. The search closes automatically after adding.

#### 9.1.2 Building a cart by barcode

1. Tap the blue QR icon to open the continuous scanner sheet.
2. Point your phone's camera at a product barcode.
3. Each successful scan is added to a temporary list inside the sheet.
4. If you scan a barcode that doesn't exist in your inventory, the app
   pops up *"Unknown Barcode"* with two choices:
   - **Add as New** — opens the new-product form pre-filled with the
     barcode.
   - **Link to Existing Item** — pick any product that has no barcode yet
     and assign this barcode to it.
5. When done scanning, tap **Add to Cart** to move all scanned items into
   the actual cart.

For loose items, after closing the scanner sheet the app asks for the
weight one by one.

#### 9.1.3 Bundles & Deals (empty cart)

When the cart is empty, the body of the screen shows **Bundles & Deals**
— a list of:
- Your own baskets (sky-blue cards, see §15).
- AI-suggested daily basket campaigns (other colours).

Each card shows:
- The bundle name and a one-line description.
- An *in-stock pill* like "5/6" telling you how many of the bundle's items
  you currently have in stock.
- A list of items (chips) with green ticks for in-stock and grey for
  missing.
- An **Add to Cart** button that adds all available items in one tap. Out
  of stock items are skipped.

Tap a card itself to open a detailed sheet with the full item list and
pricing breakdown.

Tap **Refresh AI** in the header to fetch new campaign suggestions.

#### 9.1.4 The cart itself

Once you have items in the cart:

- Each row shows the product image, name, brand, unit price, the quantity
  control (− / number / +), and the line total.
- **Swipe a row left** to remove that item (a red delete bar appears).
- **Loose items** show their weight in a coloured chip — tap to edit.
- **Clear button** (top right of the cart area) — empties the entire
  cart. Asks for confirmation.

Below the cart, a horizontal row labelled **FREQUENTLY BOUGHT TOGETHER**
suggests up to 5 more items based on what's currently in the cart. Tap one
to add it.

#### 9.1.5 Checkout

At the bottom of the screen:

- **Customer banner**
  - If no customer is selected: a grey "Add/Select Customer" button. Tap
    to open the customer picker (search, or tap **+ New** to add one on
    the spot, including via the phone-contacts picker).
  - If a customer is selected: a coloured strip with their name and a
    cross to clear.
- **Subtotal** and item count.
- **Place Order · ₹xxx** — the main checkout button.

Tapping Place Order opens the **Order dialog**:

- A summary of the cart.
- **Payment method**: Cash, UPI, Card, or Credit (adds to udhaar).
- The total amount.
- A confirm button.

When you confirm:
- The order is saved on the server.
- Stock is automatically deducted from your inventory.
- If Credit, the amount is added to the customer's khata balance.
- The cart clears, the daily sales card updates, and a confirmation toast
  appears.

If you scanned a referral QR before checkout, the new customer is created
and linked to the order automatically.

#### 9.1.6 Today's Orders

Tap the receipt icon in the top bar to see a sheet listing every order
placed today with its amount, payment method, and time. Tap any row to
view that order's full receipt.

### 9.2 Sub-tab: Stock (Inventory)

Manage your product catalogue and stock levels.

#### Top of the screen

- **Search field** — type a product name, brand, or category.
- **Barcode scanner** (blue QR icon) — scan a barcode; if it matches an
  existing item, opens its edit form; if it doesn't, opens the new product
  form.

#### Category chips

Below the search bar, a row of chips: *All* plus every category that has
products. Tap a category to filter the list to it. If there are too many
categories, a **+N more** chip expands the full set; **Show Less** collapses.

#### Product list

Products are grouped by category. Each row shows:

- A coloured category icon.
- The product name and brand.
- The current stock label (e.g. *"35 units"*, *"2.5 kg"*).
- Colour coding: **red** if out of stock, **orange** if low stock,
  otherwise normal.

**Tap a row** to open the edit-product sheet. You can change the name,
price, MRP, stock quantity, category, expiry date, and barcode.

**Pull down** to refresh the inventory from the server.

#### Adding a new product

Tap the orange **+** floating button at the bottom right.

The Add Product sheet has two stages:

**Stage 1 — Search**
- Type a few characters to search the global Kirana product catalogue
  (over 11,000 products with pre-filled barcodes, images, and MRP).
- Tap **Load More** at the bottom to fetch the next 20 results.
- If a matching product exists, tap it — the form pre-fills automatically.

**Stage 2 — Variant form**
- The first variant row is always present. Tap **Add Variant** to add more
  (different weights/units of the same product).
- Each variant has: weight, unit (kg / g / L / ml / piece), barcode, price,
  MRP, opening stock, and optional expiry date.
- The category dropdown lists your existing categories — tap **+ Add new
  category** at the top of the dropdown to create one inline.
- Tap **Save** to create all variants at once. The list refreshes and the
  new items appear at the top of their category.

**Optimistic UI:** while the save is in flight, you see "pending" items
with a small spinner. If the network fails, they go red and a **Retry**
button appears.

### 9.3 Sub-tab: Purchase (Procurement) 🔒 Pro

If you are not on the Pro plan, this tab shows a paywall card titled
**Purchase & Suppliers — PRO ONLY** with the *Upgrade to Pro · ₹500/mo*
button. Tap it to open the subscription sheet.

If you are on Pro, the tab shows two sections:

**Section 1 — Suppliers**

- A list of all your registered suppliers with name, phone, and category.
- **+ Add** at the top right opens the *Add New Supplier* sheet:
  - Supplier name (required).
  - Phone number (optional).
  - Category (e.g. *Dairy*, *FMCG*).
  - Tap **Contacts** to import from your phone book.
  - Tap **Save**.
- **Tap any supplier** to open the edit sheet (same fields).

**Section 2 — Recent Purchases**

- A list of every purchase order — supplier name, date, total amount, and
  current status (*Ordered*, *Received*, *Paid*, *Unpaid*).
- **+ Add** opens the *Add Purchase* sheet:
  - Select supplier.
  - Add line items: product, quantity, cost price (per unit). Each line is
    summed into the order total.
  - Optional notes and due date.
  - Tap **Save**.
- **Scan Invoice** (top right next to **+ Add**) — photograph a paper
  invoice and let the AI extract supplier, items, quantities, and amounts
  automatically. Review, then save.

**Marking purchases:**

- Tap a purchase row to expand it. Two action buttons appear:
  - **Mark as Received** — confirms the goods arrived. Stock is added to
    inventory automatically.
  - **Mark as Paid** — sets the payment status to paid, clearing it from
    the Khata → Suppliers tab.

**Pull down** to refresh.

---

## 10. Profile

Tap the profile icon (visible on the Overview tab) or open the menu — the
exact entry depends on where you are in the app.

The Profile screen is the gateway to settings, customers, KPIs, and
support.

### Header card

- A circular avatar (currently your store logo) and your full name.
- Your store name below.
- A small **subscription badge** showing your current plan (Trial · Basic ·
  Pro · or PENDING) with the days remaining.

### Cashflow Support banner 🔒 Pro

A dark-blue gradient card labelled *Cashflow Support — Apply for ₹50K –
₹10L business finance*. Tap to open the cashflow application (or the
paywall if not Pro).

### Sections

Each section has a small label in upper case and a card of compact rows.

**Customers section**

| Row | Goes to |
| --- | --- |
| Customer Growth 🔒 Pro | Referral campaigns |
| Customer Relations | Customer directory |
| Area Associations | Nearby areas + heatmap |

**Analytics section**

| Row | Goes to |
| --- | --- |
| KPI Subscriptions | Choose which KPIs appear on Overview |
| Transaction History | All sales filterable by date / payment / status |
| My Baskets | Saved item bundles |

**Store & Account section**

| Row | Goes to |
| --- | --- |
| Store Settings | Edit store name, address, hours |
| Configuration | App preferences, default payment, notification toggles |
| Password & Security | Change password |

**Plan & Support section**

| Row | Goes to |
| --- | --- |
| Subscription & Plans | Manage your subscription |
| Help & Support | FAQ, report issue, email |

**Admin section** (only if your role is *admin*)

| Row | Goes to |
| --- | --- |
| User Activity | List of users with last-seen, sessions, sales today |

### Sign Out

At the bottom of the screen, a red **Sign Out** button. Tapping it clears
your session and returns you to the Login screen. Your data stays on the
server.

The very bottom shows the app version, e.g. *v1.0.0+1*.

---

## 11. Customer Relations

**Profile → Customer Relations**

A complete directory of every customer who has ever bought from your
store.

### What you see

- A **search bar** at the top.
- Below it, a row of **segment chips** that act as filters:
  - **Regular** — ordered 3 or more times in the last 30 days.
  - **Occasional** — at least one order in the last 90 days but not enough
    to be regular.
  - **Impulse** — active but no clear pattern.
  - **Bulk** — high spenders.
  - **Credit** — has an outstanding udhaar balance.
  - **Inactive** — no orders in 60+ days.
- The list of customers — each row shows name, phone, segment badge, total
  spent, and last visit.

### What you can do

- **Type** in the search bar to filter by name or phone.
- **Tap a segment chip** to show only customers in that group.
- **Tap a row** to open the Customer Detail screen (see below).
- **Sync icon** (top right) — reads your phone contacts and offers to
  import the ones not already in the system. You review the list before
  saving.
- **+ button** (bottom right) — manually add a customer (name, phone,
  email, household size). You can also import directly from your contacts
  from inside the dialog.
- For Inactive customers, a **WhatsApp re-engagement** button on the row
  lets you send a personalised "We miss you" message in one tap.

### Customer Detail screen

When you tap a customer:

- Their **name, phone, email** at the top.
- Three summary cards: **current khata balance**, **total ever spent**,
  **total orders**.
- **Customer Info** — household size, join date, and an **Area /
  Association** dropdown to link the customer to a nearby area (see §12).
  Pick *None* to unlink.
- **Purchase History** — every order they have placed, with date, total,
  and tap-through to the full receipt.
- **Edit** (pencil icon, top bar) — edit name, phone, email, household.
- **Delete** (bin icon, top bar) — removes the customer. Asks for
  confirmation.

---

## 12. Area Associations

**Profile → Area Associations**

Tracks the nearby locations that send you regular customers — apartment
complexes, hostels, schools, offices, residential colonies.

The screen has two tabs.

### Tab 1 — My Areas

- A list of every area you have added.
- **+ button** (top right) — add a new area:
  - **Area type**: apartment, hostel, school, office, or colony.
  - **Name**.
  - **Estimated households** (optional).
  - **Notes** (optional).
  - Tap **Add Area**.
- **Active toggle** on each row — switch off to exclude an area from
  campaign suggestions without deleting it.
- **Bin icon** — delete the area. Asks for confirmation.

### Tab 2 — Customer Heatmap

For every area:
- Revenue earned in the last 90 days.
- Number of orders.
- Average order value.
- Number of customers.
- A bar showing each area's share of total revenue relative to the
  highest-performing area.

Only areas that have customers linked to them appear here. To link a
customer, open their Customer Detail screen (§11) and pick the area from
the **Area / Association** dropdown.

---

## 13. Customer Growth (Referrals) 🔒 Pro

**Profile → Customer Growth**

Turn existing customers into a referral engine.

### Creating a campaign

Tap **+ New Campaign**.

Fill in:
- **Campaign name** (e.g. *"Refer a friend, get ₹50 off"*).
- **Reward** for the referrer (in rupees).
- **Discount percentage** for the new customer.
- **Expiry date** (optional).

Tap **Save**. The campaign appears in the list.

### Sharing a campaign

Tap a campaign card, then **Share QR**.

A printable QR code appears with the campaign details. Print it and stick
it near your billing counter, or show it to existing customers.

### How the redemption works

1. An existing customer recommends your store to a friend.
2. The friend comes to your store with the QR code.
3. At the POS, tap the **gift icon** (amber) in the top bar and scan the
   QR.
4. A sheet asks for the new customer's name and phone.
5. The discount is applied automatically to the bill.
6. After checkout, the referrer is credited with the reward (it shows in
   their customer profile).

---

## 14. KPI Subscriptions

**Profile → KPI Subscriptions**

Choose which business metrics appear as cards on your Home Dashboard.

### First visit

If you haven't subscribed to any KPIs yet, the screen opens in **edit
mode** showing all available KPIs grouped by category:

- Sales
- Inventory
- Finance
- Customer
- (And more categories on Pro)

### Subscribing

- **Tap a KPI card** to toggle it on (blue tick) or off.
- A small **lock icon + PRO badge** appears on KPIs that are only
  available on the Pro plan. Tapping a locked KPI shows the paywall sheet.
- The first 3 KPIs in each non-core category are accessible to Basic /
  Trial users. The "Core Insights" category requires Pro.
- Tap **Done** (top right) to save. Your subscriptions sync to the server
  and appear on the Overview tab.

### Returning later

If you already have subscriptions, the screen opens in **view mode** —
your chosen KPIs are shown as live metric cards with current values.

- Tap the **settings icon** (top right) to return to edit mode.

---

## 15. My Baskets

**Profile → My Baskets**

Saved item bundles you can add to a POS cart with one tap.

### What you see

- A list of every basket you have created — each shows the name,
  description, item count, and current price.

### Creating a basket

Tap **+ New Basket**.

- **Name**, e.g. *"Pongal Festival Combo"*.
- **Description** (optional).
- Add items: search for a product, pick the quantity. Repeat for each
  item.
- Optional bundle price (a flat amount instead of summing item prices).
- Optional valid-until date.
- Tap **Save**.

### Using a basket

- Active baskets appear automatically in the POS empty-cart "Bundles &
  Deals" section.
- Tap **Add to Cart** on a basket card to add all in-stock items in one
  go.

### Editing or deleting

- Tap a basket row to edit.
- Long-press, or use the bin icon, to delete. Asks for confirmation.
- The **active toggle** controls whether the basket appears in the POS
  Bundles section.

### Send a one-time alert

Tap **Alert** on a basket to push a notification to nearby customers (Pro
feature).

---

## 16. Transaction History

**Profile → Transaction History**

A complete log of every sale billed through the POS.

### Filters at the top

- **Date range** — pick a custom range or use presets (Today, Last 7 days,
  This month).
- **Payment method** — Cash, UPI, Card, Credit.
- **Status** — Completed, Refunded, etc.

### Each row shows

- Date and time of the order.
- Order ID.
- Customer name (if one was attached).
- Number of items and total amount.
- Payment method badge.

### Tap a row

Opens the full order details:

- Itemised list — product name, quantity, unit price, line total.
- Subtotal, any discounts, tax (if applicable), and final amount.
- Payment method and customer details.
- A **Share** button to send the receipt to the customer via WhatsApp.

---

## 17. Store Settings

**Profile → Store Settings**

Edit your store's public details.

Fields:

- **Store name** — the display name shown on receipts and the dashboard.
- **Address**.
- **Business category** (dropdown).
- **Operating hours** — opening and closing times.

Tap **Save** at the bottom to commit the changes. They sync to the server
immediately.

---

## 18. Configuration

**Profile → Configuration**

Personal preferences for how the app behaves.

- **Default payment method** — pre-selects Cash / UPI / Card / Credit when
  the checkout dialog opens.
- **AI suggestion settings** — toggle individual types of AI suggestions
  on or off (e.g. cart suggestions, basket campaigns).
- **Notification preferences** — which push notifications you want to
  receive (low stock, expiry warnings, udhaar reminders, trial / billing
  alerts).
- **Quiet hours** — define a daily window during which non-critical
  notifications are suppressed.

Changes save automatically as you toggle.

---

## 19. Password & Security

**Profile → Password & Security**

Set or change your password.

- **Current password** (only required if one is already set).
- **New password** — minimum 6 characters.
- **Confirm new password** — must match.

Tap **Update Password**. You'll see a confirmation toast.

> Phone-OTP users who signed up without setting a password can use this
> screen to add one — useful if you want to log in on a second device
> without OTP.

---

## 20. Subscription & Plans

**Profile → Subscription & Plans**

Manage your current plan.

### What you see

- A header showing your current plan (Trial / Basic / Pro / Pending).
- For active paid plans, the **next billing date**.
- For trial plans, a countdown (e.g. *"5 days remaining"*).

### Plans available

| Plan | Monthly cost | Per day |
| --- | --- | --- |
| Free Trial | Free for 14 days | — |
| Basic | ₹200 / month | ~₹7 / day |
| Pro | ₹500 / month | ~₹17 / day |

### Upgrading

Tap **Get Basic** or **Get Pro** to start Google Play Billing. The
standard Google Play payment sheet appears — choose a saved payment method
or add a new one. After the transaction completes, your plan activates
within seconds.

### Restore purchase

If you reinstalled the app or switched phones, tap **Restore Purchases**
near the bottom. The app re-syncs your existing subscription from Google
Play.

### Cancelling

Paid plans show a **Cancel Subscription** button at the bottom. Tapping
asks for confirmation; on confirm, your plan downgrades to Free at the end
of the current billing cycle.

### Trial reminders

When your trial has less than 7 days remaining, the app pings you once a
day with a reminder. You can turn off these reminders in Configuration →
Notifications.

---

## 21. Cashflow Support 🔒 Pro

**Profile → Cashflow Support banner**

Apply for business financing between ₹50,000 and ₹10,00,000.

### What you see

- Eligibility criteria (years of operation, monthly sales, etc.).
- Available financing range and indicative interest.
- A **Get Started** button.

### The application form

- Required business details (some are pre-filled from your store profile).
- Requested loan amount.
- Preferred repayment period.
- Tap **Submit**.

You'll see *"Application received — we'll get back to you within 48 hours"*.
The same screen shows the status of any previous applications.

---

## 22. Help & Support

**Profile → Help & Support**

Four options:

1. **Frequently Asked Questions** — common questions and answers about
   adding products, stockout prediction, khata, contact sync, KPIs, and
   reports.
2. **Report an Issue** — fill in a categorised form (App bug, Pricing
   issue, Inventory problem, AI recommendation issue, POS error, Feature
   request) and describe the problem. Tap **Submit**.
3. **Chat with us** — currently shows *"Chat support coming soon!"*.
4. **Email Support** — opens your mail app with a pre-written email to
   `support@lohiyaai.com` containing your store ID and app version (handy
   for tech support).

The app version is shown at the bottom of the screen.

---

## 23. Notifications

You receive push notifications even when the app is closed.

| Event | What it looks like |
| --- | --- |
| Trial ending soon | *"Your trial ends in 3 days — upgrade now"* |
| Subscription activated | *"Welcome to Pro!"* |
| Udhaar reminder sent | *"Reminder sent to Ramesh — ₹450 pending"* |
| Low stock 🔒 Pro | *"Atta is running low — 2 units left"* |
| Expiry warning 🔒 Pro | *"3 items expire this week"* |
| Trial approved | *"Your trial is now active — start billing"* |

Tapping a notification opens the app directly to the relevant screen
(udhaar reminder → that customer's khata, low stock → Inventory, etc.).

### Viewing all notifications

Tap the **bell icon** on the Overview tab or the POS / Finance screens to
open the full notifications list. Each entry is dated, tappable, and can
be cleared.

---

## 24. Signing Out

**Profile → scroll to the bottom → Sign Out (red button)**.

What happens:
- Your session token is erased from this device.
- Both auth tokens (Kirana + POS) are cleared.
- You are returned to the Login screen.

What stays:
- Your data on the server (orders, inventory, customers, settings) is
  untouched.
- The fact that you finished onboarding — next time you sign in on this
  device you skip onboarding.

Sign back in with the same phone number or username and password to
restore the app exactly as you left it.

---

## 25. Troubleshooting

### "POS Offline" badge in the Billing tab

The app cannot reach the POS service.

- Check your internet connection (try opening another website).
- Pull down on the screen to retry.
- If the badge stays red, sign out and sign back in — this re-issues your
  POS token.

### Login OTP not arriving

- Confirm your SIM has signal and that you are not blocking unknown SMS.
- Wait 30 seconds and tap **Resend OTP**.
- If still nothing, try the *Username* tab instead, or contact support.

### Search returns no products

- Tap the **🔄 Refresh** icon in the top bar to reload from the server.
- If the count is still zero, you may not have added any inventory yet —
  go to the Stock tab and tap the orange **+** button.

### Stock count looks wrong after a sale

- Pull down on the Stock tab to refresh.
- If the discrepancy persists, edit the product and correct the stock
  manually.

### Barcode scan does not detect

- Clean the phone camera lens.
- Increase the light on the barcode (hold the product near a lamp).
- Try the *Stock* tab's scan button — it can edit existing items by
  barcode, useful for testing if the scanner works at all.

### Trial says "Pending" for a long time

- Trial approvals are usually within a few hours but may take longer.
- Make sure notifications are enabled — you receive a push the moment
  approval happens.
- Pull down on the pending screen to re-check status manually.

### Voice / Handwrite says "Daily limit reached"

- Pro plans have a daily quota (visible as e.g. "Voice 0/10" on the AI
  strip).
- The quota resets at midnight local time.

### App is blocked / disabled

If the splash screen takes you to a full-screen block message, it means
LohiyaAI has temporarily disabled the app for maintenance or has flagged
your store specifically. The reason is shown on the screen along with a
support contact. There is nothing to do in the app itself except wait or
reach out to support.

### Anything else

- **In-app:** Profile → Help & Support → Report an Issue.
- **Email:** support@lohiyaai.com (the Help & Support → Email Support
  option pre-fills your store ID, owner name, and app version for you).
