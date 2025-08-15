import 'dart:developer';
import 'package:foxxhealth/core/services/dynamic_links_service.dart';

/// Test class for deep linking functionality
class DeepLinkTest {
  static final DynamicLinksService _dynamicLinksService = DynamicLinksService();

  /// Test creating different types of dynamic links
  static Future<void> testDynamicLinks() async {
    log('Testing dynamic links...');

    // Test payment success link
    final paymentLink = await _dynamicLinksService.createPaymentSuccessLink(
      sessionId: 'test_session_123',
      amount: '29.99',
      currency: 'USD',
    );
    log('Payment success link: $paymentLink');

    // Test premium feature link
    final premiumLink = await _dynamicLinksService.createPremiumFeatureLink(
      featureName: 'Advanced Analytics',
      featureDescription: 'Get detailed insights into your health data',
    );
    log('Premium feature link: $premiumLink');

    // Test referral link
    final referralLink = await _dynamicLinksService.createReferralLink(
      referrerId: 'user_123',
      referrerName: 'John Doe',
    );
    log('Referral link: $referralLink');
  }

  /// Test URLs that should open the app
  static List<String> getTestUrls() {
    return [
      'https://foxxhealth.app',
      'https://foxxhealth.app/payment-success?session_id=test_123',
      'https://foxxhealth.app/premium?feature=analytics',
      'https://foxxhealth.app/referral?ref=user_123',
      'foxxhealth://app',
      'foxxhealth://payment-success',
      'foxxhealth://premium-feature',
    ];
  }

  /// Print test instructions
  static void printTestInstructions() {
    log('''
=== Deep Link Testing Instructions ===

1. Build and install the app on your device
2. Test these URLs in a browser or messaging app:

${getTestUrls().map((url) => '   • $url').join('\n')}

3. Expected behavior:
   - URLs should open your FoXX Health app
   - App should log the incoming link data
   - App should handle different link types appropriately

4. To test on device:
   - Open browser and navigate to https://foxxhealth.app
   - Should redirect to your app
   - Check console logs for deep link data

5. To test custom scheme:
   - Use foxxhealth:// URLs
   - These work even without internet connection

=== End Test Instructions ===
    ''');
  }
}
