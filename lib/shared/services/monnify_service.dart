import 'package:monnify_payment_sdk/monnify_payment_sdk.dart';
import 'package:monnify_payment_sdk/src/models/transaction_response.dart';

class MonnifyConfig {
  // Replace these with your live/test Monnify credentials from https://app.monnify.com
  static const String apiKey = 'MK_TEST_SAF89234JJ'; // Sandbox test API Key
  static const String contractCode = '8629471940'; // Sandbox test contract code
  static const ApplicationMode mode = ApplicationMode.TEST;
}

class MonnifyService {
  Monnify? _monnify;

  Future<void> _initMonnify() async {
    if (_monnify != null) return;
    try {
      _monnify = await Monnify.initialize(
        apiKey: MonnifyConfig.apiKey,
        contractCode: MonnifyConfig.contractCode,
        applicationMode: MonnifyConfig.mode,
      );
    } catch (e) {
      print('Monnify initialization error: $e');
    }
  }

  Future<TransactionResponse?> startPayment({
    required double amount,
    required String customerName,
    required String customerEmail,
    required String paymentDescription,
    String? paymentReference,
  }) async {
    await _initMonnify();

    final ref = paymentReference ?? 'NHC_${DateTime.now().millisecondsSinceEpoch}';

    final transaction = TransactionDetails(
      amount: amount,
      currencyCode: 'NGN',
      customerName: customerName,
      customerEmail: customerEmail,
      paymentReference: ref,
      paymentDescription: paymentDescription,
      paymentMethods: [
        PaymentMethod.CARD,
        PaymentMethod.ACCOUNT_TRANSFER,
        PaymentMethod.USSD,
      ],
    );

    try {
      if (_monnify != null) {
        final response = await _monnify!.initializePayment(
          transaction: transaction,
        );
        return response;
      }
    } catch (e) {
      print('Monnify Payment Error: $e');
    }

    return null;
  }
}
