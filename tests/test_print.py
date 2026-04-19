import unittest
from backend.app import app

class PrintTestCase(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def test_print(self):
        response = self.client.get("/api/print?arg=Hello")

        assert response.get_json()["status"] == 200
        assert response.get_json()["message"] == "Print: Hello"


if __name__ == "__main__":
    unittest.main()