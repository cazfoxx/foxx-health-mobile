#!/usr/bin/env python3
"""
Test script to verify your backend receipt validation is working correctly.
This simulates the exact scenario Apple's reviewers will encounter.
"""

import requests
import json
import base64

def test_receipt_validation():
    """
    Test your backend receipt validation endpoint
    """
    
    # Your backend URL
    backend_url = "https://fastapi-backend-v2-788993188947.us-central1.run.app"
    endpoint = f"{backend_url}/api/v1/payments/verify-apple-receipt"
    
    # Test data (you'll need to replace with actual receipt data)
    test_data = {
        "apple_receipt_data": "base64_encoded_receipt_data_here"
    }
    
    try:
        print("🧪 Testing receipt validation endpoint...")
        print(f"📍 Endpoint: {endpoint}")
        
        response = requests.post(
            endpoint,
            json=test_data,
            headers={
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            timeout=30
        )
        
        print(f"📊 Status Code: {response.status_code}")
        print(f"📄 Response: {json.dumps(response.json(), indent=2)}")
        
        if response.status_code == 200:
            result = response.json()
            if result.get("success"):
                print("✅ Receipt validation is working correctly!")
                print(f"🎯 Environment: {result.get('subscription', {}).get('environment', 'unknown')}")
            else:
                print("❌ Receipt validation failed")
                print(f"🚫 Error: {result.get('error', 'Unknown error')}")
        else:
            print(f"❌ HTTP Error: {response.status_code}")
            
    except Exception as e:
        print(f"❌ Test failed: {str(e)}")

def test_sandbox_scenario():
    """
    Test the specific sandbox scenario that Apple's reviewers will encounter
    """
    print("\n🔍 Testing sandbox receipt scenario...")
    print("This simulates what happens when Apple's reviewers test your app:")
    print("1. Production-signed app")
    print("2. Sandbox receipt")
    print("3. Your backend should handle this gracefully")
    
    # You can test this with a real sandbox receipt
    # or ask your backend developer to test this scenario

if __name__ == "__main__":
    print("🚀 Testing Receipt Validation")
    print("=" * 50)
    
    test_receipt_validation()
    test_sandbox_scenario()
    
    print("\n📋 Next Steps:")
    print("1. Verify your backend implements the production/sandbox logic")
    print("2. Test with a real sandbox receipt")
    print("3. Ensure Paid Apps Agreement is accepted")
    print("4. Resubmit to App Store")



