# Software list
software = epublius chapter-splitter obp-gen-toc

# Actions lists (clone repository, build docker image, run container)
clone = $(foreach sw,$(software), clone-$(sw))
build = $(foreach sw,$(software), build-$(sw))
run = $(foreach sw,$(software), run-$(sw))


.PHONY: run-all install $(clone) $(build) $(run) clean


run-all: $(run)
	echo "Done"

install: $(clone) $(build)
	mkdir -p input output


# Epublius
clone-epublius:
	rm -rf ./epublius
	git clone --depth=1 https://github.com/OpenBookPublishers/epublius.git

build-epublius:
	docker build `pwd`/epublius/ \
		     -t openbookpublishers/epublius

run-epublius: ./input/file.epub ./input/file.json
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.epub:/ebook_automation/epub_file.epub \
		   -v `pwd`/input/file.json:/ebook_automation/epub_file.json \
		   -v `pwd`/output:/ebook_automation/output \
		   openbookpublishers/epublius


# Chapter Splitter
clone-chapter-splitter:
	rm -rf ./chapter-splitter
	git clone --depth=1 https://github.com/OpenBookPublishers/chapter-splitter.git

build-chapter-splitter:
	docker build `pwd`/chapter-splitter/ \
		     -t openbookpublishers/chapter-splitter

run-chapter-splitter:  ./input/file.pdf ./input/file.json
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.pdf:/ebook_automation/pdf_file.pdf \
		   -v `pwd`/input/file.json:/ebook_automation/pdf_file.json \
		   -v `pwd`/output:/ebook_automation/output \
		   openbookpublishers/chapter-splitter

# OBP Gen TOC
clone-obp-gen-toc:
	rm -rf ./obp-gen-toc
	git clone --depth=1 https://github.com/OpenBookPublishers/obp-gen-toc.git

build-obp-gen-toc:
	docker build `pwd`/obp-gen-toc/ \
		     -t openbookpublishers/obp-gen-toc

run-obp-gen-toc:  ./input/file.xml ./input/file.pdf
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.xml:/ebook_automation/file.xml \
		   -v `pwd`/input/file.pdf:/ebook_automation/file.pdf \
		   -v `pwd`/output:/ebook_automation/output \
		   -e TOC_LEVEL=2 \
		   openbookpublishers/obp-gen-toc

# Utils
clean:
	rm -rf ./input/* ./output/*
