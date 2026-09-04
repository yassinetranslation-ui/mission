import base64
import os
from pypdf import PdfReader

# Media types accepted by the Claude vision API, keyed by file extension.
_IMAGE_MEDIA_TYPES = {
    ".jpg": "image/jpeg",
    ".jpeg": "image/jpeg",
    ".png": "image/png",
    ".gif": "image/gif",
    ".webp": "image/webp",
}

def extract_text_from_pdf(file_path: str) -> str:
    text = ""
    reader = PdfReader(file_path)
    for page in reader.pages:
        text += page.extract_text() + "\n"
    return text

def extract_image_base64(file_path: str) -> str:
    with open(file_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def get_image_media_type(file_path: str) -> str:
    """Return the Claude-compatible media type for an image file (defaults to JPEG)."""
    ext = os.path.splitext(file_path)[1].lower()
    return _IMAGE_MEDIA_TYPES.get(ext, "image/jpeg")

def validate_file(file_path: str, file_type: str) -> bool:
    return True

def get_file_type(filename: str) -> str:
    if filename.lower().endswith('.pdf'):
        return 'pdf'
    return 'image'
