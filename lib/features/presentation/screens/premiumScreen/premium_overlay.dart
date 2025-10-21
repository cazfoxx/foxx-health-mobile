import 'dart:developer';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foxxhealth/features/presentation/screens/background/foxxbackground.dart';
import 'package:foxxhealth/features/presentation/theme/app_colors.dart';
import 'package:foxxhealth/features/presentation/theme/app_text_styles.dart';
import 'package:foxxhealth/features/presentation/screens/profile/terms_of_use_screen.dart';
import 'package:foxxhealth/features/presentation/screens/profile/privacy_policy_screen.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:foxxhealth/core/network/api_client.dart';
import 'package:dio/dio.dart';

class PremiumOverlay extends StatefulWidget {
  const PremiumOverlay({Key? key}) : super(key: key);

  @override
  State<PremiumOverlay> createState() => _PremiumOverlayState();
}

class _PremiumOverlayState extends State<PremiumOverlay> {
  bool isYearlySelected = false;
  bool isMonthlySelected = true;
  bool _isLoading = false;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final ApiClient _apiClient = ApiClient();
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  // Product IDs - replace with your actual product IDs from App Store/Google Play
  static const String yearlyProductId = 'foxx_health_yearly_premium';
  static const String monthlyProductId = 'foxx_health_monthly_premium';

  @override
  void initState() {
    super.initState();
    _initializeStore();
    _listenToPurchaseUpdated();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _initializeStore() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      setState(() {
        _isAvailable = false;
      });
      return;
    }

    setState(() {
      _isAvailable = true;
    });

