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
              "private_key_id": "92c64ceae4e012bc029bb67c84c4242283d8d5c6",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC+B33xua9SHaut\n5rwHxgAvONosLCsa1JB2vtD5uPO6C18aioYdcrusMTuVPygoGIaT2SRabv/oZ5Cb\nPlwRGUDwhtbWsRTZSHnAwWhRHP8MDjPBhv/u5IItW4TFMGkM/11ZImC7uI3xL54e\n7nqNnHZF/KT1IU7Mw/P3ahhlAXTbeHBEMEpMZv6efeJQ7cgpJs0YwpBAy5s6ZqH1\n4xLvOBL+5MYb4JPSCJ5DDzZgo01KdkkHpibR6jt6dadvxwFA6bMS2zYj9ersmKH5\n3NfOIE01yF175Oscp/pX+Gbct4IZNS1d09vCtNfpapJLrIymRxRq0eY580YUmYjs\nPwRc10LLAgMBAAECggEACEuxbtUJV09eSEgzWy+EoIsd0yHWe+RdriFkZBJz6WJH\ns5PqiOySTtETZc+NBDsV3Ox0ztHbsBydTnmpcUGl+RoZ1OOEInwsfIK0+B2I8NDJ\n55/qGla1bB97q1QSsfOP8q0yhd9nqujGQVlt1jLHYwTFesIKe5vuUZW7HOW0YURM\nUNnEtrrjRB3dDMJP54mhXtW2IIchY2Zr9MB+BwNdIOk9nnBZROBqJhfn28EUwQ3P\njnA+RwWaWJJQbjQyRcTM/dvk70vB0z+omVXfvMM2WMUtovBRbiv/Lti+8OdEkWhf\ntbQDwYGeBpIibad6qoV5FRH8gZRxwN42Oono7MxT2QKBgQD6WgUNvUndKMpTaD0Y\n6esJrLgu/poRvsnHHHHgeSwInCzDeFMJnSS7ZEVwQZrp/hLEmo9bMwMLlBA2POeS\nkeTNOzcpcCNvZTNWRADU97en6DjLAXadHD+Km/+Q0wcIrEd+T4lum/6APyhQI6e6\nzX3EpozvPNv6qW/SZvR8jKRUBQKBgQDCUQ/7//uTi5y55Iqvnk1PPIUPL0pUjZ1z\nCbiIIxCXYVfzopJO84JaAtfqeu7uKHUAJ1AtTutcFkxMYFySNcSsVnFsP8uU8MJH\nPKmJzgCSVb71s0EVrOK5CCAMBnMMpdepUn+gG5Vd0oKYE0SW+C5ee21bmiGk9Zcj\nK7XGS79EjwKBgQCwVswMe3IVt2+cBGZUsB9/9wrc/zTinvJdr2l+5ZrgjbDyFkTX\nFrsSy3Qlt/A4NWBe30duw6W3eBlbOtcaZG03KiiWpYgwJKZecxPq7nmMaYPnaiZ0\nT7tqFKuVBS+FKmRJUhjJslM3XkU0/YhdifS2mWHX+ZQxITvEhgRb3my5SQKBgQDC\nSXjY90acbNBkkZ0VIQudeR51Y0xHpFzUI9kMzTqOkXb2FAuDwzgHNaabPRVerLbn\nU2d4Fdt/9I+PIh4M1pPx2HCJ0nOEVQF7Zq0BKycpKXDIi9U8jeMXLIeWXnB0KfGq\ny+Dtvgani46l7UX8SONb9r8OAts265OVR+P1A9GXAwKBgA4N0nncS01CgLH+yWjl\ntMuQBlTLUPirg6dd0rVY7ZWa5eDIfjg8lU8QDa6EFOHOkLApTmIbNTVr1Ypk5SG8\ns+sz6cgOwujPf5Fz0VIU6k6p42j4WT3UtTfp/zDgcdcm8Qb+Kw37eVfLR52mEqz2\nFPAy0o80uSKHvtsv62V2RJN8\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-fbsvc@fir-apptest-c3e4e.iam.gserviceaccount.com",
              "client_id": "103144239168592792876",
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
