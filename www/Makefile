# vim: set expandtab

# Build system for the www.bunsenlabs.org website
# Copyright (C) 2015-2016 Jens John <dev@2ion.de>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

include config/pagedescriptions.mk
include config/pagetitles.mk
include config/variables.mk

SHELL                       = /bin/bash
TIMESTAMP                   = $(shell date +%Y-%m-%d-%H-%M)
LOG_STATUS                  = @printf "\033[1;32m%*s\033[0m %s\n" 10 "$(1)" "$(2)"
DESTDIR                     = dst

FOOTER_GLOBAL               = include/footer/copyright.html
FOOTER_SPONSOR              = include/footer/sponsor.html
NAVIGATION_HTML             = include/navigation.html
STYLE                       = css/plain.css
ALTERNATE_STYLES						= css/plain-mercury.css
TEMPLATE                    = templates/default.html5
OPENGRAPH_URL_PREFIX        = https://www.bunsenlabs.org
OPENGRAPH_IMG               = img/opengraph-flame.png

FAVICON_HEADER              = include/favicons.html
FAVICON_SIZES               = 256 180 128
FAVICON_SOURCE              = src/img/bl-flame-48px.svg

GALLERY_CONFIG              = config/gallery.yaml
GALLERY_HEADER              = include/index/gallery.html
GALLERY_NOSCRIPT_HEADER     = include/index/gallery_noscript.html

DONATION_REPORT             = include/donation-report.mkd
DONATION_INTERMEDIATE       = src/donations.intermediate.mkd
DONATION_DATA               = config/donations.csv
DONATION_REPORT_CONFIG			= config/donations.yaml

