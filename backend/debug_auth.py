import urllib.request
import json
import urllib.error

req = urllib.request.Request(
    'http://127.0.0.1:8000/api/v1/auth/register',
    data=json.dumps({'email': 'test6@example.com', 'password': 'Password123!', 'name': 'Test'}).encode(),
    headers={'Content-Type': 'application/json'}
)

try:
    res = urllib.request.urlopen(req)
    print("Success:", res.read().decode())
except urllib.error.HTTPError as e:
    print("Error:", e.read().decode())
