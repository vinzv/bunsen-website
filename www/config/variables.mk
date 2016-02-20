#
# TEMPLATING SYSTEM
#

RELEASE_CODENAME = Hydrogen
RELEASE_CODENAME_LOWERCASE=$(shell echo $(RELEASE_CODENAME) | tr '[A-Z]' '[a-z]')
RELEASE_VERSION = rc2
RELEASE_DATE = Feburary 16, 2016

DDL_BASE_URL = https://ddl.bunsenlabs.org
ISO_BASE_NAME = bl-$(RELEASE_CODENAME)-$(RELEASE_VERSION)

ISO_32 = $(ISO_BASE_NAME)-i386.iso
ISO_64 = $(ISO_BASE_NAME)-amd64.iso

ISO_32_SIZE = 879M
ISO_64_SIZE = 825M

DDL_URL_32 = $(DDL_BASE_URL)/$(ISO_32)
DDL_URL_32M = https://kelaino.bunsenlabs.org/ddl/$(ISO_32)
DDL_URL_64 = $(DDL_BASE_URL)/$(ISO_64)
DDL_URL_64M = https://kelaino.bunsenlabs.org/ddl/$(ISO_64)

SHA256SUMS_URL_32 = $(DDL_URL_32).sha256sum.txt
SHA256SUMS_URL_64 = $(DDL_URL_64).sha256sum.txt

TORRENT_URL_32 = $(DDL_URL_32).torrent
TORRENT_URL_64 = $(DDL_URL_64).torrent

# Make sure to escape '&' in the URL because it's used as input to sed
MAGNET_32_RAW = "magnet:?xt=urn:btih:539cd51b5ec43e4603dc0e3512b49272d179c734&dn=bl-Hydrogen-alpha2-i386.iso&tr=udp%3A%2F%2Ftracker.bunsenlabs.org%3A6969&tr=udp%3A%2F%2Fopen.demonii.com%3A1337&ws=http%3A%2F%2Fddl.bunsenlabs.org%2Fbl-Hydrogen-alpha2-i386.iso"
MAGNET_64_RAW = "magnet:?xt=urn:btih:dace10f7bf20fcfe8b43538cfa1fd98442e6d716&dn=bl-Hydrogen-alpha2-amd64.iso&tr=udp%3A%2F%2Ftracker.bunsenlabs.org%3A6969&tr=udp%3A%2F%2Fopen.demonii.com%3A1337&ws=http%3A%2F%2Fddl.bunsenlabs.org%2Fbl-Hydrogen-alpha2-amd64.iso"
TORRENT_MAGNET_LINK_32 = $(shell echo "$(MAGNET_32_RAW)" | sed 's/&/\\&/g')
TORRENT_MAGNET_LINK_64 = $(shell echo "$(MAGNET_32_RAW)" | sed 's/&/\\&/g')

GALLERY := $(shell cat src/include/index_gallery.html)

### REFERENCED IN Makefile ###

RELEASE_SUBST :=\
	RELEASE_CODENAME \
	RELEASE_CODENAME_LOWERCASE \
	RELEASE_VERSION \
	DDL_URL_32 \
	DDL_URL_32M \
	DDL_URL_64 \
	DDL_URL_64M \
	SHA256SUMS_URL_32 \
	SHA256SUMS_URL_64 \
	TORRENT_URL_32 \
	TORRENT_URL_64 \
	TORRENT_MAGNET_LINK_32 \
	TORRENT_MAGNET_LINK_64 \
	ISO_32 ISO_64 \
	ISO_32_SIZE \
	ISO_64_SIZE \
	GALLERY \
	RELEASE_DATE
