"""Basic tests for University Marketing Analytics Tool."""

from src import __version__


def test_version():
    """Test version is set correctly."""
    assert __version__ == "0.1.0"

def test_import():
    """Test basic import works."""
    import src
    assert hasattr(src, "__version__")
