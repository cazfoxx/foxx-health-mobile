# Subscription Verification Implementation Guide

## App Store Rejection Issue
Your app was rejected because the in-app purchase verification failed during Apple's review process. The issue is that your server needs to handle both production and sandbox receipts properly.

## Required Backend Implementation

### 1. Create the Verification Endpoint
Create a new endpoint: `POST /api/v1/subscriptions/verify-purchase`

### 2. Request Format
The mobile app will send the following data:

```json
{
  "platform": "ios", // or "android"
  "product_id": "com.foxxhealth.foxxapp.premium_yearly", // or "com.foxxhealth.foxxapp.premium_monthly"
  "transaction_id": "1000000123456789",
  "receipt_data": "base64_encoded_receipt_data" // for iOS
}
```

For Android:
```json
{
  "platform": "android",
  "product_id": "com.foxxhealth.foxxapp.premium_yearly",
  "transaction_id": "GPA.1234-5678-9012-34567",
  "purchase_token": "purchase_token_here",
  "package_name": "com.foxxhealth"
}
```

### 3. iOS Receipt Validation Logic (CRITICAL)

Your server MUST implement this exact flow to fix the App Store rejection:

```python
import requests
import base64
import json

def verify_ios_receipt(receipt_data, product_id):
    """
    Verify iOS receipt with proper production/sandbox handling
    This is the EXACT logic Apple requires to fix the rejection
    """
    
    # Step 1: Always try production first
    production_url = "https://buy.itunes.apple.com/verifyReceipt"
    sandbox_url = "https://sandbox.itunes.apple.com/verifyReceipt"
    
    payload = {
        "receipt-data": receipt_data,
        "password": "YOUR_SHARED_SECRET",  # Get this from App Store Connect
        "exclude-old-transactions": True
    }
    
    # Try production first
    try:
        response = requests.post(production_url, json=payload, timeout=30)
        result = response.json()
        
        # Check if we got a sandbox receipt error
        if result.get("status") == 21007:
            # This is a sandbox receipt being used in production
            # Retry with sandbox URL
            print("Sandbox receipt detected, retrying with sandbox URL")
            response = requests.post(sandbox_url, json=payload, timeout=30)
            result = response.json()
        
        # Check if verification was successful
        if result.get("status") == 0:
            # Verification successful
            receipt_info = result.get("receipt", {})
            in_app_purchases = receipt_info.get("in_app", [])
            
            # Find the specific product
            for purchase in in_app_purchases:
                if purchase.get("product_id") == product_id:
                    return {
                        "success": True,
                        "transaction_id": purchase.get("transaction_id"),
                        "purchase_date": purchase.get("purchase_date"),
                        "expires_date": purchase.get("expires_date_ms"),
                        "environment": "production" if "buy.itunes.apple.com" in production_url else "sandbox"
                    }
            
            return {"success": False, "error": "Product not found in receipt"}
        else:
            return {"success": False, "error": f"Apple verification failed: {result.get('status')}"}
            
    except Exception as e:
        return {"success": False, "error": f"Verification error: {str(e)}"}

def verify_android_purchase(purchase_token, product_id, package_name):
    """
    Verify Android purchase using Google Play Developer API
    """
    # You'll need to implement Google Play verification
    # This requires service account credentials
    pass
```

### 4. Complete Backend Endpoint Implementation

```python
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

class PurchaseVerificationRequest(BaseModel):
    platform: str
    product_id: str
    transaction_id: str
    receipt_data: str = None  # iOS only
    purchase_token: str = None  # Android only
    package_name: str = None  # Android only

@router.post("/api/v1/subscriptions/verify-purchase")
async def verify_purchase(request: PurchaseVerificationRequest):
    try:
        if request.platform == "ios":
            if not request.receipt_data:
                raise HTTPException(status_code=400, detail="receipt_data required for iOS")
            
            result = verify_ios_receipt(request.receipt_data, request.product_id)
            
        elif request.platform == "android":
            if not request.purchase_token or not request.package_name:
                raise HTTPException(status_code=400, detail="purchase_token and package_name required for Android")
            
            result = verify_android_purchase(
                request.purchase_token, 
                request.product_id, 
                request.package_name
            )
        else:
            raise HTTPException(status_code=400, detail="Invalid platform")
        
        if result["success"]:
            # Store the subscription in your database
            # Update user's premium status
            # Return success response
            return {
                "success": True,
                "message": "Purchase verified successfully",
                "subscription": {
                    "product_id": request.product_id,
                    "transaction_id": result.get("transaction_id"),
                    "expires_date": result.get("expires_date"),
                    "environment": result.get("environment")
                }
            }
        else:
            return {
                "success": False,
                "error": result["error"]
            }
            
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Verification failed: {str(e)}")
```

### 5. Important Notes for App Store Review

1. **Shared Secret**: You need to get your shared secret from App Store Connect:
   - Go to App Store Connect → Your App → Features → In-App Purchases
   - Click "Manage" next to your subscription group
   - Copy the "Shared Secret"

2. **Product IDs**: Make sure these match exactly:
   - `com.foxxhealth.foxxapp.premium_yearly`
   - `com.foxxhealth.foxxapp.premium_monthly`

3. **Bundle ID**: Ensure your iOS bundle ID matches what's in App Store Connect

4. **Testing**: Test with both sandbox and production receipts before submitting

### 6. Testing Checklist

- [ ] Test with sandbox receipts (status 21007)
- [ ] Test with production receipts
- [ ] Test with invalid receipts
- [ ] Test network timeouts
- [ ] Verify product IDs match App Store Connect
- [ ] Ensure shared secret is correct

### 7. Deployment Steps

1. Implement the backend endpoint
2. Test thoroughly with both sandbox and production
3. Deploy to production
4. Test the mobile app with the new endpoint
5. Submit to App Store for review

## Why This Fixes the Rejection

The App Store rejection happened because:
1. Your app was using simulated verification (always returning true)
2. When Apple's reviewers tested the purchase, the verification failed
3. Apple requires proper receipt validation that handles both production and sandbox environments

This implementation ensures:
- Production receipts are validated against production App Store
- Sandbox receipts are automatically retried against sandbox App Store
- Proper error handling for network issues
- Correct product validation

After implementing this, your app should pass App Store review.
