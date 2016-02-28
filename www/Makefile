# vim: set expandtab

# Makefile for the BunsenLabs website
# Written by 2ion <dev@2ion.de>

SHELL=/bin/bash
TIMESTAMP = $(shell date +%Y-%m-%d-%H-%M)

SEP = $(shell printf "\033[38;5;087m=============================================================================\033[0m")
LOG_STATUS = @printf "\033[1;32m%*s\033[0m %s\n" 10 "$(1)" "$(2)"

# Pandoc site template
TEMPLATE := templates/default.html5

FOOTER_GLOBAL := src/include/footer_copyright.html
FOOTER_SPONSOR := src/include/footer_sponsor.html

FAVICON_SOURCE = src/img/bl-flame-48px.svg
FAVICON_SIZES = 128 256
FAVICON_HEADER = src/include/favicons.html

# Determine MKD<>HTML targets
TARGETS := $(patsubst %.mkd,%.html,$(wildcard src/*.mkd))

# Images with associated thumbnails
THUMB_DIR = src/img/frontpage-gallery/thumbs
THUMB_OBJ = $(subst frontpage-gallery/,frontpage-gallery/thumbs/,$(patsubst %.png,%.thumb.jpg,$(wildcard src/img/frontpage-gallery/*.png)))
THUMB_DIM = 960x

THUMB_JPEG_QUALITY = 75
THUMB_FULLSIZE_JPEG_QUALITY = 90

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
			-f markdown+footnotes+fenced_code_attributes+auto_identifiers+definition_lists \
			-s \
			-c $(STYLE) \
			--highlight-style monochrome \
			--include-before-body=$(NAVIGATION_HTML) \
			--include-after-body=$(FOOTER_GLOBAL)

# Pandoc variables set for all documents; expanded at build time!
PANDOC_VARS=-M pagetitle="$($<.title)" \
						-M filename="$(@F)" \
						-M url-prefix="$(OPENGRAPH_URL_PREFIX)" \
						-M favicons="$(shell cat $(FAVICON_HEADER))" \
						-M opengraph-image="$(OPENGRAPH_IMG)" \
						-M opengraph-description="$($<.description)" \
						-M dns-prefetch=1

# Checkout directory which will be uploaded
DESTDIR=dst

# Opengraph
OPENGRAPH_URL_PREFIX=https://www.bunsenlabs.org
OPENGRAPH_IMG=img/opengraph-flame.png

# Per-page pagetitles and descriptions
include config/pagetitles.mk
include config/pagedescriptions.mk

# Templating system
include config/variables.mk

### UTILITY TARGETS ###

.PHONY: rebuild checkout all clean deploy variables

rebuild: checkout
	$(call LOG_STATUS,REBUILD)

checkout: all
	$(call LOG_STATUS,CHECKOUT)
	@mkdir -p $(DESTDIR)
	@rsync -auL $(ASSETS) $(DESTDIR)

all: favicon-series $(TARGETS) thumbnails variables

thumbnails: $(THUMB_DIR) $(THUMB_OBJ)

$(THUMB_DIR):
	@mkdir -p $@

$(THUMB_GUIDE_DIR):
	@mkdir -p $@

clean:
	$(call LOG_STATUS,CLEAN)
	@rm -f src/*.html src/img/frontpage-gallery/thumbs/* src/img/frontpage-gallery/*.jpg
	@rm -f src/img/installguide/*.jpg src/img/installguide/thumbs/*
	@rm -f src/img/favicon*.png
	@rm -fr dst/*

deploy: rebuild
	$(call LOG_STATUS,DEPLOY,BUNSEN)
	@-rsync -au --progress --human-readable --delete --exclude=private --chmod=D0755,F0644 dst/ bunsen@bunsen:/srv/www.bunsenlabs.org/

deploy-kelaino: rebuild
	$(call LOG_STATUS,DEPLOY,KELAINO)
	@-rsync -au --progress --human-readable --delete --exclude=private --chmod=D0755,F0644 dst/ root@kelaino:/srv/kelaino.bunsenlabs.org/www/

### PAGE BUILD TARGETS ###

%.html: %.mkd $(TEMPLATE)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) -o $@ $<
	@./postproc $@

src/index.html: src/index.mkd $(TEMPLATE)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) \
		-H src/include/index_header.html \
		-A src/include/index_after.html \
		-A src/include/footer_sponsor.html \
		-o $@ $<
	@./postproc $@

src/resources.html: src/resources.mkd $(TEMPLATE)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) \
		--toc \
		-o $@ $<
	@./postproc $@

variables: src/installation.html src/index.html
	$(call LOG_STATUS,VARIABLES,$(notdir $^))
	$(foreach VAR,$(RELEASE_SUBST),$(shell sed -i 's^@@$(VAR)@@^$($(VAR))^' $^ ))

# For the gitlog page, include a header with CSS/JS links and a footer
# to post-load the query JS code.
src/gitlog.html: src/gitlog.mkd $(TEMPLATE)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) \
		-A src/include/gitlog_afterbody.html \
		-H src/include/gitlog_header.html \
		-o $@ $<
	@./postproc $@

# Generate thumbnails for the frontpage gallery. It is possible that
# with different resize operators, imagemagick produces even more high-quality
# preview images. Documentation: http://www.imagemagick.org/Usage/resize/
$(THUMB_DIR)/%.thumb.jpg: $(THUMB_DIR)/../%.png
	$(call LOG_STATUS,THUMBNAIL,$(notdir $@))
	@convert $< -adaptive-resize $(THUMB_DIM) -quality $(THUMB_JPEG_QUALITY) $@
	@convert $< -quality $(THUMB_FULLSIZE_JPEG_QUALITY) $(<:.png=.jpg)

.PHONY: favicon-series
favicon-series: $(FAVICON_SOURCE)
	$(call LOG_STATUS,FAVICON,$(FAVICON_SIZES))
	@./mkfavicons $< $(FAVICON_HEADER) $(FAVICON_SIZES) &>/dev/null

.PHONY: archive-revision
archive-revision: rebuild
	$(call LOG_STATUS,ARCHIVE,www-$(TIMESTAMP).tar.xz)
	@mkdir -p ./archive/
	@tar -cJf ./archive/www-$(TIMESTAMP).tar.xz ./dst/
