# Environment Configuration Guide

## Overview

Your app now uses a flexible environment configuration system that allows you to easily switch between development (local testing) and production (app stores) environments.

## Quick Start

### When Testing Locally (with local backend)

In `lib/main.dart`, use:
```dart
Environment.init(EnvironmentType.development);
```

This will connect to: **`http://localhost:5001`**

### When Building for App Stores (production)

In `lib/main.dart`, change to:
```dart
Environment.init(EnvironmentType.production);
```

This will connect to: **`https://awt.eu.pythonanywhere.com`**

## Files Changed

### 1. Created: `lib/core/config/environment.dart`
This is the central configuration file that manages all environment-specific settings.

**What it does:**
- Defines three environments: development, staging, production
- Provides the correct API URL based on current environment
- Manages timeout, retry settings, and other configuration
- Provides helper methods to check which environment you're in

### 2. Updated: `lib/data/services/booking_api_service.dart`
**Changes:**
- Removed hardcoded `http://localhost:5001`
- Now uses `Environment.ordersEndpoint` and `Environment.priceEndpoint`
- Automatically uses the correct URL based on environment

### 3. Updated: `lib/core/constants/app_constants.dart`
**Changes:**
- Removed duplicate/unused localhost URL
- Added comment pointing to the new environment configuration

### 4. Updated: `lib/main.dart`
**Changes:**
- Added `Environment.init()` call at startup
- Added `Environment.printConfig()` for debugging (only shows in development)

## Environment Details

### Development Environment
```dart
Environment.init(EnvironmentType.development);
```
- **API URL**: `http://localhost:5001`
- **Use when**: Testing on your development machine with local backend
- **Debug logging**: Enabled
- **Security**: HTTP (local only, not secure)

### Staging Environment (Optional)
```dart
Environment.init(EnvironmentType.staging);
```
- **API URL**: `https://awt.eu.pythonanywhere.com` (currently same as production)
- **Use when**: Testing with a staging server (if you create one)
- **Debug logging**: Enabled
- **Security**: HTTPS (secure)

### Production Environment
```dart
Environment.init(EnvironmentType.production);
```
- **API URL**: `https://awt.eu.pythonanywhere.com`
- **Use when**: Building for App Store/Play Store
- **Debug logging**: Disabled
- **Security**: HTTPS (secure)

## How to Switch Environments

### Step 1: Open `lib/main.dart`

Find this line (around line 17):
```dart
Environment.init(EnvironmentType.development);
```

### Step 2: Change Based on Your Need

**For local development:**
```dart
Environment.init(EnvironmentType.development);
```

**For production builds:**
```dart
Environment.init(EnvironmentType.production);
```

### Step 3: Save and Rebuild

After changing the environment:
```bash
# Stop your app if running
# Then run again:
flutter run

# Or for release build:
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Workflow Examples

### Example 1: Daily Development
```
1. Make sure main.dart has: Environment.init(EnvironmentType.development)
2. Start your local backend: python app.py (or your backend command)
3. Run Flutter app: flutter run
4. Your app will connect to http://localhost:5001
5. Test your changes
```

### Example 2: Building for App Store
```
1. Change main.dart to: Environment.init(EnvironmentType.production)
2. Test that production backend is working
3. Build release version:
   - Android: flutter build appbundle --release
   - iOS: flutter build ios --release
4. Your app will connect to https://awt.eu.pythonanywhere.com
5. Upload to stores
```

### Example 3: Testing on Real Device with Production Backend
```
1. Change main.dart to: Environment.init(EnvironmentType.production)
2. Connect your phone
3. Run: flutter run --release
4. App connects to production server
5. Test on real device before store submission
```

## Debugging

### Check Current Environment

The app prints the configuration on startup (in development/staging only):

```
=================================
Environment: Development
API Base URL: http://localhost:5001
Debug Logging: true
=================================
```

### Check in Code

You can check the environment anywhere in your code:

```dart
if (Environment.isDevelopment) {
  print('Running in development mode');
}

if (Environment.isProduction) {
  // Production-only code
}

print('Current API: ${Environment.apiBaseUrl}');
```

## Common Issues

### Issue: "Connection refused" or "Network error"

**Cause**: Your local backend is not running, or you're in development mode but trying to connect to a device.

**Solution**:
- Make sure your local backend is running: `python app.py`
- OR switch to production mode to use the real server

### Issue: App works locally but not on real device

**Cause**: localhost only works on the same machine. Your phone can't access "localhost" of your computer.

**Solution**:
- Use production mode: `Environment.init(EnvironmentType.production)`
- OR use your computer's IP address in development (advanced)

### Issue: Forgot to change to production before release

**Cause**: App is set to development mode and trying to connect to localhost.

**Solution**:
- Change `main.dart` to `EnvironmentType.production`
- Rebuild your app completely
- Test before submitting to stores

## Best Practices

1. **Never commit production secrets** (if you add API keys later, use environment variables)
2. **Always use production mode** for store builds
3. **Test with production environment** on real device before submission
4. **Keep debug logging disabled** in production (already configured)
5. **Use HTTPS in production** (already configured)

## Future Enhancements

You can easily add more configuration options:

```dart
// In environment.dart, add:
static String get apiKey {
  switch (_currentEnvironment) {
    case EnvironmentType.development:
      return 'dev-api-key';
    case EnvironmentType.production:
      return 'prod-api-key';
  }
}

// Then use anywhere:
headers: {
  'Authorization': 'Bearer ${Environment.apiKey}',
}
```

## Questions?

- Current environment: Check console output when app starts
- API URL: Check `Environment.apiBaseUrl` in your code
- Need help: See the inline comments in `lib/core/config/environment.dart`
