VARIANTS := draft dev sre

SCP_PREFIX := spikes_me@spikes.me:/home/spikes_me/spikes.me/notes
HTTP_PREFIX := "https://spikes.me/notes"

PDFLATEX := /usr/local/texlive/2017/bin/x86_64-darwin/pdflatex

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
	#     Create a PDF for the draft, as well as each of the variants.
	#     All resumes are written into the build/ directory.
	#
	# rebuild:
	#     Cleans up everything (distclean), then builds (twice!) to
	#     have a complete build. See also the description of clean.
	#
	# publish:
	#     Publish the PDFs to my domain, including draft/preview.
	@echo '#     $(HTTP_PREFIX)'
	#
	# clean:
	#     Cleans up the built PDFs. Does *NOT* clean up build artifacts,
	#     since LaTeX needs them for the 'LastPage' bits in the footer.
	#     See the comments above the clean rule for more information.
	#
	# distclean:
	#     Cleans up everything, including the build artifacts. It's not
	#     reccomended to use this directly.
	#
	# commit:
	#     Add any changes to the resume, including it's built PDFs, to
	#     git and commit with a generic message. This gets tedious.
	#     NB: I'll probably filter-branch to remove the PDFs in the future,
	#     but for now, it's nice to be able to look back and see changes.

.PHONY: build
build: $(addprefix build/,$(PDFS))

.PHONY: publish
publish: $(addprefix publish/,$(VARIANTS))

# Distclean to remove the cached number of pages, build (first build will warn
# about page numbers, see comment on clean), clean the built PDFs, then build
# again to have fully built PDFs.
#
# We must specifically use shell to do the second build as make (intelligently)
# keeps track of the fact that we already built the 'build' target and it's
# dependencies.
.PHONY: rebuild
rebuild: distclean build clean
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
	rm -v build/*.pdf {spikes,resume}.pdf || true

.PHONY: distclean
distclean:
	rm -rv build/ || true
	@# When using TeXShop, we generate cruft in the main directory.
	rm -fv {spikes,resume}.{aux,log,pdf,synctex.gz*} || true

.PHONY: commit
commit: pdf
	git add spikes.tex resume.cls $(INCLUDES)
	@# My global gitignore ignores the build directory (so many projects
	@# without a decent gitignore), but in this case, I actually do want to
	@# track the progression of my resume PDFs, at least for now.
	git add -f build/*.pdf
	git commit -m 'Progress (auto-commit)'

build/draft.pdf : spikes.tex resume.cls $(INCLUDES)
	@mkdir -pv build
	"$(PDFLATEX)" $(PDFLATEX_OPTS) spikes.tex < /dev/null
	mv build/spikes.pdf build/draft.pdf

build/%.pdf : spikes.tex resume.cls $(INCLUDES)
	@mkdir -pv build
	"$(PDFLATEX)" $(PDFLATEX_OPTS) --jobname="$*" spikes.tex < /dev/null

.PHONY: publish/draft
publish/draft: build/draft.pdf
	scp "build/draft.pdf" "$(SCP_PREFIX)/resume-preview.pdf"
	@echo
	@echo Preview published to "$(HTTP_PREFIX)/resume-preview.pdf"

.PHONY: publish/%
publish/% : build/%.pdf
	scp "build//$*.pdf" "$(SCP_PREFIX)/resume-test-Spikes-Wesley-$*.pdf"
	@echo
	@echo Published "$*" variant to "$(HTTP_PREFIX)/resume-test-Spikes-Wesley-$*.pdf"
