
.PHONY:all
all:
	pdflatex report.tex
	bibtex report
	pdflatex report.tex
	pdflatex report.tex

clean:
	rm -f *.log *.bbl *.blg *.aux

