// Unit tests for the cart-related logic on PosState. These do NOT spin up
// the PosNotifier — its build() kicks off a network load via a microtask
// that is hard to await deterministically. Cart maths is the highest-value
// thing to cover and lives entirely on PosState.

import 'package:flutter_test/flutter_test.dart';
import 'package:kirana_ai/features/pos_inventory/models/cart_item.dart';
import 'package:kirana_ai/features/pos_inventory/models/pos_product.dart';
import 'package:kirana_ai/features/pos_inventory/providers/pos_provider.dart';

PosProduct _product({int id = 1, double price = 100, bool loose = false}) =>
    PosProduct(
      productId: id,
      name: 'Item $id',
      unit: loose ? 'kg' : null,
      isPerishable: false,
      isLoose: loose,
      categoryId: 1,
      price: price,
      stockQuantity: 10,
    );

PosState _stateWithCart(List<CartItem> cart) => PosState(cart: cart);

void main() {
  group('PosState.subtotal', () {
    test('is zero for an empty cart', () {
      expect(const PosState().subtotal, 0);
    });

    test('sums line totals across multiple lines', () {
      final state = _stateWithCart([
        CartItem(product: _product(id: 1, price: 100), quantity: 2),
        CartItem(product: _product(id: 2, price: 50), quantity: 1),
        CartItem(
          product: _product(id: 3, price: 25, loose: true),
          quantity: 2.5,
        ),
      ]);
      expect(state.subtotal, 100 * 2 + 50 * 1 + 25 * 2.5);
    });
  });

  group('PosState.cartItemCount', () {
    test('sums quantities, including fractional loose ones', () {
      final state = _stateWithCart([
        CartItem(product: _product(id: 1), quantity: 2),
        CartItem(product: _product(id: 2, loose: true), quantity: 0.5),
      ]);
      expect(state.cartItemCount, 2.5);
    });
  });

  group('PosState referral discount', () {
    test('discountedSubtotal == subtotal when no referral set', () {
      final state = _stateWithCart([
        CartItem(product: _product(price: 100), quantity: 2),
      ]);
      expect(state.discountedSubtotal, 200);
      expect(state.discountAmount, 0);
    });

    test('applies the percentage when set', () {
      final state = PosState(
        cart: [CartItem(product: _product(price: 100), quantity: 2)],
        referralDiscountPct: 10,
      );
      expect(state.subtotal, 200);
      expect(state.discountedSubtotal, 180);
      expect(state.discountAmount, 20);
    });

    test('treats a zero/negative percentage as no discount', () {
      final zero = PosState(
        cart: [CartItem(product: _product(price: 100), quantity: 1)],
        referralDiscountPct: 0,
      );
      expect(zero.discountedSubtotal, 100);
      expect(zero.discountAmount, 0);
    });
  });

  group('PosState.copyWith', () {
    test('preserves fields that are not passed', () {
      final base = PosState(
        cart: [CartItem(product: _product(), quantity: 1)],
        selectedCustomerId: 7,
        selectedCustomerName: 'Ramesh',
        referralDiscountPct: 10,
        referralReferrerName: 'Friend',
      );
      final next = base.copyWith(isLoadingProducts: true);
      expect(next.isLoadingProducts, isTrue);
      expect(next.cart, hasLength(1));
      expect(next.selectedCustomerId, 7);
      expect(next.referralDiscountPct, 10);
    });

    test('clearCustomer drops both customer fields', () {
      final base = PosState(
        selectedCustomerId: 7,
        selectedCustomerName: 'Ramesh',
      );
      final next = base.copyWith(clearCustomer: true);
      expect(next.selectedCustomerId, isNull);
      expect(next.selectedCustomerName, isNull);
    });

    test('clearReferral drops discount, referrer, and pending scan', () {
      final base = PosState(
        referralDiscountPct: 10,
        referralReferrerName: 'Friend',
      );
      final next = base.copyWith(clearReferral: true);
      expect(next.referralDiscountPct, isNull);
      expect(next.referralReferrerName, isNull);
      expect(next.pendingReferral, isNull);
    });

    test('clearError nulls the error', () {
      final base = PosState(cart: const []).copyWith(error: 'boom');
      expect(base.error, 'boom');
      final cleared = base.copyWith(clearError: true);
      expect(cleared.error, isNull);
    });
  });

  group('CartItem.lineTotal', () {
    test('multiplies unit price by quantity', () {
      final item = CartItem(product: _product(price: 49.5), quantity: 3);
      expect(item.lineTotal, 49.5 * 3);
    });

    test('copyWith only replaces quantity', () {
      final original = CartItem(product: _product(price: 100), quantity: 1);
      final copy = original.copyWith(quantity: 5);
      expect(copy.product.productId, original.product.productId);
      expect(copy.quantity, 5);
      expect(original.quantity, 1);
    });
  });
}
