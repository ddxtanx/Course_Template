import os
import re

with open("compiled-template.tex", "r") as f:
    template = f.read()

lecture_files = []
multimedia_files = []
multimedia_extensions = [".png", ".jpg", ".jpeg", ".gif"]
for root, dirs, files in os.walk(".."):
    if not root.startswith("../Lecture "):
        continue
    for filename in files:
        if filename.startswith("Lecture ") and filename.endswith(".tex"):
            lecture_files.append(os.path.join(root, filename))
        if any(filename.lower().endswith(ext) for ext in multimedia_extensions):
            multimedia_files.append(os.path.join(root, filename))


lecture_filename_re = r"Lecture \(\d+\) - .*\.tex"


def path_to_sort_key(path):
    # Extract the lecture number from the path
    match = re.search(r"Lecture (\d+)", path)
    if match:
        return int(match.group(1))
    else:
        return float("inf")  # If no lecture number is found, sort it to the end


lecture_files.sort(key=path_to_sort_key)

subfile_string = []


def extract_body(content):
    m = re.search(r"\\begin\{document\}(.*)\\end\{document\}", content, re.DOTALL)
    return m.group(1) if m else content


for lecture_file in lecture_files:
    with open(lecture_file, "r") as f:
        content = f.read()
    body_content = extract_body(content)
    body_content = body_content.replace("\\subsection", "\\subsubsection")
    body_content = body_content.replace("\\section", "\\subsection")
    body_filename = lecture_file.replace(".tex", "-standalone.tex")
    with open(body_filename, "w") as f:
        f.write(body_content)
    lecture_title = os.path.basename(lecture_file).replace(".tex", "")
    subfile_string.append(f"\\section{{{lecture_title}}}")
    subfile_string.append(f"\\title{{{lecture_title}}}")
    subfile_string.append(f"\\input{{{body_filename}}}")
for multimedia_file in multimedia_files:
    os.link(
        multimedia_file, os.path.join(os.getcwd(), os.path.basename(multimedia_file))
    )


subfile_string = "\n".join(subfile_string)

tex_content = template.replace("<<<INSERT TEMPLATE>>>", subfile_string)

with open("AllLectures.tex", "w") as f:
    f.write(tex_content)

os.system("../../compile-wrapper.sh AllLectures.tex")

for lecture_file in lecture_files:
    standalone_filename = lecture_file.replace(".tex", "-standalone.tex")
    os.remove(standalone_filename)

for multimedia_file in multimedia_files:
    os.remove(os.path.join(os.getcwd(), os.path.basename(multimedia_file)))
