# Software list
pdf-flow = chapter-splitter obp-gen-toc
misc-flow = ace-docker epublius obp-gen-mobi obp-gen-xml obp-extract-cit
post-flow = archive_urls_pdf

software = $(pdf-flow) $(misc-flow) $(post-flow)

# Actions lists (clone repository, build docker image, run container)
clone = $(foreach sw,$(software), clone-$(sw))
build = $(foreach sw,$(software), build-$(sw))

run-pdf-flow = $(foreach sw,$(pdf-flow), run-$(sw))
run-misc-flow = $(foreach sw,$(misc-flow), run-$(sw))
run-post-flow = $(foreach sw,$(post-flow), run-$(sw))

.PHONY: all pdf-flow install $(clone) $(build) $(run) clean


all: $(run-pdf-flow) $(run-misc-flow) $(run-post-flow)

pdf-flow: $(run-pdf-flow) $(run-post-flow)

install: $(clone) $(build)
	mkdir -p input output


# Epublius
clone-epublius:
	rm -rf ./epublius
	git clone --depth=1 https://github.com/OpenBookPublishers/epublius.git

build-epublius:
	docker build `pwd`/epublius/ \
		     -t openbookpublishers/epublius

run-epublius: ./output/epublius

./output/epublius: ./input/file.epub ./input/file.json
	mkdir $@
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.epub:/ebook_automation/epub_file.epub \
		   -v `pwd`/input/file.json:/ebook_automation/epub_file.json \
		   -v `pwd`/output/epublius:/ebook_automation/output \
		   -e MATHJAX=False \
		   openbookpublishers/epublius


# Chapter Splitter
clone-chapter-splitter:
	rm -rf ./chapter-splitter
	git clone --depth=1 https://github.com/OpenBookPublishers/chapter-splitter.git

build-chapter-splitter:
	docker build `pwd`/chapter-splitter/ \
		     -t openbookpublishers/chapter-splitter

run-chapter-splitter: ./output/chapter-splitter

./output/chapter-splitter: ./input/file.pdf ./input/file.json
	mkdir $@
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.pdf:/ebook_automation/pdf_file.pdf \
		   -v `pwd`/input/file.json:/ebook_automation/pdf_file.json \
		   -v `pwd`/output/chapter-splitter:/ebook_automation/output \
		   openbookpublishers/chapter-splitter


# OBP Gen TOC
clone-obp-gen-toc:
	rm -rf ./obp-gen-toc
	git clone --depth=1 https://github.com/OpenBookPublishers/obp-gen-toc.git

build-obp-gen-toc:
	docker build `pwd`/obp-gen-toc/ \
		     -t openbookpublishers/obp-gen-toc

run-obp-gen-toc: ./output/obp-gen-toc

./output/obp-gen-toc: ./input/file.xml ./input/file.pdf
	mkdir $@
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.xml:/ebook_automation/file.xml \
		   -v `pwd`/input/file.pdf:/ebook_automation/file.pdf \
		   -v `pwd`/output/obp-gen-toc:/ebook_automation/output \
		   -e TOC_LEVEL=2 \
		   openbookpublishers/obp-gen-toc


# OBP Gen mobi
clone-obp-gen-mobi:
	rm -rf ./obp-gen-mobi
	git clone --depth=1 https://github.com/OpenBookPublishers/obp-gen-mobi.git

build-obp-gen-mobi:
	docker build `pwd`/obp-gen-mobi/ \
		     -t openbookpublishers/obp-gen-mobi

run-obp-gen-mobi: ./output/obp-gen-mobi

./output/obp-gen-mobi: ./input/file.epub
	mkdir $@
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.epub:/ebook_automation/epub_file.epub \
		   -v `pwd`/output/obp-gen-mobi:/ebook_automation/output \
		   openbookpublishers/obp-gen-mobi


# obp-gen-xml
clone-obp-gen-xml:
	rm -rf ./obp-gen-xml
	git clone --depth=1 https://github.com/OpenBookPublishers/obp-gen-xml.git

build-obp-gen-xml:
	docker build `pwd`/obp-gen-xml/ \
		     -t openbookpublishers/obp-gen-xml

run-obp-gen-xml: ./output/obp-gen-xml

./output/obp-gen-xml: ./input/file.epub ./input/file.xml
	mkdir $@
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/input/file.epub:/ebook_automation/epub_file.epub \
		   -v `pwd`/input/file.xml:/ebook_automation/epub_file.xml \
		   -v `pwd`/output/obp-gen-xml:/ebook_automation/output \
		   openbookpublishers/obp-gen-xml


# obp-extract-cit
clone-obp-extract-cit:
	rm -rf ./obp-extract-cit
	git clone --depth=1 https://github.com/OpenBookPublishers/obp-extract-cit.git

build-obp-extract-cit:
	docker build `pwd`/obp-extract-cit/ \
		     -t openbookpublishers/obp-extract-cit

run-obp-extract-cit: ./output/obp-extract-cit

./output/obp-extract-cit: ./output/obp-gen-xml/epub_file.xml.zip ./input/file.xml
	mkdir $@
	docker run --rm \
		   --user `id -u`:`id -g` \
		   -v `pwd`/output/obp-gen-xml/epub_file.xml.zip:/ebook_automation/file.xml.zip \
		   -v `pwd`/input/file.xml:/ebook_automation/file.xml \
		   -v `pwd`/output/obp-extract-cit:/ebook_automation/output \
		   openbookpublishers/obp-extract-cit


# ace-docker
clone-ace-docker:
	rm -rf ./ace-docker
	git clone -b chown-output https://github.com/OpenBookPublishers/ace-docker.git

build-ace-docker:
	docker build `pwd`/ace-docker/ \
		     -t openbookpublishers/ace-docker

run-ace-docker: ./output/ace-docker

./output/ace-docker: ./input/file.epub
	mkdir $@
	docker run --rm \
                   -v `pwd`/input/file.epub:/ebook/file.epub \
                   -v `pwd`/output/ace-docker:/ebook/output \
                   -e UID=`id -u` \
                   -e GID=`id -g` \
                   openbookpublishers/ace-docker

# archive_urls_pdf
clone-archive_urls_pdf:
	rm -rf ./archive_urls_pdf
	git clone --depth=1 https://github.com/OpenBookPublishers/archive_urls_pdf.git

build-archive_urls_pdf:
	docker build `pwd`/archive_urls_pdf/ \
		     -t openbookpublishers/archive_urls_pdf

run-archive_urls_pdf: ./output/archive_urls_pdf

./output/archive_urls_pdf: ./input/file.pdf
	mkdir $@
	docker run --rm \
		   -v `pwd`/input/file.pdf:/archive_urls_pdf/file.pdf \
		   openbookpublishers/archive_urls_pdf


# Utils
clean:
	rm -rf ./input/* ./output/*
