#
# DDL/Torrent links and filenames for the release links in
# installation.mkd.
#

RELEASE_CODENAME = Hydrogen
RELEASE_VERSION = rc1

DDL_BASE_URL = http://ddl.bunsenlabs.org
ISO_BASE_NAME = bl-$(RELEASE_CODENAME)-$(RELEASE_VERSION)

ISO_32 = $(ISO_BASE_NAME)-i386.iso
ISO_64 = $(ISO_BASE_NAME)-amd64.iso

ISO_32_SIZE = 999M
ISO_64_SIZE = 999M

DDL_URL_32 = $(DDL_BASE_URL)/$(ISO_32)
DDL_URL_64 = $(DDL_BASE_URL)/$(ISO_64)

SHA256SUMS_URL_32 = $(DDL_URL_32).sha256sum.txt
SHA256SUMS_URL_64 = $(DDL_URL_64).sha256sum.txt

TORRENT_URL_32 = $(DDL_URL_32).torrent
TORRENT_URL_64 = $(DDL_URL_64).torrent

# Make sure to escape '&' in the URL because it's used as input to sed
MAGNET_32_RAW = magnet:?xt=urn:btih:828e86180150213c10677495565baef6b232dbdd&dn=archlinux-2015.08.01-dual.iso&tr=udp://tracker.archlinux.org:6969&tr=http://tracker.archlinux.org:6969/announce
MAGNET_64_RAW = magnet:?xt=urn:btih:828e86180150213c10677495565baef6b232dbdd&dn=archlinux-2015.08.01-dual.iso&tr=udp://tracker.archlinux.org:6969&tr=http://tracker.archlinux.org:6969/announce
TORRENT_MAGNET_LINK_32 = $(shell echo "$(MAGNET_32_RAW)" | sed 's/&/\\&/g')
TORRENT_MAGNET_LINK_64 = $(shell echo "$(MAGNET_32_RAW)" | sed 's/&/\\&/g')

### REFERENCED IN Makefile ###

RELEASE_SUBST :=\
	RELEASE_CODENAME \
	RELEASE_VERSION \
	DDL_URL_32 \
	DDL_URL_64 \
	SHA256SUMS_URL_32 \
	SHA256SUMS_URL_64 \
	TORRENT_URL_32 \
	TORRENT_URL_64 \
	TORRENT_MAGNET_LINK_32 \
	TORRENT_MAGNET_LINK_64 \
	ISO_32 ISO_64 \
	ISO_32_SIZE \
	ISO_64_SIZE
