from flask import Flask, request, jsonify
import openai
import os
import pdfplumber
from docx import Document
import re

app = Flask(__name__)

# Load OpenAI API key
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
openai.api_key = OPENAI_API_KEY

def clean_text(text):
    """Cleans and normalizes resume text."""
    text = re.sub(r'\n+', '\n', text)  # Remove excessive newlines
    text = re.sub(r'[^\x00-\x7F]+', ' ', text)  # Remove non-ASCII characters
    return text.strip()

def extract_text_from_pdf(file):
    """Extracts text from a PDF resume, handling multi-column text."""
    with pdfplumber.open(file) as pdf:
        text = "\n".join([page.extract_text() or "" for page in pdf.pages])
    return clean_text(text)

def extract_text_from_docx(file):
    """Extracts text from a DOCX resume."""
    doc = Document(file)
    return clean_text("\n".join([para.text for para in doc.paragraphs]))

@app.route("/upload-resume", methods=["POST"])
def upload_resume():
    """Handles resume upload and extracts text."""
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    file_extension = file.filename.split(".")[-1].lower()

    if file_extension == "pdf":
        text = extract_text_from_pdf(file)
    elif file_extension == "docx":
        text = extract_text_from_docx(file)
    elif file_extension == "txt":
        text = clean_text(file.read().decode("utf-8"))
    else:
        return jsonify({"error": "Unsupported file format"}), 400

    return jsonify({"extracted_text": text})

if __name__ == "__main__":
    app.run(debug=True)
