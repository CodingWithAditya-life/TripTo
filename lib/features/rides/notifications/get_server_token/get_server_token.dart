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
              "private_key_id": "97bb40565b134613e4a2c9a9d687e0b2cdc8fbec",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC7qBlveyHxTNNs\nYm5O9iFlYt7RcZ8ceH+KE/5pHitbche0RuHENLN3ijp2gQGAKlaDvdatL9isGeJN\n1t36R8PDQCM+k2dy5yX5vncZLmkmPzO8jy2CP4dR+wWU2iHu5GbDd9psaIPKSh96\nkqyv08wPmg/3SoxEqeBHT7FYR0ytKah9VtvHW0OajnbhkzXgVDWjhAWTTgFC0QDL\naPeFSHG3KzuuN0jaUJh9Am8uJS+K8s5g0O8Lm9aNJFF/nDqjKoemmZXKH+AnC+9H\nnHl6WFqoIA2cW7jGHfW5kgKZ3CzVA8iq0iC0SOXoQzdIm0NUr1adYGNDgq1nMoaf\nUEviNGxfAgMBAAECggEAFebjuRg0+PXPg0nlt/+QHEYy3V0WhfsmX5Y/zkMAKnch\nfx/6v6yq+Zu/gQ9DfpLycAPbJ3F7J3MJ763RUKHJnmNA+c+4dje2PfTV77F0AkvE\nHRDU7eu+Pno+x4XCCiDMQaoeayKzpwuJqwOtdgQRQAzqKiGgR29QRuJtP3Fq6JbN\n8mzKLRPOCdQcUbCA8fz/xpU/MGVyH6fV5vl2NH/RObThBD5hudOjV7TKQvNvBtYk\nFKypfMZcQYYY7EyeRqPVioDyP3bp1Fq/HwtsntU6GqTMIdILAvGe8vr9NR3SuIHZ\nZf4a1c/79t23nenVlvgjpn3iFsJyEXRqCcIxXoBzuQKBgQDcr/qUXL/WQzWvRkLo\nyiEWShLziYJT9DAzrwRMIuh7O4dKm5/zUJ1KcK03BN+BYYE1zKGebVWP1ciIcc6+\nq26NgcrxtexQYL2Toy3kdJx+AVPJv8LQe9Gysue0f1o7NuQK1lTrcPx2uGYsPBCZ\nro6hGp7lizHv6siAZ8zLEc9LWwKBgQDZrxSRyah51lIudjyRJSDj20PUKsY0SCuK\n6q4xj31S571roUD0AQDP5OcTa+sD3ZCw4hMP6L8yVn00kx9t3m2wO/N26o+wu2jZ\nW1GTgflHUdu8KPdk9ecfslxAHDalMrz6tuLbgNphoyOtyOuamD9YafipPatPvxEu\nvcgCPyXmTQKBgE8HYfexQy2KgfYTdjCA+dpOinzV+GryHjTT7vkI4zIGPku0cVIj\nwz/+G7mBMDzX2vqWHiZqxuIsT5S1FLFpGLzqBvAKEucxzZHKNMwECmqBNS0hU7Vv\nMcgJkzorBPgBjyZmXKC3pGErZcNfex5dyUveCZrv/uEIteZtxYPPC+nTAoGAeSnI\nazUxf09Zwt6w66Ec43biFDASznr1MYdamd9iREkU19mTi70bNJwWOmsxDp++r5XG\nQm6sLVqSqjbRoZfSuetEooYAoMBPpdv8VfxcQeRASEUNHrb4hF4ElvKdP+oz4eD1\n+HOKGhpx+4MAELZ5W77wV1MqDWMuLzQXJZj8gWkCgYB2tC64H5p2Zll2QjF/EfVb\nu0TeUKtvVAY/s3/KbA+OyX7wzPRGIq6IoH0ZR+HOKl+k2iICxuGUB/R5yfw/OvkI\nxwHuUAN/JTwHP9pzvFaM59NGC/c6Pwenm6bFkjZFwsGseKUnz3U2iHltxElrF0Yt\nefuNRI+v8DbRJVTiTYNSxw==\n-----END PRIVATE KEY-----\n",
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
