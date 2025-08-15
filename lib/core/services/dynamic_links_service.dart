import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicLinksService {
  static final DynamicLinksService _instance = DynamicLinksService._internal();
  factory DynamicLinksService() => _instance;
  DynamicLinksService._internal();

  StreamSubscription? _subscription;
  final StreamController<Map<String, dynamic>> _linkStreamController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final AppLinks _appLinks = AppLinks();

  Stream<Map<String, dynamic>> get linkStream => _linkStreamController.stream;

  /// Initialize the service
  Future<void> initialize() async {
    try {
      // Handle incoming links when app is already running
      _subscription = _appLinks.uriLinkStream.listen((Uri uri) {
        _handleIncomingLink(uri);
      }, onError: (err) {
        log('Deep link error: $err');
      });

      // Handle initial link if app was opened from a link
      try {
        final initialUri = await _appLinks.getInitialAppLink();
        if (initialUri != null) {
          _handleIncomingLink(initialUri);
        }
      } catch (e) {
        log('Error getting initial URI: $e');
      }

      log('Dynamic Links Service initialized successfully');
    } catch (e) {
      log('Dynamic Links Service initialization failed: $e');
    }
  }

  /// Handle incoming deep link
  void _handleIncomingLink(Uri uri) {
    try {
      log('Incoming deep link: $uri');
      
      // Parse the URI and extract data
      final Map<String, dynamic> linkData = {
        'uri': uri.toString(),
        'host': uri.host,
        'path': uri.path,
        'queryParameters': uri.queryParameters,
      };

      // Add specific handling for foxxhealth.app
      if (uri.host == 'foxxhealth.app') {
        linkData['type'] = 'app_deep_link';
        
        // Handle different paths
        switch (uri.path) {
          case '/payment-success':
            linkData['type'] = 'payment_success';
            break;
          case '/premium':
            linkData['type'] = 'premium_feature';
            break;
          case '/referral':
            linkData['type'] = 'referral';
            break;
          default:
            linkData['type'] = 'general';
        }
      }

      _linkStreamController.add(linkData);
    } catch (e) {
      log('Error handling incoming link: $e');
    }
  }

  /// Create a custom dynamic link using your own domain
  Future<String?> createDynamicLink({
    required String linkTitle,
    required String linkDescription,
    required String linkImageUrl,
    required Map<String, dynamic> linkData,
    String? channel,
    String? feature,
    String? campaign,
    String? tags,
  }) async {
    try {
      // Create a custom URL with your domain
      const baseUrl = 'https://foxxhealth.app';
      final queryParams = {
        'title': Uri.encodeComponent(linkTitle),
        'description': Uri.encodeComponent(linkDescription),
        'image': Uri.encodeComponent(linkImageUrl),
        'data': Uri.encodeComponent(linkData.toString()),
        'channel': channel ?? 'app',
        'feature': feature ?? 'sharing',
        'campaign': campaign ?? 'general',
        'tags': tags ?? '',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final dynamicLink = uri.toString();
      
      log('Dynamic link created: $dynamicLink');
      return dynamicLink;
    } catch (e) {
      log('Error creating dynamic link: $e');
      return null;
    }
  }

  /// Create a payment success link
  Future<String?> createPaymentSuccessLink({
    required String sessionId,
    required String amount,
    required String currency,
  }) async {
    return await createDynamicLink(
      linkTitle: 'Payment Successful!',
      linkDescription: 'Your payment of $amount $currency was successful.',
      linkImageUrl: 'https://foxxhealth.app/success-icon.png',
      linkData: {
        'type': 'payment_success',
        'session_id': sessionId,
        'amount': amount,
        'currency': currency,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      channel: 'payment',
      feature: 'payment_success',
      campaign: 'premium_upgrade',
    );
  }

  /// Create a premium feature link
  Future<String?> createPremiumFeatureLink({
    required String featureName,
    required String featureDescription,
  }) async {
    return await createDynamicLink(
      linkTitle: 'Unlock $featureName',
      linkDescription: featureDescription,
      linkImageUrl: 'https://foxxhealth.app/premium-icon.png',
      linkData: {
        'type': 'premium_feature',
        'feature_name': featureName,
        'feature_description': featureDescription,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      channel: 'app',
      feature: 'premium_feature',
      campaign: 'feature_promotion',
    );
  }

  /// Create a referral link
  Future<String?> createReferralLink({
    required String referrerId,
    required String referrerName,
  }) async {
    return await createDynamicLink(
      linkTitle: 'Join FoXX Health',
      linkDescription: '$referrerName invited you to join FoXX Health!',
      linkImageUrl: 'https://foxxhealth.app/referral-icon.png',
      linkData: {
        'type': 'referral',
        'referrer_id': referrerId,
        'referrer_name': referrerName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      channel: 'referral',
      feature: 'referral',
      campaign: 'user_referral',
    );
  }

  /// Handle incoming link data
  void handleIncomingLink(Map<String, dynamic> linkData) {
    try {
      _linkStreamController.add(linkData);
      log('Incoming link handled: $linkData');
    } catch (e) {
      log('Error handling incoming link: $e');
    }
  }

  /// Handle deep link navigation
  void handleDeepLinkNavigation(BuildContext context, Map<String, dynamic> linkData) {
    try {
      final String? linkType = linkData['type'] as String?;
      
      switch (linkType) {
        case 'payment_success':
          _handlePaymentSuccess(context, linkData);
          break;
        case 'premium_feature':
          _handlePremiumFeature(context, linkData);
          break;
        case 'referral':
          _handleReferral(context, linkData);
          break;
        default:
          log('Unknown deep link type: $linkType');
      }
    } catch (e) {
      log('Error handling deep link navigation: $e');
    }
  }

  void _handlePaymentSuccess(BuildContext context, Map<String, dynamic> linkData) {
    // Navigate to payment success screen
    log('Handling payment success: $linkData');
    // Add your navigation logic here
    // Navigator.pushNamed(context, '/payment-success', arguments: linkData);
  }

  void _handlePremiumFeature(BuildContext context, Map<String, dynamic> linkData) {
    // Navigate to premium feature screen
    log('Handling premium feature: $linkData');
    // Add your navigation logic here
    // Navigator.pushNamed(context, '/premium-feature', arguments: linkData);
  }

  void _handleReferral(BuildContext context, Map<String, dynamic> linkData) {
    // Navigate to referral screen
    log('Handling referral: $linkData');
    // Add your navigation logic here
    // Navigator.pushNamed(context, '/referral', arguments: linkData);
  }

  /// Share a dynamic link
  Future<void> shareDynamicLink(String link, {String? subject, String? text}) async {
    try {
      final uri = Uri.parse('mailto:?subject=${Uri.encodeComponent(subject ?? 'Check out this link')}&body=${Uri.encodeComponent('${text ?? 'Check out this link'}\n\n$link')}');
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        log('Could not launch email app');
      }
    } catch (e) {
      log('Error sharing dynamic link: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _linkStreamController.close();
  }
}
