# CandidateAPI for Vitesse

## Installation

Le back-end (de test) est développé en Swift via le framework service-side [Vapor](https://vapor.codes)

Il vous faudra donc suivre [les étapes d'installation de Vapor](https://docs.vapor.codes/install/macos/) afin de pouvoir exécuter le backend

## Lancez le backend

Une fois Vapor installé, vous pouvez simplement lancer le serveur en ligne de commande avec la commande suivante :

```
swift run App --auto-migrate
```

```
[ NOTICE ] Server starting on http://127.0.0.1:8080
```

## Compte Admin

Par défaut, au lancement de l'application, un compte admin sera créé :

- email: `admin@vitesse.com`
- mot de passe: `test123`

## API Detail

### `GET /`

Description: Il s'agit d'une route pour vérifier si l'API est lancée. Doit retourner "It works" si le serveur est correctement lancé.

### `POST /user/auth`

Description: Permet de s'authentifier dans l'API et de générer un token pour utliser l'API

Body Content Type: `application/json`
Body Format :

- `email`: `String` (`email`)
- `password`: `String`

Exemple:

```
{
    "email":"admin@vitesse.com",
    "password":"test123"
}
```

Body Response:

- `token`: `String`
- `isAdmin`: `Bool`

Exemple:

```
{
    "token": "FfdfsdfdF9fdsf.fdsfdf98FDkzfdA3122.J83TqjxRzmuDuruBChNT8sMg5tfRi5iQ6tUlqJb3M9U",
    "isAdmin": false
}
```

### `POST /user/register`

Description: Permet de créer un compte utilisateur dans l'API

Body Content Type: `application/json`
Body Format :

- `email`: `String` (`email`)
- `password`: `String`
- `firstName`: `String`
- `lastName`: `String`

Exemple:

```
{
    "email":"test@vitesse.com",
    "password":"TOTO"
    "firstName": "Toto",
    "lastName": "Henry"
}
```

Status Response: `201 Created` si la céeation s'est bien passée

### `GET /candidate`

Description: Permet de récuperer la liste des candidats

Header:

- `Authorization`: "Bearer " + `String` (`UUID`)

> Le token à fournir en header ici est le token obtenu dans l'appel à la route `POST /user/auth`

Exemple de réponse:

```
[
    {
        "phone": null,
        "note": null,
        "id": "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1",
        "firstName": "Rima",
        "linkedinURL": null,
        "isFavorite": false,
        "email": "sidi.rima@myemail.com",
        "lastName": "Sidi"
    }
]
```

### `GET /candidate/:candidateId`

Description: Permet de récuperer le détail d'un candidat via son ID (``:candidateId`)

Header:

- `Authorization`: "Bearer " + `String` (`UUID`)

> Le token à fournir en header ici est le token obtenu dans l'appel a la route `POST /user/auth`

Exemple de réponse:

```
{
    "phone": null,
    "note": null,
    "id": "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1",
    "firstName": "Rima",
    "linkedinURL": null,
    "isFavorite": false,
    "email": "sidi.rima@myemail.com",
    "lastName": "Sidi"
}
```

### `POST /candidate`

Description: Permet de créer un candidat

Header:

- `Authorization`: "Bearer " + `String` (`UUID`)

> Le token à fournir en header ici est le token obtenu dans l'appel a la route `POST /user/auth`

Body Content Type: `application/json`
Body Format :

- `email`: `String` (`email`)
- `note`: `String?`
- `linkedinURL`: `String?`
- `firstName`: `String`
- `lastName`: `String`
- `phone`: `String`

Exemple de réponse:

```
{
    "phone": null,
    "note": null,
    "id": "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1",
    "firstName": "Rima",
    "linkedinURL": null,
    "isFavorite": false,
    "email": "sidi.rima@myemail.com",
    "lastName": "Sidi"
}
```

### `PUT /candidate/:candidateId`

Description: Permet de mettre à jour un candidat via son identifiant fourni dans l'URL (candidateId)

> ⚠️ L'update sur le champ isFavorite n'est pas pris en compte par l'API car reservé aux Administrateurs est uniquement faisable via la méthode `PUT /candidate/:candidateId/favorite`

Header:

- `Authorization`: "Bearer " + `String` (`UUID`)

> Le token à fournir en header ici est le token obtenu dans l'appel a la route `POST /user/auth`

Body Content Type: `application/json`
Body Format :

- `email`: `String` (`email`)
- `note`: `String?`
- `linkedinURL`: `String?`
- `firstName`: `String`
- `lastName`: `String`
- `phone`: `String`

Exemple de réponse:

```
{
    "phone": null,
    "note": null,
    "id": "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1",
    "firstName": "Rima",
    "linkedinURL": null,
    "isFavorite": false,
    "email": "sidi.rima@myemail.com",
    "lastName": "Sidi"
}
```

### `DELETE /candidate/:candidateId`

Description: Permet de supprimer un candidat

Header:

- `Authorization`: "Bearer " + `String` (`UUID`)

> Le token à fournir en header ici est le token obtenu dans l'appel a la route `POST /user/auth`

Status Response: `20O Ok` si la suppression s'est bien passée

### `PUT /candidate/:candidateId/favorite`

Description: Permet de changer le status de favoris du candidat

> ⚠️ Cette méthode d'API n'est accessible qu'aux admin. Une erreur d'authorisation vous sera indiquée si vous n'êtes pas identifié avec un compte administrateur.

Header:

- `Authorization`: "Bearer " + `String` (`UUID`)

> Le token à fournir en header ici est le token obtenu dans l'appel a la route `POST /user/auth`

Exemple de réponse:

```
{
    "phone": null,
    "note": null,
    "id": "9F2FDA76-8670-4FF4-A4C7-C42F2EC20EF1",
    "firstName": "Rima",
    "linkedinURL": null,
    "isFavorite": true,
    "email": "sidi.rima@myemail.com",
    "lastName": "Sidi"
}
```
