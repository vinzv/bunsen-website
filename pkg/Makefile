SHELL=/bin/bash

# Pandoc site template
TEMPLATE=templates/default.html5

# Determine HTML targets
TARGETS=$(patsubst %.mkd,%.html,$(wildcard src/*.mkd))

# Files to deploy
ASSETS=$(TARGETS) src/img src/css src/robots.txt src/templates src/js

# Main navigation and page header
NAVIGATION_HTML=src/include/navigation.html
COPYRIGHT=src/include/footer_copyright.html

# CSS include path, relative to pageroot
STYLE=css/plain-repo.css

# Pandoc arguments
ARGV=--email-obfuscation=javascript \
		 --smart\
		 --toc\
		 --template=$(TEMPLATE) \
		 -f markdown+footnotes+fenced_code_attributes \
		 -s \
		 -c $(STYLE) \
		 --highlight-style monochrome \
		 --include-before-body=$(NAVIGATION_HTML)

# Pandoc variables set for all documents; expanded at build time!
PANDOC_VARS=-M pagetitle="$($<.title)" \
						-M filename="$(@F)" \
						-M url-prefix="$(URL_PREFIX)" \
						-M opengraph-image="$(OPENGRAPH_IMG)" \
						-M opengraph-description="$(OPENGRPAH_DESCRIPTION)" \
						-M dns-prefetch=1

# Checkout directory which will be uploaded
DESTDIR=dst

# Page root
URL_PREFIX=http://pkg.bunsenlabs.org

OPENGRAPH_IMG=img/opengraph-flame.png

# Warning: Is global on the repo page
OPENGRPAH_DESCRIPTION=BunsenLabs Linux APT Repository

# Provides page titles
include config/pagetitles.mk

### UTILITY TARGETS ###

.PHONY: rebuild checkout all clean deploy

rebuild: clean checkout

checkout: all
	@rsync -au --human-readable $(ASSETS) $(DESTDIR)

all: $(TARGETS) 

clean:
	rm -f src/*.html
	rm -fr dst/*

deploy: rebuild
	rsync -auL --progress --human-readable --chmod=D0755,F0644 --exclude='google8a3d1d52c066d25a.html' dst/ bunsen@kernel:/srv/pkg.bunsenlabs.org/

### PAGE BUILD TARGETS ###

%.html: %.mkd $(TEMPLATE)
	$(info -----)
	pandoc $(ARGV) $(PANDOC_VARS) -o $@ $<
	./postproc $@

src/repoidx.html: src/repoidx.mkd src/js/bl-repo-index.js $(TEMPLATE)
	pandoc $(ARGV) -A src/include/repoidx_after.html $(PANDOC_VARS) --toc -o $@ $<
	./postproc $@

src/repohdr.html: src/repohdr.mkd
	cp $< $@
