import 'package:googleapis_auth/auth_io.dart';

class GetServerToken {
  Future<String> getServerToken() async {
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "fir-apptest-c3e4e",
              "private_key_id": "8fbd2b58e32e9957118c5bb4f1bdd1426910da69",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC7dO5QDTGgahlJ\n8UWTK0UTnYCq/mO8EL/CV9R+sm3eDbXfMUgLhxCEobyQTfLa9VwzksWaz62eohdR\nAxn0+toL4z6kFCVPyWT2akRTL7HfGxt2C8BY7PkHsnuZO/DEn3zBDpK9H0QnnK8b\nV53bYF4Bwr+wblnBQXnVj65AkVnzJa84AljWXHqCWV+EqiAS0eTys4+GJIz8AmU3\nXjZR5yGmxtZJFiOJP2dndL/VJHNljmfFCgdLfYdHAdqmFnFfM4xubKl0PXGfqLf6\nHY8CXmx9hCpNoIwm7rrwUnnR1cq5nYTWk8Gq+aHg9jCj32k3scsTyMrcoRezuURt\ncpB+Jp3tAgMBAAECggEATCIUe+yv4B/XP4G/KSNkva+1Rz1kUkhXKV40jnR3TL0y\nxYAla5Eic0ug4tbVsHoARW3x1YtNT2UzpRJmY2nSTwuvMEKCWOJJoA7Oyx5O1ncS\n8yGYsEUmayrhKf3/Lkw8BciebjMZoiDvuWIfWa7M31gyNDzNNUEbc1IUimK+LpLI\nnVBRvRdaD2YWlMpJsCSAn0giRFuPz+irtRkidIF4ekysOprLfhT1up1hYZGk5nyt\nI9JdYBeV17xf46tONnY8CgcpkvliEi3DU14ps7oKl4fltSRCoP1OaKloNM6Q16Oy\nypB0la7oVGZJ7mpjDrA6ejb+rkpD9tJafWbfxusGXQKBgQDehT8i/0f517K6dMmR\nXwguTLF2JDrExC99Jle23XIPlVrgG/CsIZKP4pQ1ILfSNpG0d318oSaQhp0YVb17\nh25/6hO2FZ9w5+5ozho8fgZNHNbp4sITUB5yhHVv3Uz0wUzbCo4cAGTTMWRtOouH\ngGkhSXJIWS7sHz+ArK9dpV1/VwKBgQDXqSUv/4XFdNFs6e+OiN74qIVUjohIn07W\nRozzc03KirY3aXg8vKUjxiI0DreRYUr5fVrTJD9EFgn9IIGRe272uGNXgo9L7KMz\nwnYXm7pT+PZMIbcqc2JdlMA+fu3J752EEDhmQQx+GCiC5baMHaUA1Ac6+QGZh/gk\nG4rf2KI2WwKBgQCkMt7sDEQocKpKPHOg+ecngyBQdVuIZtxEFU8UeUP5i9SLGxL1\ncbCczC1hJst+KxZJfQL0PFYgv7SciGhSBxXa/fednUcSIZMjczKZAMXVkTplTBa5\n+Zz+FBA0g7CNyzXTTG6g6wl7bi8VCuZ7Dp6FGZVjHawqQMSzRroA+E2N8QKBgH55\nQcfOUIMmKRN4dfbfKfQl0FtwY1hDpRZgtZSoUDyx8H66qbrk3uwF7FUfNGRb7H44\nF6WvojKpwh3ijFnnS4IBTLErbiIWmvdl2Z+qwjEw1jB7rVGF7W/4Jm4APi+pCHVE\nle7RwyPHwypQ0SeG0xeTQNJC6b9CUDHMvTrdbvP1AoGBAKp6y2N8oiw9Jp9esoej\n/MxOiJnpBSXKjJ6UiKSa6yayZgAMM92AtHynuQsDWBRP4Fkg0a7Yn9iot4mxST4V\nECRBz0HIBtJo5afA0uAJVLYnfVRDuI8xS6imSfKINz14w6EwJmCgvjcGDez7ghCz\nJ5FB0puEjLOzQWKLCXtrSiVH\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-fbsvc@fir-apptest-c3e4e.iam.gserviceaccount.com",
              "client_id": "117271971666771266746",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40fir-apptest-c3e4e.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
        ),
        scopes);

    final serverKey = client.credentials.accessToken.data;
    print("ServerKey = $serverKey");
    return serverKey;
  }
}
