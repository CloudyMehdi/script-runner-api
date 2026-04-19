import unittest
from backend.app import app

class HealthTestCase(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def health_logs_invalid(self):
        response = self.client.get("/api/health")

        assert response.get_json()["status"] == 200


if __name__ == "__main__":
    unittest.main()