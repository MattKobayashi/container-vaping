import unittest
import sys
from io import StringIO
from unittest.mock import patch

# Import the main function from the parent directory
import os
import sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from main import main

class TestMain(unittest.TestCase):
    
    @patch('sys.stdout', new_callable=StringIO)
    def test_main_prints_hello_message(self, mock_stdout):
        # Call the function
        main()
        
        # Check that the expected message was printed
        self.assertEqual(mock_stdout.getvalue().strip(), "Hello from template-container-python!")

    def test_main_exists(self):
        # Check that main is callable
        self.assertTrue(callable(main))

if __name__ == '__main__':
    unittest.main()
