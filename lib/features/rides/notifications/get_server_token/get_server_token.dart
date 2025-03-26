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
              "private_key_id": "322362150c706decc29ffe3ba0270260c7fb4721",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDQBXOBjGKEs6hJ\ndftuAl9DUsVCrOL3wkVLYArgB7RqGEdbxLfW+ujcjlZXTLVYoUZlIopB+COTX/AI\nFYvmlb4BndfLZbiKypGaHEvCC/VV4p7swl6ZLGKvJk5+5FJ158+cKHZVnXbjN6zP\nFkOVAhHW4HAweJ7uKAo79dVzLzK9t1NrAbo5XazLXE9xZSDSfKe8YIHmsZvYV8CB\nk9C0h1sx6oTxxm+Rc+SGjRHi8i+QOeVpFF/3IL/+nUeWXIvBXmedrphoe3bFUZTU\nROLO+7v1d/9cCdv9ERvmK6vYflTSTxhomXtCO7grQeCdPlofne9iuRfC680Y80tu\nMoKLQDSbAgMBAAECggEAH9NgWJxMdlZbk4xOwLCcN9tHUsF1+ByWKBy0N+egh/Au\n+rCeGnCeL8rsasQm+pMHXMcWtVZsGvVn7n9daBSA0r5+Gsr1Rka3qrGpkDFELQpU\nRjohPvi2IGs77INXb7KHkNyf6M6ujGoi24wMdZUGJa8w0DmkFyEJGnisr3Kz0KfJ\n/fbQVOtPpJLIfHpVSJ0P9DPOK5ORNX9exjFk4IcT7gTHHg8lHMbDq6KB4HuxPTFM\nS+/fEcvtyqTsRmcwhkQC+dP+KeEvNwn8ERUONUI1gxMsSJe2X5rjkQwF451dUOrV\nsRmAOJk+PhUX3Ah8Z3a2wuNrQF0iYvmMIZ1kGeZcAQKBgQD+Z/S8S9MEfr2HYiO2\n9P1FtyYdMObr4zdSyJb4DSbt1uD+VmmbQ9VN8GgBwsisrVnOO48hA1yCTu5bU0iZ\nzkbfuNxIAOMrEEbKixlzlcpFkmrC1QK3O8iXpLRZljdJPDa3FQgyjfjkS4I8N4oQ\nrUfRvdZ9I3ZHADbLMM37haqtBQKBgQDRUxknkZoQePMlWuTos1xw1KfQTOV1cfrf\nazrt+8Txcl9RbZXwmDW5yxfrAs+7K4aFRiEEFYc/SeUUAcOQYWj/O+3AqcpPcjhT\n8ZVknHNdvcqqY4WJMq5KfLXrL/KYkPwpDkcJmo46OSCUb8WjLx/3IpUrrwpsfmxR\nywn251wNHwKBgEEpO0QnX6sdE0pj1qX75gs/N+HuLpdooTjw68opBDmS+hnq5C3C\nmBXYZ6tbyq5/0CrEkopwI/e0Y9S8ZjIO5ZRT8wf2Qjk7eAZUznYOfbqIIBQ7HvDz\nvRMqOo9frFVzuMf3+RuJxaAjvv3Rc+mFmImeSBvRQ3A4G9C7dWbg+7BJAoGAJNOj\n10xMeJ1u2aGWKEJ1/vvK0mDU9capxmjNI1VqHrhqgJ7xBDUjLp7GhHgoJ9vOfOAL\nqvZGpyHPBagRyfL5T/4xI/Y7O6LyugIEsIC94z4iy7taoPqjo0MxlkEHQ0QuuOJk\nKRJh92hZjQPlF4KQ8x/IcrkG8nODhxhblm65yS0CgYBmyMGuPWHBpxwc425VYo8+\nsm9FB5CU4Ua9RGhuXRP3cX+mlPeZZ0Qqaedbxoke4GE0HEqkLhG751vZRb4No+Ed\nYgM4Y31iAo5w/guVOR8rLDkhayGa3Z6ao8KTghSTbmlNj7rQGi5VPoU3F8c+vjyg\n0tgQ82j4p9bEWqczz/Dv+g==\n-----END PRIVATE KEY-----\n",
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