TARGETS                     = $(patsubst %.mkd,%.html,$(wildcard src/*.mkd))
ASSETS                      = $(TARGETS) src/js src/img src/css src/robots.txt

THUMB_DIM                   = 640x
THUMB_DIR                   = src/img/frontpage-gallery/thumbs
THUMB_FULLSIZE_JPEG_QUALITY = 90
THUMB_JPEG_QUALITY          = 75
THUMB_OBJ                   = $(subst frontpage-gallery/,frontpage-gallery/thumbs/,$(patsubst %.png,%.thumb.jpg,$(wildcard src/img/frontpage-gallery/*.png)))

ARGV=                                                                            \
	--email-obfuscation=javascript                                                 \
	--smart                                                                        \
	--template=$(TEMPLATE)                                                         \
	-f markdown+footnotes+fenced_code_attributes+auto_identifiers+definition_lists \
	-s                                                                             \
	-c $(STYLE)                                                                    \
	--highlight-style monochrome                                                   \
	--include-before-body=$(NAVIGATION_HTML)                                       \
	--include-after-body=$(FOOTER_GLOBAL)                                          \
	-H $(FAVICON_HEADER)

PANDOC_VARS=                                                                     \
	-M pagetitle="$($<.title)"                                                     \
	-M filename="$(@F)"                                                            \
	-M url-prefix="$(OPENGRAPH_URL_PREFIX)"                                        \
	-M opengraph-image="$(OPENGRAPH_IMG)"                                          \
	-M opengraph-description="$($<.description)"                                   \
	-M dns-prefetch=1                                                              \
	-M alternate-css="$(ALTERNATE_STYLES)"

###############################################################################

.PHONY:            \
	all              \
	archive-revision \
	build            \
	checkout         \
	clean            \
	deploy-kelaino   \
	deploy           \
	html-pages       \
	minify           \
	thumbnails

build: minify

checkout: all
	$(call LOG_STATUS,CHECKOUT)
	@mkdir -p $(DESTDIR)
	@rsync -auL --exclude=$(DONATION_INTERMEDIATE) $(ASSETS) $(DESTDIR)

all: html-pages thumbnails variables

html-pages: $(TARGETS)

thumbnails: $(THUMB_DIR) $(THUMB_OBJ)

$(THUMB_DIR):
	@mkdir -p $@

clean:
	$(call LOG_STATUS,CLEAN)
	@rm -f src/*.html src/img/frontpage-gallery/thumbs/* src/img/frontpage-gallery/*.jpg
	@rm -f src/img/installguide/*.jpg src/img/installguide/thumbs/*
	@rm -f src/img/favicon*.png
	@rm -f $(FAVICON_HEADER)
	@rm -f $(GALLERY_NOSCRIPT_HEADER)
	@rm -f $(GALLERY_HEADER)
	@rm -f $(DONATION_REPORT) $(DONATION_INTERMEDIATE)
	@rm -fr dst/*

deploy: build
	$(call LOG_STATUS,DEPLOY,BUNSEN)
	@-rsync -au --progress --human-readable --delete --exclude=private --chmod=D0755,F0644 dst/ bunsen@bunsen:/srv/www.bunsenlabs.org/

deploy-kelaino: build
	$(call LOG_STATUS,DEPLOY,KELAINO)
	@-rsync -au --progress --human-readable --delete --exclude=private --chmod=D0755,F0644 dst/ root@kelaino:/srv/kelaino.bunsenlabs.org/www/

$(FAVICON_HEADER): $(FAVICON_SOURCE)
	$(call LOG_STATUS,FAVICON,$(FAVICON_SIZES))
	@./libexec/mkfavicons $< $(FAVICON_HEADER) $(FAVICON_SIZES) &>/dev/null

archive-revision: checkout
	$(call LOG_STATUS,ARCHIVE,www-$(TIMESTAMP).tar.xz)
	@mkdir -p ./archive/
	@tar -cJf ./archive/www-$(TIMESTAMP).tar.xz ./dst/

variables: src/installation.html src/index.html
	$(call LOG_STATUS,VARIABLES,$(notdir $^))
	$(foreach VAR,$(RELEASE_SUBST),$(shell sed -i 's^@@$(VAR)@@^$($(VAR))^' $^ ))

minify: checkout
	$(call LOG_STATUS,MINIFY)
	@find "$(DESTDIR)"/ -type f \( -name '*.css' -o -name '*.js' \) -print0 \
		| xargs -0 -P 4 -n 1 -- ./libexec/compress

###############################################################################

%.html: %.mkd $(TEMPLATE) $(FAVICON_HEADER)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) -o $@ $<
	@./libexec/postproc $@

src/index.html: src/index.mkd $(TEMPLATE) $(wildcard src/include/index*.html) $(FAVICON_HEADER) $(GALLERY_HEADER) $(GALLERY_NOSCRIPT_HEADER) $(FOOTER_SPONSOR)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) \
		-H include/index/header.html \
		-A include/index/after.html \
		-A include/footer/sponsor.html \
		-o $@ $<
	@./libexec/postproc $@

src/donations.html: $(DONATION_INTERMEDIATE)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) \
		-H include/head/norobots.html \
		-o $@ $<
	@./libexec/postproc $@

$(DONATION_INTERMEDIATE): src/donations.mkd $(DONATION_REPORT)
	@cat $^ > $@

$(DONATION_REPORT): $(DONATION_DATA) ./libexec/donation-report $(DONATION_REPORT_CONFIG)
	$(call LOG_STATUS,REPORT,$(notdir $@))
	@./libexec/donation-report $< $(DONATION_REPORT_CONFIG) > $@

$(GALLERY_HEADER): $(GALLERY_CONFIG)
	$(call LOG_STATUS,GALLERY,$(notdir $@))
	@./libexec/gallery $< > $@

$(GALLERY_NOSCRIPT_HEADER): $(GALLERY_HEADER)
	$(call LOG_STATUS,GALLERY,$(notdir $@))
	@./libexec/noscript-gallery $< > $@

src/resources.html: src/resources.mkd $(TEMPLATE) $(FAVICON_HEADER)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) \
		--toc \
		-o $@ $<
	@./libexec/postproc $@

# For the gitlog page, include a header with CSS/JS links and a footer
# to post-load the query JS code.
src/gitlog.html: src/gitlog.mkd $(wildcard src/include/gitlog*) $(TEMPLATE) $(FAVICON_HEADER)
	$(call LOG_STATUS,PANDOC,$(notdir $@))
	@pandoc $(ARGV) $(PANDOC_VARS) \
		-A include/gitlog/after.html \
		-H include/gitlog/header.html \
		-o $@ $<
	@./libexec/postproc $@

# Generate thumbnails for the frontpage gallery. It is possible that
# with different resize operators, imagemagick produces even more high-quality
# preview images. Documentation: http://www.imagemagick.org/Usage/resize/
$(THUMB_DIR)/%.thumb.jpg: $(THUMB_DIR)/../%.png
	$(call LOG_STATUS,THUMBNAIL,$(notdir $@))
	@convert $< -adaptive-resize $(THUMB_DIM) -quality $(THUMB_JPEG_QUALITY) $@
	@convert $< -quality $(THUMB_FULLSIZE_JPEG_QUALITY) $(<:.png=.jpg)

