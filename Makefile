PDFLATEX := /usr/local/texlive/2016/bin/x86_64-darwin/pdflatex

.PHONY: default clean commit publish

default: spikes.pdf

spikes.pdf: spikes.tex resume.cls
	"$(PDFLATEX)" spikes.tex < /dev/null

clean:
	rm -fv {spikes,resume}.{aux,log,pdf,synctex.gz*} || true

commit: spikes.pdf
	git add spikes.tex spikes.pdf
	git commit -m 'Progress (auto-commit)'

publish: spikes.pdf
	scp spikes.pdf spikes_me@spikes.me:/home/spikes_me/spikes.me/notes/resume-preview.pdf
	@echo
	@echo Preview published to https://spikes.me/notes/resume-preview.pdf

