# flutter_mangopay_client

A simple flutter client for Mangopay Payment gateway.

#### Currently supported operations:
 - Fetch all registered cards
 - Fetch all registered users
 - Register a card
 - Register a User [Natural]
 - Create a wallet for registered user
 - Perform DirectPayin transaction using card
 - Deactivate a card


## Getting Started

#### Steps to follow for integration of this plugin:

 - create a new directory named "dependencies" (without quotes) in your flutter project's root directory
 - copy the directory & contents of this plugin to the dependencies directory
 - add following in the pubspec.yaml file of your project under `dependencies`:
   ```yaml
  flutter_mangopay_client:
    path: ../
   ```
 - Note that yaml file depends on indentation/spaces of the content to work properly
 - Run `flutter packages get` or `flutter pub get`

That is it, you should now be able to use the `MangopayClient` without any issues.

## Help & Support
