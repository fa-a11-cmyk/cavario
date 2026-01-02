import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentService {
  static const String publishableKey = 'pk_test_YOUR_STRIPE_PUBLISHABLE_KEY';
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      StripePayment.setOptions(StripeOptions(
        publishableKey: publishableKey,
        merchantId: 'merchant.cavario.app',
        androidPayMode: 'test',
      ));
      _initialized = true;
    }
  }

  static Future<bool> processPayment({
    required BuildContext context,
    required double amount,
    required String currency,
    required String description,
  }) async {
    try {
      await initialize();

      // Créer PaymentMethod
      final paymentMethod = await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );

      if (paymentMethod == null) return false;

      // Confirmer le paiement
      final paymentIntent = await _createPaymentIntent(
        amount: (amount * 100).toInt(), // Stripe utilise les centimes
        currency: currency,
        description: description,
      );

      final result = await StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id,
        ),
      );

      if (result.status == PaymentIntentStatus.Succeeded) {
        _showSuccessDialog(context);
        return true;
      }
      
      return false;
    } catch (e) {
      _showErrorDialog(context, e.toString());
      return false;
    }
  }

  static Future<Map<String, dynamic>> _createPaymentIntent({
    required int amount,
    required String currency,
    required String description,
  }) async {
    // Simulation - En production, appeler votre backend
    return {
      'client_secret': 'pi_test_client_secret',
      'amount': amount,
      'currency': currency,
    };
  }

  static void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Paiement réussi'),
        content: const Text('Votre paiement a été traité avec succès.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur de paiement'),
        content: Text('Une erreur est survenue: $error'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}