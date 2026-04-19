import unittest
from backend.app import app

class LogsTestCase(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def test_logs_invalid(self):
        response = self.client.get("/api/logs?lines=Hello")

        assert response.get_json()["status"] == 400


if __name__ == "__main__":
    unittest.main()