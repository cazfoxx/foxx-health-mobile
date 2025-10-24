# Testing Purchase Flow

## Pre-Testing Checklist

1. **Backend Implementation**
   - [ ] Backend endpoint `/api/v1/subscriptions/verify-purchase` is implemented
   - [ ] Server handles both production and sandbox receipts
   - [ ] Shared secret is configured in App Store Connect
   - [ ] Product IDs match between app and App Store Connect

2. **App Store Connect Setup**
   - [ ] Products are created: `com.foxxhealth.foxxapp.premium_yearly` and `com.foxxhealth.foxxapp.premium_monthly`
   - [ ] Products are approved and available
   - [ ] Shared secret is generated and configured
   - [ ] Bundle ID matches your app

3. **Development Environment**
   - [ ] Test on real device (not simulator)
   - [ ] Use sandbox Apple ID for testing
   - [ ] Ensure backend is deployed and accessible

## Testing Steps

### 1. Test Product Loading
1. Launch the app
2. Navigate to premium screen
3. Check logs for product loading messages
4. Verify products are displayed with correct prices

### 2. Test Purchase Flow
1. Select a subscription (yearly or monthly)
2. Tap purchase button
3. Complete the purchase in the system dialog
4. Check logs for verification process
5. Verify success message appears

### 3. Test Error Handling
1. Test with invalid network conditions
2. Test with server errors
3. Verify graceful error handling

## Log Messages to Look For

### Successful Flow:
```
Starting ios purchase verification for product: com.foxxhealth.foxxapp.premium_yearly
Sending verification request to backend...
Backend verification response: 200
Verification successful: {...}
Purchase verification successful: com.foxxhealth.foxxapp.premium_yearly
```

### Sandbox Receipt Handling:
```
Sandbox receipt detected, retrying with sandbox URL
```

### Error Handling:
```
Backend verification error: [error details]
Server error detected, allowing purchase to complete
```

## Common Issues and Solutions

### Issue: "Product not found"
**Solution**: 
- Check product IDs match App Store Connect
- Ensure products are approved
- Test on real device, not simulator

### Issue: "No receipt data available"
**Solution**:
- Check iOS receipt handling code
- Ensure proper receipt extraction

### Issue: "Backend verification failed"
**Solution**:
- Check backend endpoint is working
- Verify shared secret is correct
- Check server logs for detailed errors

### Issue: "Sandbox receipt used in production"
**Solution**:
- This should be handled automatically by the backend
- Backend should retry with sandbox URL when status 21007 is received

## Testing with App Store Review

When Apple reviews your app:
1. They will use a production-signed app
2. They will test with sandbox receipts
3. Your backend must handle this scenario (status 21007)
4. The purchase should complete successfully

## Final Verification

Before submitting to App Store:
1. [ ] Test complete purchase flow end-to-end
2. [ ] Verify backend handles sandbox receipts in production
3. [ ] Test error scenarios
4. [ ] Check all logs for proper flow
5. [ ] Ensure user gets success message after purchase

## Backend Testing

Test your backend endpoint directly:

```bash
curl -X POST https://your-backend.com/api/v1/subscriptions/verify-purchase \
  -H "Content-Type: application/json" \
  -d '{
    "platform": "ios",
    "product_id": "com.foxxhealth.foxxapp.premium_yearly",
    "transaction_id": "test_transaction",
    "receipt_data": "base64_receipt_data_here"
  }'
```

Expected response:
```json
{
  "success": true,
  "message": "Purchase verified successfully",
  "subscription": {
    "product_id": "com.foxxhealth.foxxapp.premium_yearly",
    "transaction_id": "actual_transaction_id",
    "expires_date": "timestamp",
    "environment": "sandbox"
  }
}
```
