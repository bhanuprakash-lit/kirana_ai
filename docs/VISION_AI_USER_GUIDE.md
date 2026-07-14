# Vision AI — User Guide

**Count your stock and know what sold — just by taking photos.**

Vision AI lets your phone camera do the counting for you. Instead of scanning
each item or typing numbers, you photograph your shelves and the app works out
how many of each product you have — and how many you sold. This guide explains
what it does, who can use it, and how to get the best results.

> This is a companion to the main **[User Manual](USER_MANUAL.md)**. If you're
> looking for general billing, inventory or profile help, start there.

**Last updated:** July 2026

---

## Table of Contents

1. [What Vision AI Does](#1-what-vision-ai-does)
2. [Who Can Use It](#2-who-can-use-it)
3. [How the Camera "Sees" Your Stock (in plain words)](#3-how-the-camera-sees-your-stock-in-plain-words)
4. [Feature 1 — Shelf Scan: What Sold Today](#4-feature-1--shelf-scan-what-sold-today)
5. [Feature 2 — Reviewing & Correcting a Scan](#5-feature-2--reviewing--correcting-a-scan)
6. [Feature 3 — The Live Counter](#6-feature-3--the-live-counter)
7. [Feature 4 — Camera Stock-In (Filling Inventory)](#7-feature-4--camera-stock-in-filling-inventory)
8. [Getting the Best Results](#8-getting-the-best-results)
9. [Privacy — What Happens to Your Photos](#9-privacy--what-happens-to-your-photos)
10. [Troubleshooting](#10-troubleshooting)
11. [Frequently Asked Questions](#11-frequently-asked-questions)

---

## 1. What Vision AI Does

Vision AI has **four related tools**, all powered by the same product-recognition
technology:

| Tool | What it's for | Where you find it |
| --- | --- | --- |
| **Shelf Scan** | Photograph shelves morning & evening → the app tells you **what sold** | Vision tab → *Shelf Scan* |
| **Review & Correct** | Check the app's counts and fix anything it got wrong | Opens after a scan (*Review*) |
| **Live Counter** | Point the camera at the counter → it **tallies items** as they pass | Vision tab → *Counter* |
| **Camera Stock-In** | Photograph shelves → **fill or top-up your inventory** automatically | Stock tab → *Snap Shelves* / restock |

The big idea: **you already have the stock in front of you — let the camera
count it** instead of counting by hand.

---

## 2. Who Can Use It

Vision AI's **Shelf Scan**, **Review** and **Counter** live on a dedicated
**Vision tab** (the 4th bottom tab). It appears when **both** are true:

- Your plan is **Pro**, and
- Your shop is a **grocery-family** store (kirana, supermarket, provision,
  fruits & veg, pharmacy, bakery, and similar).

If you're on Basic, tapping the Vision area shows an **upgrade to Pro** prompt.
If your shop type isn't grocery-family, the tab is hidden — Vision's product
recognition is tuned for packaged grocery products.

**Camera Stock-In** (Feature 4) is more widely available: it's reachable from
the **Stock tab** and is not Pro-locked, though it's limited to a few scans per
day to keep things fair.

---

## 3. How the Camera "Sees" Your Stock (in plain words)

You don't need to understand the technology to use Vision AI, but here's the
gist so the results make sense:

- When you take a photo, the app **finds each product in the picture** and draws
  an invisible box around it — one box per item it spots.
- It then **recognises** each boxed item and matches it to a product in your
  catalogue (by its packaging and any visible text like the brand, weight or
  variant).
- Items it's confident about are counted automatically. Items it **isn't sure
  about** are marked *"Needs review"* so you can confirm them (see §5).
- The recognition runs in two ways working together: a **built-in model that
  knows hundreds of common grocery products** does the main work, and a
  **cloud AI helps with products the built-in model doesn't know yet**. If the
  cloud helper is unavailable, the built-in model still carries the scan — you
  just might get a few more "needs review" items.
- Every item you correct **teaches the system** to recognise that product next
  time. The more you use it, the better it gets for your shelf.

For the **Live Counter**, everything happens **on your phone in real time** — it
doesn't send video anywhere. It watches the camera, tracks each item, and counts
it once as it crosses a line on the screen.

---

## 4. Feature 1 — Shelf Scan: What Sold Today

This is the headline feature. The idea is simple:

> **Photograph your shelves in the morning. Photograph them again in the
> evening. The difference is what you sold.**

### Step by step

1. Open the **Vision tab** → **Shelf Scan** sub-tab. You'll see two cards:
   **Morning** ☀️ and **Evening** 🌙.
2. In the morning, tap **Take Photo** on the Morning card.
3. The **Add Photos** sheet opens. Add **3 to 10 photos** covering your shelves:
   - **From Camera** — snap them one at a time, or
   - **From Gallery** — pick photos you already took.
   - Each photo shows as a thumbnail; tap the **✕** on one to remove it.
4. When you have at least 3 photos, tap **Analyse (N)**. The app uploads and
   counts the products. This takes a little while — the card shows
   *"Analysing…"*.
5. When done, the Morning card shows:
   - **Products identified** — how many distinct products it found.
   - **Units counted** — the total number of items.
   - **Needs review** (if any) — items it wasn't sure about (orange).
6. Repeat in the **evening** on the Evening card.
7. Once **both** scans are done, tap **View Sales** (or the **Results**
   sub-tab).

### Reading the Results

The **Results** sub-tab shows **what sold**, worked out as
**morning count − evening count** for each product:

- A green **Total Sold** banner at the top.
- One row per product: its name, the **morning count** and **evening count**,
  and how many **sold**.

You'll also get a **push notification** when a scan finishes, so you don't have
to wait on the screen.

### If a scan is still processing or fails

- **Still processing** — a big batch of photos can take longer than the app
  waits. The card stays as *"Processing…"* with a **Check again** button — tap
  it (or pull down) to refresh.
- **Scan failed** — tap **Retake** to try again (usually a connection issue or
  very blurry photos).

---

## 5. Feature 2 — Reviewing & Correcting a Scan

After any scan, tap **Review** on the session card to open the item list. This
is where you make the counts exactly right — and teach the app.

Each row shows:

- A **cropped thumbnail** of the actual item from your photo (so you can see
  exactly what the app is pointing at).
- The product **name** (or a guess) and how many it counted (**×N**).
- A status: **green tick** (recognised), or orange **"Unknown item — needs
  review"**.

**To correct an item:**

1. Tap the row. A sheet opens showing the enlarged crop.
2. **Search your products** and tap the correct one.
3. The item is now linked to that product. If you picked wrong, reopen it and
   tap **Clear correction**.

Every correction does two things: it fixes today's count, and it **trains the
system** so that product is recognised automatically next time. Spending a
minute on "needs review" items early on pays off quickly.

---

## 6. Feature 3 — The Live Counter

The **Counter** sub-tab turns your phone into a live tally counter at the
billing area.

### How it works

- Point the camera so products pass across the middle of the screen (there's a
  **line** drawn on screen).
- As each item **crosses the line**, the app counts it **once** and briefly
  flashes what it counted.
- A running tally builds up per product. When you're done, **finish** the
  session and the totals are saved as that day's counter summary.

### Good to know

- **It works fully on your phone.** No video is uploaded, and it keeps counting
  even with **no internet** — the totals sync later when you're back online.
- It asks for **camera permission** the first time you start a session.
- You can **pause** and **resume** counting within a session.
- This is handy for fast-moving items at the counter, or for spot-counting a
  batch of stock as it comes in.

---

## 7. Feature 4 — Camera Stock-In (Filling Inventory)

Instead of adding products one by one, you can **photograph your shelves and let
the app fill your inventory**. There are two situations:

### A. New / empty store — "Snap Shelves"

1. Go to the **Stock** tab. On an empty inventory you'll see a **Snap Shelves**
   option.
2. Take **3 to 10 photos** of your shelves (camera only, for accuracy).
3. The app detects products and shows a **review list with quantities**.
4. Confirm or adjust each quantity, correct any "needs review" items (same as
   §5), then commit. The counted quantities become your **opening stock**.

### B. Existing store — camera restock

1. From a stocked inventory, use the **camera restock** option in the Stock
   tab.
2. Take photos the same way.
3. Here the counted quantities **add on top of** your current stock (a top-up),
   rather than replacing it.

### Resuming a scan

If a stock-in scan is still processing when you leave, you'll get a
notification when it's ready — tapping it takes you **straight back to the
review screen** to finish confirming.

> **Limit:** Camera stock-in is capped at a few scans per store per day to keep
> the service fast for everyone.

---

## 8. Getting the Best Results

A few habits make Vision AI noticeably more accurate:

- **Good, even light.** Avoid deep shadows and glare on shiny packaging. Near a
  lamp or in daylight works best.
- **Fill the frame with shelves**, not the floor or ceiling. Products should be
  reasonably large in the photo.
- **Steady, front-on shots.** Hold still; shoot straight at the shelf rather
  than at a steep angle.
- **Overlap your photos** so every product appears in at least one shot — but
  don't photograph the same shelf many times, or items get double-counted.
- **Use 4–8 photos** for a normal shelf run. More isn't always better; 10 is the
  maximum.
- **Same framing morning and evening.** For "what sold", try to photograph the
  same shelves the same way both times — the count difference is only meaningful
  if both scans cover the same stock.
- **Correct the "needs review" items early.** After a week of corrections the
  app recognises your regular products almost entirely on its own.

---

## 9. Privacy — What Happens to Your Photos

- **Shelf-scan and stock-in photos** are uploaded to the app's secure cloud
  storage so the AI can count them and so the review thumbnails keep working
  even if you close the app. They're tied to your store.
- **Live Counter video is never uploaded.** Counting happens entirely on your
  phone; only the final per-product tally is synced.
- Items you correct are used to **improve product recognition**.

If you have questions about data handling, use **Profile → Help & Support →
Email Support**.

---

## 10. Troubleshooting

**I don't see the Vision tab.**
It's **Pro-only** and **grocery-family-only**. Check: (1) your plan is Pro
(Profile → Subscription & Plans), and (2) your store type is a grocery-family
type (Profile → Store Settings). If both are correct and it's still missing,
sign out and back in.

**The scan is taking a long time.**
Large photo batches take longer than the app waits on screen. Tap **Check
again** on the card or pull down to refresh; you'll also get a notification when
it's ready.

**The scan failed.**
Usually a weak connection or very blurry photos. Tap **Retake**, check your
internet, and follow the tips in §8.

**Lots of items say "Needs review".**
This is normal at first, especially for products the app hasn't seen before.
Correct them once (§5) and they'll be recognised automatically next time. Better
lighting and framing also reduce this.

**The counts look too high / double-counted.**
You may have photographed the same shelf in several photos. Use overlapping but
distinct shots so each item appears roughly once.

**"What sold" numbers look off.**
Make sure both the **morning and evening** scans cover the **same shelves** with
similar framing — the sold figure is the difference between the two, so it's
only accurate if both scans see the same stock.

**The Live Counter won't start.**
It needs **camera permission**. Grant it when asked (or in your phone's app
settings), then start the session again.

**Camera stock-in says I've hit a limit.**
Stock-in is capped at a few scans per day. Try again tomorrow, or add remaining
items manually from the Stock tab.

---

## 11. Frequently Asked Questions

**Do I have to scan every single product?**
No. Vision counts whatever is in the photos. You can still add or edit anything
manually in the Stock tab.

**Does it replace my normal billing?**
No. Vision is for **counting stock** and **estimating what sold**. Actual sales
still go through the POS billing screen, which is the source of truth for
revenue. Think of Shelf Scan as a fast daily stock check, not a cash register.

**Will it work for my clothing / electronics / salon shop?**
The Vision tab is tuned for **grocery-style packaged products**, so it's shown
only to grocery-family shops. Other shop types use the normal add-product and
variant tools instead.

**Does it need internet?**
Shelf Scan and Camera Stock-In upload photos, so they need a connection. The
**Live Counter works offline** and syncs its totals later.

**What happens to products the app has never seen?**
They're flagged "needs review". When you tell the app what they are, it learns
them — so recognition improves the more you use it.

**Is my data safe?**
Shelf photos are stored securely and tied to your store; counter video never
leaves your phone. See §9.

---

*For everything else about the app, see the main
**[User Manual](USER_MANUAL.md)**.*
