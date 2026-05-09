# Buy-me-a-coffee tip — IAP setup

The Settings screen ships a "Tip $9.99" button wired through
`package:in_app_purchase`. The Flutter side is fully wired; finishing
the loop requires a one-time platform configuration.

Product ID: `com.ahmedomar.liqkit.tip999`

## iOS — App Store Connect (production)

1. Open **App Store Connect → Apps → (this app) → Features → In-App
   Purchases**.
2. Create a **Consumable** with:
   - Reference name: `Tip 9.99`
   - Product ID: `com.ahmedomar.liqkit.tip999`
   - Price tier: `9.99 USD` (and equivalents for other regions).
3. Submit for review along with the app build that ships this code.

Until the IAP product is approved, the app falls back to a graceful
"In-app purchases are not available" message.

## iOS — local development (StoreKit configuration file)

To exercise the OS purchase sheet without going through App Store
Connect:

1. In Xcode open `ios/Runner.xcworkspace`.
2. **File → New → File… → StoreKit Configuration File**, name it
   `Configuration`. Save next to the Runner target.
3. In the file, **add a Consumable Product**:
   - Reference name: `Tip 9.99`
   - Product ID: `com.ahmedomar.liqkit.tip999`
   - Price: `9.99`
4. **Edit Scheme… → Run → Options → StoreKit Configuration** → pick
   the `Configuration.storekit` file you just created.
5. Run the app from Xcode (or `flutter run --release` after one Xcode
   launch). The Tip button now exercises a sandbox purchase sheet.

## Android — Google Play Console (optional)

`in_app_purchase` is cross-platform. To enable on Android:

1. Open **Google Play Console → (this app) → Monetize → In-app
   products**.
2. Create a **Managed product** with the same product ID
   `com.ahmedomar.liqkit.tip999` and a $9.99 price.
3. Activate the product. Sandbox testing requires uploading a signed
   AAB to internal testing first.

## What lives in the codebase

- `lib/core/providers/tip_iap_provider.dart` — the controller. Owns
  the `purchaseStream` subscription, drives `buyConsumable`, and
  exposes a `TipFlowState` for the UI.
- `lib/screens/settings_screen.dart` — the `_TipRow` widget reads
  `tipIapControllerProvider` and renders a `LiqCard` + `LiqButton`.

No other files touch the StoreKit/Play APIs.
