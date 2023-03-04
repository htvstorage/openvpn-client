import PyPDF2
from PyPDF2.generic import AnnotationBuilder
pdfFile = './Profile Download and Installation Procedure.pdf'
pdfFileNew = './New_Profile Download and Installation Procedure.pdf'

# Open the PDF file in read mode
pdf_file = open(pdfFile, 'rb')

# Create a PDF reader object
pdf_reader = PyPDF2.PdfReader(pdf_file)

# Get the first page of the PDF
page = pdf_reader.pages[0]

# Get the width and height of the page in points
page_width = page.mediabox.width
page_height = page.mediabox.height

# Print the width and height of the page
print(f'Page {0+1} - Width: {page_width:.2f} pts, Height: {page_height:.2f} pts')
page_text = page.extract_text()
print(page_text)

# Create a PDF writer object
pdf_writer = PyPDF2.PdfWriter()

# Add the page to the PDF writer object
pdf_writer.add_page(page)

# Create a text annotation
annotation = AnnotationBuilder.free_text(
    page_text,
    rect=(50, 550, 200, 650),
    font="Arial",
    bold=True,
    italic=True,
    font_size="20pt",
    font_color="00ff00",
    border_color="0000ff",
    background_color="cdcdcd",
)
pdf_writer.add_annotation(page_number=0, annotation=annotation)

# Add the annotation to the page
# page.addAnnotation(text_annotation)

# Save the modified PDF file
output_file = open(pdfFileNew, 'wb')
pdf_writer.write(output_file)

# Close the files
pdf_file.close()
output_file.close()