    // Load products with retry mechanism
    await _loadProductsWithRetry();
  }

  Future<void> _loadProductsWithRetry({int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      log('Loading products - attempt $attempt of $maxRetries');
      await _loadProducts();

      if (_products.isNotEmpty) {
        log('Products loaded successfully on attempt $attempt');
        return;
      }

      if (attempt < maxRetries) {
        log('No products found, retrying in 2 seconds...');
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    log('Failed to load products after $maxRetries attempts');
  }

  Future<void> _loadProducts() async {
    try {
      final Set<String> productIds = {yearlyProductId, monthlyProductId};
      log('Attempting to load products: $productIds');

      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds);

      log('Product query response:');
      log('- Found products: ${response.productDetails.length}');
      log('- Not found IDs: ${response.notFoundIDs}');
      log('- Error: ${response.error}');

      if (response.notFoundIDs.isNotEmpty) {
        log('Products not found: ${response.notFoundIDs}');
        log('This is normal during development or if app is under review');
        log('Troubleshooting steps:');
        log('1. Check App Store Connect - ensure products are "Ready to Submit" or "Approved"');
        log('2. Verify bundle ID matches between app and App Store Connect');
        log('3. Complete tax and banking information in App Store Connect');
        log('4. Test on real device with sandbox Apple ID');
        log('5. Wait for app review to complete if app is under review');
      }

      if (response.productDetails.isEmpty) {
        log('No products loaded. This usually means:');
        log('1. App is still under review');
        log('2. Products are not configured in App Store Connect/Google Play Console');
        log('3. Testing on simulator (use real device for testing)');
        log('4. Incomplete tax/banking information in developer account');
        log('5. Bundle ID mismatch between app and App Store Connect');
      }

      setState(() {
        _products = response.productDetails;
      });
    } catch (e) {
      log('Error loading products: $e');
      log('This could indicate a network issue or App Store Connect configuration problem');
    }
  }

  Future<void> initializePayment() async {
    if (!_isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('In-app purchases are not available on this device')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final String productId =
          isYearlySelected ? yearlyProductId : monthlyProductId;

      if (_products.isEmpty) {
        throw 'No products available. Please wait for app review to complete or check your product configuration.';
      }

      final ProductDetails product = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () =>
            throw 'Product not found: $productId. This usually means the app is still under review.',
      );

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);

      // Both yearly and monthly subscriptions should use buyNonConsumable
      // as they are auto-renewable subscriptions
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      log('Error during purchase: $e');
      String errorMessage = e.toString();
      if (errorMessage.contains('Product not found')) {
        errorMessage =
            'Products are not available yet. This is normal while your app is under review.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getProductPrice(String productId) {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      return product.currencySymbol + product.rawPrice.toString();
    } catch (e) {
      // Fallback prices if products are not loaded
      return productId == yearlyProductId ? '\$22' : '\$2';
    }
  }

  String _getProductTitle(String productId) {
    return productId == yearlyProductId
        ? 'Yearly Subscription'
        : 'Monthly Subscription';
  }

  String _getProductDescription(String productId) {
    return productId == yearlyProductId
        ? 'Auto-renewable subscription. Billed annually. Cancel anytime.'
        : 'Auto-renewable subscription. Billed monthly. Cancel anytime.';
  }

  String _getPricePerUnit(String productId) {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      if (productId == yearlyProductId) {
        // Calculate monthly price for yearly subscription
        final monthlyPrice = product.rawPrice / 12;
        return '${product.currencySymbol}${monthlyPrice.toStringAsFixed(2)}/month';
      } else {
        return '${product.currencySymbol}${product.rawPrice}/month';
      }
    } catch (e) {
      // Fallback prices if products are not loaded
      return productId == yearlyProductId ? '\$1.67/month' : '\$2.00/month';
    }
  }

  void _listenToPurchaseUpdated() {
    _subscription = _inAppPurchase.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        log('Error in purchase stream: $error');
      },
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Show loading UI
        log('Purchase pending');
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        // Verify purchase
        await _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // Handle error
        log('Purchase error: ${purchaseDetails.error}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Purchase failed: ${purchaseDetails.error?.message ?? "Unknown error"}')),
        );
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        // Handle cancellation
        log('Purchase canceled');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchase was canceled')),
        );
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    try {
      log('Starting purchase verification for: ${purchaseDetails.productID}');

      String? verificationData;
      String platform = Platform.isIOS ? 'ios' : 'android';

      if (Platform.isIOS) {
        // iOS: Get receipt data
        if (purchaseDetails
            .verificationData.serverVerificationData.isNotEmpty) {
          verificationData =
              purchaseDetails.verificationData.serverVerificationData;
        } else if (purchaseDetails
            .verificationData.localVerificationData.isNotEmpty) {
          verificationData =
              purchaseDetails.verificationData.localVerificationData;
        }

        if (verificationData == null || verificationData.isEmpty) {
          throw Exception('No receipt data available for verification');
        }
      } else {
        // Android: Get purchase token
        verificationData = purchaseDetails.purchaseID;
        if (verificationData == null || verificationData.isEmpty) {
          throw Exception('No purchase token available for verification');
        }
      }

      // Send verification data to backend
      final verificationSuccess = await _verifyPurchaseWithBackend(
        verificationData: verificationData,
        productId: purchaseDetails.productID,
        platform: platform,
        transactionId: purchaseDetails.purchaseID ?? '',
      );

      if (verificationSuccess) {
        log('Purchase verification successful: ${purchaseDetails.productID}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Purchase successful! Welcome to Premium!')),
        );

        // Close the premium overlay
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        throw Exception('Purchase verification failed');
      }
    } catch (e) {
      log('Purchase verification error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase verification failed: $e')),
      );
    }
  }

  Future<bool> _verifyPurchaseWithBackend({
    required String verificationData,
    required String productId,
    required String platform,
    required String transactionId,
  }) async {
    try {
      log('Starting ${platform} purchase verification for product: $productId');

      Response response;

      if (platform == 'ios') {
        // Use the new Apple receipt verification endpoint for iOS
        log('Using Apple receipt verification endpoint for iOS');
        response = await _apiClient.verifyAppleReceipt(
          appleReceiptData: verificationData,
        );
      } else {
        // Use the existing subscription verification for Android
        log('Using subscription verification endpoint for Android');
        final Map<String, dynamic> requestData = {
          'platform': platform,
          'product_id': productId,
          'transaction_id': transactionId,
          'purchase_token': verificationData,
          'package_name': 'com.foxxhealth',
        };

        response = await _apiClient.post(
          '/api/v1/subscriptions/verify-purchase',
          data: requestData,
        );
      }

      log('Backend verification response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        log('Verification successful: $responseData');
        return true;
      } else {
        log('Verification failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Backend verification error: $e');

      // If it's a network error or server error, we should still allow the purchase
      // to complete to avoid blocking legitimate purchases due to temporary server issues
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException') ||
          e.toString().contains('500') ||
          e.toString().contains('502') ||
          e.toString().contains('503')) {
        log('Server error detected, allowing purchase to complete');
        return true;
      }

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Foxxbackground(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppColors.amethystViolet),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 50),
                    ],
                  ),
                ),
                _buildPremiumBenefits(),
                Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMonthlySelected = true;
                          });
                        },
                        child: _buildSubscriptionOption(
                          title: _getProductTitle(yearlyProductId),
                          price: _getProductPrice(yearlyProductId),
                          pricePerUnit: _getPricePerUnit(yearlyProductId),
                          description: _getProductDescription(yearlyProductId),
                          isSelected: !isMonthlySelected,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMonthlySelected = false;
                          });
                        },
                        child: _buildSubscriptionOption(
                          title: _getProductTitle(monthlyProductId),
                          price: _getProductPrice(monthlyProductId),
                          pricePerUnit: _getPricePerUnit(monthlyProductId),
                          description: _getProductDescription(monthlyProductId),
                          isSelected: isMonthlySelected,
                        ),
                      ),

                      const SizedBox(height: 48),
                      // _buildTestimonial(),
                      const SizedBox(height: 16),
                      _buildTermsOfService(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                _buildTrialButton(),
                // if (_products.isEmpty) _buildRefreshButton(),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: Text(
                      'Once your free trial ends, your subscription renews automatically at \$2/month',
                      style: TextStyle(color: AppColors.gray700, fontSize: 16)),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildPremiumBenefits() {
    return Container(
      color: AppColors.lightViolet,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Premium Benefits',
                style: AppTextStyles.heading2
                    .copyWith(color: AppColors.amethystViolet)),
            const Text('Start your FREE 14-day trial today',
                style: AppTextStyles.bodyOpenSans),
            const SizedBox(height: 3),
            _buildBenefitItem('Track your symptoms'),
            _buildBenefitItem('Uncover powerful insights'),
            _buildBenefitItem('Prep like a pro for every appointment'),
            _buildBenefitItem('Connect with a community that truely gets it'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, right: 10, left: 10),
      child: Row(
        children: [
          Text('• ', style: AppTextStyles.bodyOpenSans),
          Expanded(
            child: Text(text,
                style: AppTextStyles.bodyOpenSans
                    .copyWith(fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption({
    required String title,
    required String price,
    required String pricePerUnit,
    required String description,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(
            width: isSelected ? 3 : 1,
            color: isSelected ? AppColors.amethystViolet : Colors.transparent),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading3.copyWith(
                      color:
                          isSelected ? AppColors.amethystViolet : Colors.black),
                ),
                const SizedBox(height: 4),
                Text(description,
                    style: AppTextStyles.captionOpenSans.copyWith()),
                const SizedBox(height: 2),
                Text(
                  pricePerUnit,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.amethystViolet,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price,
                  style: AppTextStyles.bodyOpenSans.copyWith(
                      fontSize: 22,
                      color:
                          isSelected ? AppColors.amethystViolet : Colors.black,
                      fontWeight: FontWeight.w600)),
              Text(
                'Cancel Anytime',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonial() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Text(
        "Every woman deserves a tool like the FoXx Health app",
        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w400),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTermsOfService() {
    return Center(
      child: Column(
        children: [
          Text(
            'By subscribing, you agree to our ',
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 4,
            runSpacing: 2,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TermsOfUseScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Terms of Use',
                  style: TextStyle(
                    color: AppColors.amethystViolet,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.amethystViolet,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrialButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : initializePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amethystViolet,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Start FREE Trial',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.orange.shade700,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  'Products not available',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'This is normal during development or if your app is under review. Tap refresh to try again.',
                  style: TextStyle(
                    color: Colors.orange.shade600,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () async {
                log('User tapped refresh button');
                await _loadProductsWithRetry();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_products.isEmpty
                          ? 'Products still not available. Check App Store Connect configuration.'
                          : 'Products loaded successfully!'),
                      backgroundColor:
                          _products.isEmpty ? Colors.orange : Colors.green,
                    ),
                  );
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Products'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.amethystViolet,
                side: BorderSide(color: AppColors.amethystViolet),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
