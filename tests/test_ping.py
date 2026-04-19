import unittest
from backend.app import app

class PingTestCase(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def test_ping(self):
        response = self.client.get("/api/ping?destination=google.com")

        assert response.get_json()["status"] == 200
        assert ("successfully pinged" in response.get_json()["message"])

    def test_ping_invalid(self):
        response = self.client.get("/api/ping?destination=notawebsite.xc")

        assert response.get_json()["status"] == 400
        assert ("DNS error" in response.get_json()["message"])


if __name__ == "__main__":
    unittest.main()