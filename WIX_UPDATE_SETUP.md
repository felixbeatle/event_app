# Configuration Wix pour le système de mise à jour

## Collection à créer dans Wix: `AppVersion`

Vous devez créer une nouvelle collection dans votre CMS Wix avec le nom `AppVersion` et les champs suivants:

### Champs de la collection AppVersion:

1. **platform** (Text)
   - Valeurs possibles: "ios" ou "android"
   - Obligatoire

2. **version** (Text) 
   - Format: "3.0.4" (version sémantique)
   - Obligatoire

3. **buildNumber** (Number)
   - Numéro de build (ex: 10)
   - Obligatoire

4. **message** (Text)
   - Message personnalisé à afficher
   - Par défaut: "Une nouvelle version est disponible."

**Note**: Toutes les mises à jour sont maintenant forcées (obligatoires).

## Fonction HTTP à ajouter dans Wix

Ajoutez cette fonction dans votre fichier HTTP functions Wix:

```javascript
export function post_appversion(request) {
    return request.body.json()
        .then(body => {
            if (!body.authorization || !body.clientId) {
                return badRequest({
                    body: JSON.stringify({ error: "Missing required fields" }),
                    headers: { "Content-Type": "application/json" }
                });
            }

            return wixData.query("AppVersion")
                .limit(10)
                .find()
                .then((results) => {
                    if (results.items.length === 0) {
                        return badRequest({
                            body: JSON.stringify({ error: "No app version found" }),
                            headers: { "Content-Type": "application/json" }
                        });
                    }
                    return ok({
                        body: JSON.stringify({
                            message: "Données des versions récupérées",
                            items: results.items
                        }),
                        headers: { "Content-Type": "application/json" }
                    });
                })
                .catch(error => {
                    return badRequest({
                        body: JSON.stringify({ error: error.message }),
                        headers: { "Content-Type": "application/json" }
                    });
                });
        });
}
```

### Exemples d'enregistrements:

**Pour Android:**
```
platform: "android"
version: "3.0.5"
buildNumber: 11
message: "Nouvelle version avec corrections de bugs et améliorations."
```

**Pour iOS:**
```
platform: "ios" 
version: "3.0.5"
buildNumber: 11
message: "Nouvelle version avec corrections de bugs et améliorations."
```

### URLs des stores configurées:

Les URLs sont maintenant correctement configurées dans `version_check_service.dart`:

1. **App Store URL (iOS):**
   ```dart
   return "https://apps.apple.com/ca/app/salon-de-lapprentissage/id6743262404?l=fr-CA";
   ```

2. **Google Play URL (Android):** 
   ```dart
   return "https://play.google.com/store/apps/details?id=com.felixservice.salonapprentissage";
   ```

### Comment ça fonctionne:

1. L'app vérifie au démarrage s'il y a une nouvelle version
2. Compare la version actuelle avec celle dans Wix
3. Si une mise à jour est nécessaire, affiche une popup **obligatoire**
4. L'utilisateur **doit** cliquer pour aller sur le store
5. La popup ne peut pas être fermée - mise à jour forcée

### Pour tester:

1. Créez la collection dans Wix
2. Ajoutez un enregistrement avec une version supérieure à votre version actuelle
3. Relancez l'app - la popup devrait apparaître