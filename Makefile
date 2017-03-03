PDFLATEX := /usr/local/texlive/2016/bin/x86_64-darwin/pdflatex

.PHONY: default
default: spikes.pdf

spikes.tex: ;
resume.cls: ;

spikes.pdf: spikes.tex resume.cls
	"$(PDFLATEX)" spikes.tex < /dev/null

clean:
	rm -fv {spikes,resume}.{aux,log,pdf,synctex.gz*} || true

