# iOS Build Commands for MacinCloud
# Version 3.0.5+11

# 1. Transférer le projet sur MacinCloud
# Utilisez FileZilla ou scp pour transférer le dossier event_app

# 2. Une fois sur MacinCloud, ouvrez Terminal et naviguez vers le projet
cd ~/event_app

# 3. Nettoyer et préparer
flutter clean
flutter pub get

# 4. Ouvrir Xcode pour configurer les certificats
open ios/Runner.xcworkspace

# 5. Dans Xcode:
# - Sélectionnez "Runner" dans le navigateur
# - Allez à "Signing & Capabilities"
# - Sélectionnez votre Apple Developer Team
# - Vérifiez que "Automatically manage signing" est coché

# 6. Construire l'IPA signé
flutter build ipa --release

# 7. Le fichier sera généré dans:
# build/ios/ipa/event_app.ipa

# 8. Télécharger le fichier IPA depuis MacinCloud vers votre ordinateur

# Alternative si problème de signature:
flutter build ios --release --no-codesign
# Puis signer manuellement dans Xcode