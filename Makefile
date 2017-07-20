PDFLATEX := /usr/local/texlive/2017/bin/x86_64-darwin/pdflatex
BUILDDIR := build
INCLUDES := $(wildcard inc/*/*.tex)
PDFLATEX_OPTS := --recorder --output-directory="$(BUILDDIR)"

SCP_PREFIX := spikes_me@spikes.me:/home/spikes_me/spikes.me/notes
HTTP_PREFIX := "https://spikes.me/notes"

.PHONY: default
default: pdf

.PHONY: pdf
pdf: build/draft.pdf build/dev.pdf build/sre.pdf

# The --recorder option is necessary for currfile to work correctly. Otherwise,
# currfilebase is always the same as jobname, and our variant stuff doesn't
# work right.
build/draft.pdf : spikes.tex resume.cls $(INCLUDES)
	@mkdir -pv "$(BUILDDIR)"
	"$(PDFLATEX)" $(PDFLATEX_OPTS) spikes.tex < /dev/null
	mv "$(BUILDDIR)/spikes.pdf" "$(BUILDDIR)/draft.pdf"

build/%.pdf : spikes.tex resume.cls $(INCLUDES)
	@mkdir -pv "$(BUILDDIR)"
	"$(PDFLATEX)" $(PDFLATEX_OPTS) --jobname="$*" spikes.tex < /dev/null

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
	git add spikes.tex resume.cls inc/*/*.tex
	@# My global gitignore ignores the build directory (so many projects
	@# without a decent gitignore), but in this case, I actually do want to
	@# track the progression of my resume PDFs, at least for now.
	git add -f build/*.pdf
	git commit -m 'Progress (auto-commit)'

.PHONY: publish-preview
publish-preview: build/draft.pdf
	scp "$(BUILDDIR)/draft.pdf" "$(SCP_PREFIX)/resume-preview.pdf"
	@echo
	@echo Preview published to "$(HTTP_PREFIX)/resume-preview.pdf"

publish-%.pdf : build/%.pdf
	scp "$(BUILDDIR)/$*.pdf" "$(SCP_PREFIX)/resume-test-Spikes-Wesley-$*.pdf"
	@echo
	@echo Published "$*" variant to "$(HTTP_PREFIX)/resume-test-Spikes-Wesley-$*.pdf"

.PHONY: publish-production
publish-production: publish-dev.pdf publish-sre.pdf

