import base64
from pypdf import PdfReader

def extract_text_from_pdf(file_path: str) -> str:
    text = ""
    reader = PdfReader(file_path)
    for page in reader.pages:
        text += page.extract_text() + "\n"
    return text

def extract_image_base64(file_path: str) -> str:
    with open(file_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

def validate_file(file_path: str, file_type: str) -> bool:
    return True

def get_file_type(filename: str) -> str:
    if filename.lower().endswith('.pdf'):
        return 'pdf'
    return 'image'
