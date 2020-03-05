VARIANTS := $(shell find inc -type f -depth 2 \
	|cut -d/ -f3 |cut -d. -f1 |sort -u)

PDFLATEX := /usr/local/texlive/2019/bin/x86_64-darwin/pdflatex

# The --recorder option is necessary for currfile to work correctly. Otherwise,
# currfilebase is always the same as jobname, and our variant stuff doesn't
# work right.
PDFLATEX_OPTS := --recorder --output-directory=build/

INCLUDES = $(wildcard inc/*/*.tex)
PDFS = $(addsuffix .pdf,$(VARIANTS))

.PHONY: help
help:
	# SPIKES' RESUME
	#
	# Currently enabled variants:
	@echo '#     $(VARIANTS)'   # Yeah, that's a thing...
	#
	# build:
	#     Create a PDF for as each of the variants.
	#     All resumes are written into the build/ directory.
	#
	# rebuild:
	#     Cleans up everything (distclean), then builds (twice!) to
	#     have a complete build. See also the description of clean.
	#
	# clean:
	#     Cleans up the built PDFs, including with the build artifacts.
	#
	# commit:
	#     Add any changes to the resume, including it's built PDFs, to
	#     git and commit with a generic message. This gets tedious.
	#     NB: I'll probably filter-branch to remove the PDFs in the future,
	#     but for now, it's nice to be able to look back and see changes.

.PHONY: build
build: $(addprefix build/,$(PDFS))

# Clean to remove the prior builds, then build.
.PHONY: rebuild
rebuild: clean
	$(MAKE) build

# For a regular clean, we keep all of the intermediate files since one of them,
# and I don't know which one, is needed to generate the "Last Page" bit.
# Without this file, we get a slew of errors:
#
# Package lastpage Warning: Rerun to get the references right on input line 116.
# AED: lastpage setting LastPage
# LaTeX Warning: Reference `LastPage' on page 2 undefined on input line 116.
# LaTeX Font Warning: Size substitutions with differences
# LaTeX Warning: There were undefined references.
# LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right.
.PHONY: clean
clean:
	@# When using TeXShop, it always builds into the main directory.
	rm -rv build/ || true
	rm -v {spikes,resume}.{aux,log,pdf,synctex.gz*} || true

.PHONY: commit
commit: build
	git add spikes.tex resume.cls $(INCLUDES)
	@# My global gitignore ignores the build directory (so many projects
	@# without a decent gitignore), but in this case, I actually do want to
	@# track the progression of my resume PDFs, at least for now.
	git add -f build/*.pdf
	git commit -m 'Progress (auto-commit)'

build/%.pdf : spikes.tex resume.cls $(INCLUDES)
	@mkdir -pv build
	"$(PDFLATEX)" $(PDFLATEX_OPTS) --jobname="$*" spikes.tex < /dev/null
