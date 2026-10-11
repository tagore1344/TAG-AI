# core/utils.py — Helper utilities for Tag AI
import os
import re
import time
import platform
from datetime import datetime
from functools import wraps


def is_windows():
    """Return True if running on Windows."""
    return platform.system() == "Windows"


def now():
    """Return the current timestamp as a formatted string."""
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def clean_text(text):
    """Remove extra whitespace and normalize quotes from text."""
    if not text:
        return ""
    # Replace smart quotes
    text = text.replace("\u201c", '"').replace("\u201d", '"')
    text = text.replace("\u2018", "'").replace("\u2019", "'")
    # Collapse whitespace
    text = re.sub(r"\s+", " ", text).strip()
    return text


def retry(max_attempts=3, delay=1.0):
    """Decorator that retries a function on exception."""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(1, max_attempts + 1):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts:
                        raise
                    print(f"[RETRY] {func.__name__} failed (attempt {attempt}/{max_attempts}): {e}")
                    time.sleep(delay)
            return None
        return wrapper
    return decorator


def ensure_dir(path):
    """Create a directory path if it doesn't exist."""
    if path:
        os.makedirs(path, exist_ok=True)
    return path


def read_file_safe(path, default=""):
    """Read a text file, returning default on any error."""
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    except Exception:
        return default


def write_file_safe(path, content):
    """Write text content to a file, creating parent directories as needed."""
    try:
        dirname = os.path.dirname(path)
        if dirname:
            os.makedirs(dirname, exist_ok=True)
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        return True
    except Exception:
        return False

def adopt_legacy_path(path: str) -> str:
    """Use an existing Ultron data file when the Tag AI filename is not there yet."""
    legacy = path.replace("tag_ai_", "ultron_")
    if legacy == path or os.path.exists(path) or not os.path.exists(legacy):
        return path
    parent = os.path.dirname(path)
    if parent:
        os.makedirs(parent, exist_ok=True)
    try:
        os.replace(legacy, path)
    except OSError:
        return legacy
    return path


_LEGACY_ENV = {
    "TAG_AI_HOST": "ULTRON_HOST",
    "TAG_AI_PORT": "ULTRON_PORT",
    "TAG_AI_ENV": "ULTRON_ENV",
    "TAG_AI_LOG_LEVEL": "ULTRON_LOG_LEVEL",
    "TAG_AI_CORS_ORIGINS": "ULTRON_CORS_ORIGINS",
    "TAG_AI_GEMINI_SDK": "ULTRON_GEMINI_SDK",
    "TAG_AI_CONSENSUS_MODE": "ULTRON_CONSENSUS_MODE",
    "TAG_AI_MODEL": "ULTRON_MODEL",
    "TAG_AI_REASONING_EFFORT": "ULTRON_REASONING_EFFORT",
    "TAG_AI_USE_ASTRA": "ULTRON_USE_ASTRA",
    "TAG_AI_WORKSPACE": "ULTRON_WORKSPACE",
    "TAG_AI_REPO_ROOT": "ULTRON_REPO_ROOT",
    "TAG_AI_TEST_MODE": "ULTRON_TEST_MODE",
}


def bridge_legacy_env() -> None:
    """Copy old ULTRON_* settings into TAG_AI_* when the new name is unset."""
    file_values = {}
    env_path = os.path.join(os.getcwd(), ".env")
    if os.path.exists(env_path):
        try:
            with open(env_path, encoding="utf-8") as handle:
                for line in handle:
                    line = line.strip()
                    if not line or line.startswith("#") or "=" not in line:
                        continue
                    key, value = line.split("=", 1)
                    file_values[key.strip()] = value.strip().strip('"').strip("'")
        except OSError:
            file_values = {}
    for new, old in _LEGACY_ENV.items():
        if os.environ.get(new):
            continue
        if os.environ.get(old):
            os.environ[new] = os.environ[old]
        elif old in file_values and new not in file_values:
            os.environ[new] = file_values[old]


bridge_legacy_env()
