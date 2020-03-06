VARIANTS := $(shell find inc -type f -depth 2 \
	|cut -d/ -f3 |cut -d. -f1 |sort -u |grep -v '^metadata$$')

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

.PHONY: build
build: $(addprefix build/,$(PDFS))

# Clean to remove the prior builds, then build.
.PHONY: rebuild
rebuild: clean
	$(MAKE) build

.PHONY: clean
clean:
	@# When using TeXShop, it always builds into the main directory.
	rm -rv build/ || true
	rm -v {spikes,resume}.{aux,log,pdf,synctex.gz*} || true

build/%.pdf : spikes.tex resume.cls $(INCLUDES)
	@mkdir -pv build
	"$(PDFLATEX)" $(PDFLATEX_OPTS) --jobname="$*" spikes.tex < /dev/null
