# Kirana AI — How the App Works

This document explains every feature in the app from a user's point of view: where to go, what to tap, and what happens as a result.

---

## Getting Started

### First Launch — Onboarding
When you open the app for the first time, it takes you through a setup flow to create your store profile.

- Enter your **phone number** to receive an OTP, or use **email and password** to sign in.
- Fill in your **store name**, **location**, **business category**, and estimated daily footfall.
- Once complete, your account is created and you land on the Home Dashboard.

On every subsequent launch, the app checks your login status and takes you straight to the dashboard — no re-login needed unless you sign out.

---

## Home Dashboard

The first screen you see after logging in. It is split into three tabs at the bottom: **Overview**, **POS**, and **Finance**.

---

### Overview Tab

This is your daily business snapshot.

**What you see:**
- A greeting with your name and today's date.
- **Today's Sales card** — total revenue billed today, number of orders, and average order value.
- **AI Intelligence cards** — four automatically updated cards that highlight what needs your attention:
  - **Fast Moving** — products selling fastest right now. Useful to make sure you have enough stock.
  - **Stockout Risk** — items the AI predicts will run out in the next 3–7 days based on your sales velocity.
  - **Reorder Required** — items already below your minimum stock threshold.
  - **High Profit** — products with the best margins, so you know what to push.
- **Pro Alerts strip** *(Pro plan only)* — a horizontal row of coloured chips at the top for things needing immediate action: overdue udhaar, low stock, expiring items, or subscription issues. Tap any chip to jump directly to the relevant screen.

**What you can do:**
- Tap any intelligence card to open a full ranked list with details for that category.
- Tap the **bell icon** (top right) to see all your notifications.
- Tap the **+ New Sale** floating button to jump straight to billing.

---

## POS (Point of Sale)

**Where:** Home → POS tab (second tab at the bottom)

The billing screen. Use this every time a customer buys something.

### Building a Cart

**Search for a product:**
Type the product name, brand, or barcode number in the search bar at the top. Matching products appear instantly. Tap one to add it to the cart.

**Scan a barcode:**
Tap the **barcode icon** next to the search bar. The camera opens and scans continuously. Each item scanned is looked up in your inventory and added to the list at the bottom of the scanner sheet. Tap **Add to Cart** when done to move all scanned items to the cart at once.

- If a scanned barcode is not in your inventory, you get two options: **Add as New Product** (opens the product creation form with the barcode pre-filled) or **Link to an Existing Item** (pick any existing product without a barcode to assign this barcode to it).

**Loose / weighed items:**
For items sold by weight or volume (e.g. dal, oil), tapping them opens a dialog asking for the quantity or weight. Enter the amount and confirm.

**Daily Basket Campaigns:**
Below the search bar there is a horizontal scroll of AI-suggested campaign cards (e.g. "Morning Essentials", "Weekend Family Basket"). Each card shows the bundle items and a suggested price. Tap **Add to Cart** on a campaign card to add all items in that bundle to your cart in one go.

### Managing the Cart

Once items are in the cart:
- **Increase/decrease quantity** using the + and − buttons on each row.
- **Swipe a cart row left** to remove that item.
- Tap the **Clear** button (top right of the cart section) to empty the entire cart — a confirmation prompt appears so you don't do it by accident.

### Completing a Sale

Tap the **Checkout** button. A dialog appears where you:
1. **Select a customer** (optional) — search from your saved customers or leave blank for a walk-in.
2. **Choose payment method** — Cash, UPI, Card, or Credit (for khata/udhaar).
3. Confirm the total and tap **Place Order**.

The order is saved, stock is deducted automatically, and if you selected Credit the amount is added to that customer's khata balance.

### Today's Orders

Tap the **Today** button (clock icon area) to see a sheet listing every order billed today with their amounts and payment methods.

---

## Inventory

**Where:** Home → POS tab → **Inventory** sub-tab

Manage your product catalogue and stock levels.

**What you see:**
- All products grouped by category, each showing current stock quantity and unit.
- Colour indicators: red for out-of-stock, orange for low stock.

