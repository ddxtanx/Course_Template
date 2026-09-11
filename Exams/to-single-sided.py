import pypdf
import sys

if len(sys.argv) != 3:
    print("Usage: python to-single-sided.py input.pdf output.pdf")
    sys.exit(1)
input_pdf = sys.argv[1]
output_pdf = sys.argv[2]
writer = pypdf.PdfWriter()
reader = pypdf.PdfReader(input_pdf)
for page in reader.pages:
    writer.add_page(page)
    writer.add_blank_page()
with open(output_pdf, "wb") as f:
    writer.write(f)
