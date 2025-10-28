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
import 'package:foxxhealth/core/services/premium_service.dart';
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

  // Product IDs - iOS App Store product IDs
  static const String yearlyProductId = 'com.foxxhealth.foxxapp.premium_yearly';
  static const String monthlyProductId = 'com.foxxhealth.foxxapp.premium_monthly';

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
    log('=== INITIALIZING IN-APP PURCHASE STORE ===');
    
    final bool available = await _inAppPurchase.isAvailable();
    log('In-App Purchase Available: $available');
    
    if (!available) {
      log('In-App Purchases are not available on this device');
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
    
    // Restore previous purchases to check for existing subscriptions
    await _restorePurchases();
    
    log('=== STORE INITIALIZATION COMPLETE ===');
  }

  Future<void> _refreshProducts() async {
    log('Manually refreshing products...');
    setState(() {
      _isLoading = true;
    });
    
    await _loadProductsWithRetry();
    
    setState(() {
      _isLoading = false;
    });
    
    if (_products.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Products refreshed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load products. Using fallback prices.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _loadProductsWithRetry({int maxRetries = 5}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      log('Loading products - attempt $attempt of $maxRetries');
      await _loadProducts();

      if (_products.isNotEmpty) {
        log('Products loaded successfully on attempt $attempt');
        log('Loaded products: ${_products.map((p) => '${p.id}: ${p.currencySymbol}${p.rawPrice}').join(', ')}');
        return;
      }

      if (attempt < maxRetries) {
        final delay = Duration(seconds: attempt * 2); // Exponential backoff
        log('No products found, retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
      }
    }

    log('Failed to load products after $maxRetries attempts');
    log('This means the app will use fallback prices until products are available');
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

      // Log detailed information about each product found
      for (final product in response.productDetails) {
        log('=== PRODUCT DETAILS FROM APP STORE CONNECT ===');
        log('Product ID: ${product.id}');
        log('Product Title: ${product.title}');
        log('Product Description: ${product.description}');
        log('Raw Price (exact): ${product.rawPrice}');
        log('Currency Code: ${product.currencyCode}');
        log('Currency Symbol: ${product.currencySymbol}');
        log('Formatted Price: ${product.currencySymbol}${product.rawPrice.toStringAsFixed(2)}');
        log('=== END PRODUCT DETAILS ===');
      }

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
        log('6. Network connectivity issues');
        log('7. App Store servers are temporarily unavailable');
        log('8. Products are not in "Ready to Submit" or "Approved" status');
        log('9. Missing App Store Connect agreement acceptance');
        log('10. Testing with wrong Apple ID (need sandbox account)');
      }

      setState(() {
        _products = response.productDetails;
      });
    } catch (e) {
      log('Error loading products: $e');
      log('This could indicate a network issue or App Store Connect configuration problem');
      log('Error type: ${e.runtimeType}');
      if (e.toString().contains('timeout')) {
        log('This appears to be a timeout error - try again later');
      } else if (e.toString().contains('network')) {
        log('This appears to be a network error - check internet connection');
      }
    }
  }

  Future<void> _restorePurchases() async {
    try {
      log('Restoring previous purchases...');
      setState(() {
        _isLoading = true;
      });
      
      await _inAppPurchase.restorePurchases();
      log('Purchase restoration completed');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Purchases restored successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      log('Error restoring purchases: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to restore purchases: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _checkExistingSubscription(String productId) async {
    try {
      log('Checking for existing subscription: $productId');
      
      // For now, we'll rely on the purchase stream to detect existing purchases
      // The restorePurchases() call in _initializeStore() will trigger any existing purchases
      // to be sent through the purchase stream, which we handle in _handlePurchaseUpdates
      
      // This is a simplified approach - in a production app, you might want to store
      // purchase state locally or check with your backend
      log('Subscription check completed for: $productId');
      return false;
    } catch (e) {
      log('Error checking existing subscription: $e');
      return false;
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

      // Check if user already has an active subscription
      final bool hasActiveSubscription = await _checkExistingSubscription(productId);
      if (hasActiveSubscription) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You already have an active subscription!'),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }

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
      // Debug logging to help identify currency issues
      log('Product: $productId');
      log('Raw Price: ${product.rawPrice}');
      log('Currency Code: ${product.currencyCode}');
      log('Currency Symbol: ${product.currencySymbol}');
      log('Formatted Price: ${product.currencySymbol}${product.rawPrice.toStringAsFixed(2)}');
      
      return product.currencySymbol + product.rawPrice.toStringAsFixed(2);
    } catch (e) {
      // Fallback prices if products are not loaded - MUST match App Store Connect configuration
      log('Using fallback price for $productId');
      return productId == yearlyProductId ? '\$19.99' : '\$2.00';
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
        // For monthly subscription, don't show per-unit price to avoid duplication
        return '';
      }
    } catch (e) {
      // Fallback prices if products are not loaded - MUST match App Store Connect
      return productId == yearlyProductId ? '\$1.67/month' : ''; // $19.99/12 = $1.67
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
        
        // Set premium status to true
        await PremiumService.instance.enablePremium();
        log('🔓 Premium status enabled in SharedPreferences');
        
        // Show success snackbar (the backend verification already shows one, but this is a fallback)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🎉 Purchase successful! Welcome to Premium!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }

        // Close the premium overlay
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        throw Exception('Purchase verification failed');
      }
    } catch (e) {
      log('Purchase verification error: $e');
      
      // Show detailed error snackbar
      if (mounted) {
        String errorMessage = 'Purchase verification failed';
        if (e.toString().contains('No receipt data available')) {
          errorMessage = 'Receipt data not available - please try again';
        } else if (e.toString().contains('Purchase verification failed')) {
          errorMessage = 'Verification failed - please contact support';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
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
        
        // Set premium status to true
        await PremiumService.instance.enablePremium();
        log('🔓 Premium status enabled in SharedPreferences');
        
        // Show success snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Purchase verified successfully! Welcome to Premium!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
        return true;
      } else {
        log('Verification failed with status: ${response.statusCode}');
        
        // Show error snackbar for non-200 status
        if (mounted) {
          String errorMessage = 'Server error';
          if (response.statusCode == 401) {
            errorMessage = 'Authentication failed - please log in again';
          } else if (response.statusCode == 400) {
            errorMessage = 'Invalid receipt data - please try again';
          } else if (response.statusCode == 500) {
            errorMessage = 'Server error - please try again later';
          } else if (response.statusCode == 422) {
            errorMessage = 'Invalid receipt format - please try again';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ $errorMessage (${response.statusCode})'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 4),
            ),
          );
        }
        return false;
      }
    } catch (e) {
      log('Backend verification error: $e');

      // Show error snackbar for exceptions
      if (mounted) {
        String errorMessage = 'Network error';
        if (e.toString().contains('401')) {
          errorMessage = 'Authentication failed - please log in again';
        } else if (e.toString().contains('timeout') || e.toString().contains('TimeoutException')) {
          errorMessage = 'Request timeout - please check your connection';
        } else if (e.toString().contains('SocketException') || e.toString().contains('connection')) {
          errorMessage = 'No internet connection';
        } else if (e.toString().contains('500') || e.toString().contains('502') || e.toString().contains('503')) {
          errorMessage = 'Server error - please try again later';
        } else if (e.toString().contains('422')) {
          errorMessage = 'Invalid receipt format - please try again';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ $errorMessage'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }

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
                            isYearlySelected = true;
                            isMonthlySelected = false;
                          });
                        },
                        child: _buildSubscriptionOption(
                          title: _getProductTitle(yearlyProductId),
                          price: _getProductPrice(yearlyProductId),
                          pricePerUnit: _getPricePerUnit(yearlyProductId),
                          description: _getProductDescription(yearlyProductId),
                          isSelected: isYearlySelected,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMonthlySelected = true;
                            isYearlySelected = false;
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
                _buildRestoreButton(),
                if (_products.isEmpty) _buildRefreshButton(),
                _buildPriceSourceIndicator(),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: Text(
                      'Once your free trial ends, your subscription renews automatically at the selected plan price',
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
            Text('Take control of your health with FoXX',
                style: AppTextStyles.heading2
                    .copyWith(color: AppColors.amethystViolet)),
            const SizedBox(height: 3),
            _buildBenefitItem('Start your FREE 14-day trial today'),
            _buildBenefitItem('Track your symptoms'),
            _buildBenefitItem('Uncover powerful insights'),
            _buildBenefitItem('Prep like a pro for every appointment'),
            _buildBenefitItem('Connect with a community that truly gets it'),
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
                if (pricePerUnit.isNotEmpty) ...[
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

  Widget _buildRestoreButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: TextButton(
        onPressed: _isLoading ? null : _restorePurchases,
        child: const Text(
          'Restore Purchases',
          style: TextStyle(
            color: AppColors.amethystViolet,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _refreshProducts,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Refresh Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildPriceSourceIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _products.isNotEmpty ? Icons.check_circle : Icons.warning,
            color: _products.isNotEmpty ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            _products.isNotEmpty 
                ? 'Prices loaded from App Store Connect' 
                : 'Using fallback prices - tap Refresh Products',
            style: TextStyle(
              color: _products.isNotEmpty ? Colors.green : Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}