**What you can do:**
- **Search** products by name or category.
- **Tap a product** to edit its details — name, price, MRP, stock quantity, reorder level, expiry date.
- **Add a new product** using the + button (top right). Fill in name, category, price, MRP, and optionally scan a barcode. The app tries to fetch product details automatically from the barcode.
- **Filter** by low-stock or near-expiry to focus on what needs attention.

---

## Procurement

**Where:** Home → POS tab → **Procurement** sub-tab

Log goods received from suppliers.

- Create a purchase entry: select the supplier, add products and quantities received, and record the invoice amount.
- The stock levels in Inventory update automatically when a purchase is confirmed.
- Pending and completed purchase orders are listed here for reference.

---

## Finance

**Where:** Home → Finance tab (third tab at the bottom)

Tracks all credit — both what your customers owe you and what you owe your suppliers.

### Udhaar Tab (Customer Credit)

Udhaar means goods given on credit to customers. This tab shows:
- A summary of **total outstanding amount** across all customers.
- A list of every customer with an open balance, showing how much they owe and since when.
- Customers with overdue balances are highlighted.

**What you can do:**
- Tap a customer row to see their full credit history and individual transactions.
- Tap the **WhatsApp icon** on any customer to send them a payment reminder message directly.
- Mark payments as received when a customer pays off their balance.

### Distributor Tab (Supplier Credit)

Shows credit you owe to your distributors and suppliers.
- Lists each supplier with the total outstanding amount.
- Tapping a supplier shows the individual purchase orders that make up the balance.

---

## Customer Relations

**Where:** Profile → Customer Relations

A full directory of your store's customers.

**What you see:**
- Every customer with their name, phone, and automatically computed segment badge:
  - **Regular** — ordered 3+ times in the last 30 days
  - **Bulk** — high total spending, not inactive
  - **Occasional** — 1+ orders in 90 days but not regular
  - **Impulse** — active but no clear pattern
  - **Credit** — has an outstanding udhaar balance
  - **Inactive** — no orders in over 60 days

**Filtering and search:**
- Type in the search bar to find customers by name or phone.
- Tap any segment badge (Regular, Bulk, etc.) at the top to filter the list to just that group.

**Syncing contacts:**
Tap the **Sync icon** (top right). The app reads your phone contacts and imports names and numbers that aren't already in the system. You can review before saving.

**Adding a customer manually:**
Tap the **+ button** (bottom right). Fill in name, phone, email (optional), and household size.

**Editing or deleting a customer:**
Tap any customer in the list to open their detail screen, then use the edit (pencil) or delete (bin) icons in the top bar.

---

## Customer Detail

**Where:** Profile → Customer Relations → tap any customer

A complete profile for one customer.

**What you see:**
- Name, phone, email.
- Three summary cards: current khata balance, total amount ever spent, total number of orders.
- **Customer Info** section: household size, date they joined, and their **Area / Association** (the nearby area they belong to, used for heatmap tracking).
- Full **Purchase History** — every order they've placed, with date, total, and a tap-through to full order details.

**Tagging a customer to an area:**
In the Customer Info section, tap the **Area / Association** dropdown. It shows all the nearby areas you have added (apartments, hostels, etc.). Select the one this customer belongs to. This links their orders to that area and populates the heatmap. To unlink, choose "None."

---

## Area Associations

**Where:** Profile → Area Associations

Track which nearby locations your customers come from, and see how much revenue each area generates.

### My Areas Tab

Add the locations near your store that are sources of regular customers — apartment complexes, hostels, schools, offices, or residential colonies.

**Adding an area:**
Tap the **+ button** (top right). Choose the area type (apartment, hostel, school, office, colony), enter a name, optionally enter the estimated number of households, and add any notes. Tap **Add Area**.

**Managing areas:**
- Use the **toggle switch** on each area to mark it active or inactive. Inactive areas are excluded from campaign suggestions.
- Tap the **delete icon** to remove an area entirely.

### Customer Heatmap Tab

Shows revenue, order count, average order value, and customer count for each area over the last 90 days. A bar indicates each area's share of total revenue relative to the highest-performing area.

> **Note:** Data only appears here after you tag customers to areas from the Customer Detail screen.

---

## KPI Subscriptions

**Where:** Profile → KPI Subscriptions

Choose which business metrics you want to monitor on your dashboard.

