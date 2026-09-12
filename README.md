# Course_Template

LaTeX templates for the five document types this course uses: **exams**,
**homework**, **lectures** (slides + handout), **quizzes**, and
**worksheets**. All documents are typeset as *tagged* PDFs (PDF/UA-2
accessibility + PDF/A-4f archival conformance) via
`tag-template.tex`.

## Requirements

- **TeX Live 2026** (or a TeX Live carrying LaTeX ≥ 2025-11-01). The
  templates use `tagpdf`'s `\DocumentMetadata` with the `tagging`/
  `tagging-setup` keys and the `ltx-talk` class, which are not in older
  TeX Live releases (older tagpdf versions do not know those keys).
- Everything else (`exam`, `biblatex`, `imakeidx`, `talkthemetcolorbox`,
  `atkinson`, `emoji`, ...) is a normal package; any current TeX Live has
  them.

## How the folder layout works (read this first)

Templates are stored **one directory above** where they get compiled.
Each real exam/lecture/quiz/etc. lives in its **own subfolder**:

```
Course_Template/
├── Exams/
│   ├── exam-template.tex            <- copy this into a subfolder
│   └── midterm/
│       └── midterm.tex             <- your copy, compiled HERE
├── Homework/
│   ├── homework-macros.tex          <- shared setup, \input'ed by the template
│   ├── homework-template.tex
│   └── hw1/
│       └── hw1.tex                 <- your copy, compiled HERE
├── Lectures/
│   ├── lecture-macros.tex
│   ├── lecture-template.tex
│   └── AllLectures/
│       ├── compile_all_lectures.py
│       └── compiled-template.tex
├── Quizzes/
├── Worksheets/
├── compile-wrapper.sh               <- runs latexmk (LuaLaTeX) on one file
├── macros.tex                       <- shared math shorthands, all documents
└── tag-template.tex                <- \usepackage{tagpdf} + \DocumentMetadata
```

Every template begins with

```tex
\input{../../tag-template.tex}
```

Two levels up from a **subfolder** (`Exams/midterm/`) that is exactly
`tag-template.tex` at the repository root. If you instead compile
`Exams/exam-template.tex` in place, `../../` climbs above the repository
root and TeX fails with

```
! LaTeX Error: File '../../tag-template.tex' not found.
```

So: **copy the template into its own subfolder and compile from there.**
`compile_all_lectures.py` and the per-category shell scripts already
assume this layout.

### Which script, from where

| Task | Run from | Command |
|---|---|---|
| One file (any document) | its subfolder | `../../compile-wrapper.sh midterm.tex` |
| Exam + solutions variant | `Exams/<name>/` | `../../compile-exam-and-solutions.sh` |
| Quiz + solutions variant | `Quizzes/<name>/` | `../../compile-quiz-and-solutions.sh` |
| Lecture slides + handout | `Lectures/<name>/` | `../../compile-slides-and-handout.sh` |
| All lectures at once | `Lectures/` | `python3 AllLectures/compile_all_lectures.py` |

`compile-wrapper.sh` runs `latexmk -pdflua -f -lualatex
-interaction=nonstopmode -halt-on-error` on the file you give it.

## `refs.bib`

`Lectures/lecture-macros.tex` contains `\addbibresource{refs.bib}`, which
is resolved relative to the compile folder. **Every lecture must have a
`refs.bib` in its own subfolder** — an empty file (`refs.bib` with no
entries) is fine and silences biber if the lecture has no citations.
The other document types load `biblatex` but add no bibliography, so they
need no `refs.bib`.

## Accessibility (tagged PDF)

- `tag-template.tex` sets the PDF standards: `pdfstandard={UA-2,A-4f}`
  (one key, comma-separated list — separate `pdfstandard=` keys do not
  work), `lang=en-US`, tagging on, MathML (SE) for math.
- Slide titles (`\frametitle`) are mapped to the H1 heading role, and
  exactly one PDF bookmark is created per logical frame/section, so the
  PDF outline and screen-reader structure match the slides.
- Link colors in the `*-macros.tex` files are chosen for ≥ 4.5:1 contrast
  on white (WCAG 1.4.3). Don't reintroduce low-contrast colors like cyan
  (1.25:1) or magenta (3.14:1).

## The `*-macros.tex` files

Each is the shared package setup for its category's template; every
logical block is commented in place:

- `Homework/homework-macros.tex`
- `Lectures/lecture-macros.tex`
- `Quizzes/quiz-macros.tex`
- `Worksheets/worksheet-macros.tex`

They are `\input` from the template (one level down), which in turn is
compiled from one level further down — hence `../../macros.tex` at the
bottom of each (root `macros.tex`: `\RR`, `\NN`, `\grad`, `\curl`,
`\pder`, ...).
