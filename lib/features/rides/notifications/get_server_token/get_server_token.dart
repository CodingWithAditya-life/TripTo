import 'package:googleapis_auth/auth_io.dart';

class GetServerToken {
  Future<String> getServerToken() async {
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "fir-apptest-c3e4e",
          "private_key_id": "9a4582adcdf36d5a21d34b6567b80293e45a037d",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDFIvjTTUcjs1qh\nvdfs89WnqTvOIhDakY1rN+NK+E05ImxHHHD0TF6yp257TQnQZbSKpvA7iIwtIe1z\nhLPQxwoK/eblZqozlKZaVVde5mvTtTYM1vaU0CmFDPyKtSf5YYPlPXip7OhW6YoG\nVrhq87hDBiReiCoCD5gyrYdpgyRZRaAhO61rljak6LjFzxnLn/ksav7pddptNyDJ\nozPA7R8p0ea81QWAyxzWgtYUXcxInVm9Y7b2LN4DhrKgv7cfNVq6g07sQ8lu434p\nl6PaTGkJOLABxJtB5yMWcql76B8d4WW9q1LVDJ5lQf1E3jL43PF3dH/RtCcA1U7P\ny7Xwsb/3AgMBAAECggEAU5/croHLCiVkblUCWhUrTlZ3NJ91x8nTlCZeiChhVbm4\n9cdmUPNuflmQ/8PzxE/IcMKVCKQJVoHcYNLrlkZAh94hyrEsxPmrQYmPKQYUundV\nyMeNTR4qZrLWFB75qIuJsD5Nx8Nj4a5qqvqxe0kMon3iAqm/LCWiWekLlqIXUrh7\nJn1bZXkDT63K3HCLxSC5jAELeZDc3vTgj3zQFOK1xRRyufhz4ZMqG72bUNIClinh\n3WU7ThYi17Q5HGPKU1h8yYO3vsEmkeF8f5wu3SOTV1hieeFP0K9hdgFjoPH2wCdd\nFQef0vXZFKBAIuP2fc1nn9xsTf1datrmc1O49Z4s9QKBgQD5tobo9NwUiarkcg4R\nZv9RgoENGqbjnjAaELjtUQD7JuyUAQ2lYreBGyQKRXBL75U8c4HgHdSftaZY1hlO\nrSf7ibQgsqWldd1anrSPOm7EngU3MjxZhpa4mDkGguDRztkWh4R1zSBbBTwAKQH+\nB/aCJdQCFIxuZKBhTek21gB3ZQKBgQDKGZMphOGfAh/dW8jgYEbPmBlmjUE/Ebet\nPrE7j2dLFIX9XNCZXvH6MXi1Tt8trohYvsAkw6PXSAYWuH8XKBGKw95UqVX4hIgg\nbd6WSmEpkb7ha8iSTknmT6jIFZxaYQnfaGxs7k7W5ksqNxfjUb8diAoQkZadbere\n1g/3HEjKKwKBgQDiRbP/uYkHDywMLxFyUWs/d8rqjeD11ixuIgL//+usqLus7Ttp\nRodTdL12lS9Jj8Ih8eSYqU82nQor620pLpxRQJk5G8gfoyq955tjQaaHgUzmlB29\nXciLYlwh+0wusYli8c9kU0hjUd3poz8L6jlD+3UdoXMSwRnWshuGNepcRQKBgH6r\n2v5aCGR2m2xOHDDuh1OUnM8XWD7kpwCSW9nd/zsi6Pyt0R1gUkCkA2l4vw/N5i3h\nmWMxsJ69yPsyto3YEm6sZ80eugDjaMMSukHu6sl4TXDS8sspAM63PS3zxaUsT1jV\nBaidEZNGkvQpxfI4CZbD7rMF3aZc/6qd9zHGa6UzAoGAC4864DqYy1mp8j4g/eHI\n7lRNsb1nZnIokTOCObKZeb9d4EwnrtCdu2+HbYdal6tWj5Eobpzr8BkrYP1KbIcN\n44UDoH3A6+BAaAMfZBq553adj5IGNS3R3HxE/v+uNf9wSCPLhuzW3Ziwm57cSCfm\naGfVoaUSxTf9LrhnGFjUYAY=\n-----END PRIVATE KEY-----\n",
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