**What you see:**
- If you haven't subscribed to any KPIs yet, the screen opens in edit mode showing all available KPIs grouped by category (Sales, Inventory, Finance, Customer, etc.).
- If you already have subscriptions, your chosen KPIs are shown as live metric cards with current values.

**Subscribing to a KPI:**
In edit mode, tap any KPI card to toggle it on or off. When done, tap **Done** to save. Your selections appear as cards on the dashboard overview.

**Editing later:**
Tap the **settings icon** (top right) to go back to edit mode and change your selection.

---

## Customer Growth (Referral)

**Where:** Profile → Customer Growth
**Requires:** Pro plan

Turn your existing customers into a growth engine by creating referral campaigns.

**Creating a campaign:**
Tap **+ New Campaign**. Give the campaign a name, set the reward for the referrer (the existing customer who brings someone new), and optionally set an expiry date.

**Sharing the campaign:**
Once created, tap the campaign card to open it, then tap **Share QR**. A QR code is generated that you can print or show to customers. When a new customer scans it, they are linked to the referrer, who earns the reward.

---

## Cashflow Support

**Where:** Profile → Cashflow Support banner (the dark blue card)
**Requires:** Pro plan

Apply for business financing between ₹50,000 and ₹10,00,000 tailored to kirana store owners.

- The screen shows eligibility criteria and available financing ranges.
- Fill in the application form with business details and submit.
- Track application status from the same screen.

---

## Subscription & Plans

**Where:** Profile → Subscription & Plans

Manage which plan your store is on.

**Plans available:**

| Plan | Monthly Cost | Per Day |
|------|-------------|---------|
| Free Trial | Free for 14 days | — |
| Basic | ₹200/month | ₹7/day |
| Pro | ₹500/month | ₹17/day |

**How to upgrade:**
Tap **Get Basic** or **Get Pro**. This triggers Google Play Billing — a standard payment sheet appears. Complete payment and your plan activates within seconds.

**Trial period:**
New stores get a 14-day free trial with Basic-level access. A countdown shows how many days remain. After the trial ends, the app shows an upgrade wall — you can still see the dashboard but cannot bill or access most features until you subscribe.

**Restore a purchase:**
If you reinstalled the app or switched phones, tap **Restore Purchases** to recover an existing subscription linked to your Google account.

---

## Transaction History

**Where:** Profile → Transaction History

A full log of every sale billed through the POS, accessible any time.

- Filter by **date range**, **payment method** (Cash, UPI, Card, Credit), and **order status**.
- Tap any transaction to see the full itemised order with product names, quantities, prices, and the customer name if one was selected.

---

## Store Settings

**Where:** Profile → Store Settings

Edit your store's public details:
- Store name and address
- Business category
- Operating hours

Changes are saved to your account and reflected wherever your store name appears in the app.

---

## Configuration

**Where:** Profile → Configuration

Personal preferences for how the app behaves:
- **Default payment method** — pre-selects Cash, UPI, etc. when the checkout dialog opens.
- **AI suggestion settings** — turn on or off specific types of intelligence suggestions.
- **Notification preferences** — control which alert types you receive as push notifications.

---

## Help & Support

**Where:** Profile → Help & Support

Three options:

**FAQs:**
Answers to common questions — how to add products, how stockout prediction works, how to manage khata, how to sync contacts, what KPIs are, and how to view sales reports.

**Report an Issue:**
Fill in a categorised form to report a problem:
- Categories: App bug, Pricing issue, Inventory problem, AI recommendation issue, POS error, Feature request.
- Describe the issue and submit. The team receives it directly.

**Contact:**
Direct contact options (WhatsApp / email) for anything not covered by FAQs.

---

## Push Notifications

You receive push notifications for important events even when the app is closed:

- **Trial ending soon** — reminder before your free trial expires.
- **Subscription activated** — confirmation after payment goes through.
- **Udhaar reminder sent** — confirmation when a WhatsApp reminder is dispatched to a customer.
- **Low stock / expiry alert** *(Pro)* — when a product hits your reorder threshold or is nearing expiry.

Tapping a notification opens the app directly to the relevant screen.

---

## Sign Out

**Where:** Profile → scroll to the bottom → **Sign Out** button

Clears your session from this device. Your data remains on the server. Log back in with the same phone number or email to restore everything.
