# vim: set expandtab

# Makefile for the BunsenLabs website
# Written by 2ion <dev@2ion.de>

SHELL=/bin/bash

SEP := ---------------------------------------------------------------

# Pandoc site template
TEMPLATE := templates/default.html5

# Determine MKD<>HTML targets
TARGETS := $(patsubst %.mkd,%.html,$(wildcard src/*.mkd))

# Images with associated thumbnails
THUMB_DIR = src/img/frontpage-gallery/thumbs
THUMB_OBJ = $(subst frontpage-gallery/,frontpage-gallery/thumbs/,$(patsubst %.png,%.thumb.jpg,$(wildcard src/img/frontpage-gallery/*.png)))
THUMB_DIM = 638x

# Files to deploy
ASSETS=$(TARGETS) src/js src/img src/css src/robots.txt

# Main navigation and page header
NAVIGATION_HTML=src/include/navigation.html

# CSS include path, relative to pageroot
STYLE=css/plain.css

# Pandoc arguments
ARGV=	--email-obfuscation=javascript \
			--smart \
			--template=$(TEMPLATE) \
			-f markdown+footnotes+fenced_code_attributes+auto_identifiers \
			-s \
			-c $(STYLE) \
			--highlight-style monochrome \
			--include-before-body=$(NAVIGATION_HTML)

# Pandoc variables set for all documents; expanded at build time!
PANDOC_VARS=-M pagetitle="$($<.title)" \
						-M filename="$(@F)" \
						-M url-prefix="$(URL_PREFIX)" \
						-M opengraph-image="$(OPENGRAPH_IMG)" \
						-M opengraph-description="$($<.description)"

# Checkout directory which will be uploaded
DESTDIR=dst

# Page root
URL_PREFIX=http://bunsen-www.2ion.eu

# Thumbnail image, og:image
OPENGRAPH_IMG=img/opengraph-flame.png

# Per-page pagetitles and descriptions
include config/pagetitles.mk
include config/pagedescriptions.mk

### UTILITY TARGETS ###

.PHONY: rebuild checkout all clean deploy

rebuild: clean checkout
	$(info $(SEP))
	$(info  $@)

checkout: all
	$(info $(SEP))
	$(info  $@)
	mkdir -p $(DESTDIR)
	rsync -au $(ASSETS) $(DESTDIR)

all: $(TARGETS) thumbnails

thumbnails: $(THUMB_OBJ)
	@mkdir -p $(THUMB_DIR)

clean:
	$(info $(SEP))
	$(info  $@)
	rm -f src/*.html src/img/frontpage-gallery/thumbs/*
	rm -fr dst/*

deploy: rebuild
	$(info $(SEP))
	$(info  $@)
	rsync -au --progress --human-readable --delete --chmod=D0755,F0644 dst/ bunsen@bunsenpkg:/srv/www.bunsenlabs.org/

### PAGE BUILD TARGETS ###

%.html: %.mkd $(TEMPLATE)
	$(info $(SEP))
	$(info  Using common build target for $< )
	pandoc $(ARGV) $(PANDOC_VARS) -o $@ $<
	./postproc $@

src/index.html: src/index.mkd $(TEMPLATE)
	$(info $(SEP))
	$(info  Using specialized build target for $< 												)
	pandoc $(ARGV) $(PANDOC_VARS) \
		-H src/include/index_header.html \
		-o $@ $<
	./postproc $@

src/resources.html: src/resources.mkd $(TEMPLATE)
	$(info $(SEP))
	$(info  Using specialized build target for $< )
	pandoc $(ARGV) $(PANDOC_VARS) \
		--toc \
		-o $@ $<
	./postproc $@

# For the gitlog page, include a header with CSS/JS links and a footer
# to post-load the query JS code.
src/gitlog.html: src/gitlog.mkd $(TEMPLATE)
	$(info $(SEP))
	$(info  Using specialized build target for $< )
	pandoc $(ARGV) $(PANDOC_VARS) \
		-A src/include/gitlog_afterbody.html \
		-H src/include/gitlog_header.html \
		-o $@ $<
	./postproc $@

# Generate thumbnails for the frontpage gallery. It is possible that
# with different resize operators, imagemagick produces even more high-quality
# preview images. Documentation: http://www.imagemagick.org/Usage/resize/
$(THUMB_DIR)/%.thumb.jpg: $(THUMB_DIR)/../%.png
	$(info $(SEP))
	$(info  Using thumbnail build target for $<)
	convert $< -adaptive-resize $(THUMB_DIM) -quality 90 $@
	convert $< -quality 90 $(<:.png=.jpg)
