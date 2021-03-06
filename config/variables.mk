#
# TEMPLATING SYSTEM
#

RELEASE_CODENAME           = Deuterium
RELEASE_CODENAME_LOWERCASE = $(shell echo $(RELEASE_CODENAME) | tr '[A-Z]' '[a-z]')
RELEASE_VERSION            =
RELEASE_DATE               = April 29, 2017
RELEASE_ANNOUNCEMENT_URL   = https://forums.bunsenlabs.org/viewtopic.php?id=3685

DDL_BASE_URL               = https://ddl.bunsenlabs.org/ddl
ISO_BASE_NAME              = bl-$(RELEASE_CODENAME)$(RELEASE_VERSION)

ISO_32                     = bl-Deuterium-i386_20170429.iso
ISO_32CD                   = bl-Deuterium-i386+NonPAE_20170429.iso
ISO_64                     = bl-Deuterium-amd64_20170429.iso

ISO_32_SIZE                = 879M
ISO_32CD_SIZE              = 667M
ISO_64_SIZE                = 855M

DDL_URL_32                 = $(DDL_BASE_URL)/$(ISO_32)
DDL_URL_32M                = https://kelaino.bunsenlabs.org/ddl/$(ISO_32)
DDL_URL_32CD               = $(DDL_BASE_URL)/$(ISO_32CD)
DDL_URL_64                 = $(DDL_BASE_URL)/$(ISO_64)
DDL_URL_64M                = https://kelaino.bunsenlabs.org/ddl/$(ISO_64)

SHA256SUMS = $(DDL_BASE_URL)/bl-Deuterium_20170429.sha256sums.txt
SHA256SUMS_URL_32          = $(SHA256SUMS)
SHA256SUMS_URL_32CD        = $(SHA256SUMS)
SHA256SUMS_URL_64          = $(SHA256SUMS)

SIG_URL_32                 = $(DDL_URL_32).sig
SIG_URL_32CD               = $(DDL_URL_32CD).sig
SIG_URL_64                 = $(DDL_URL_64).sig

TORRENT_URL_32             = $(DDL_URL_32).torrent
TORRENT_URL_32CD           = $(DDL_URL_32CD).torrent
TORRENT_URL_64             = $(DDL_URL_64).torrent

GALLERY = $(shell cat include/index/gallery.html|sed 's/^\s*//'|tr -d '\n')
GALLERY_NOSCRIPT = $(shell cat include/index/gallery_noscript.html|sed 's/^\s*//'|tr -d '\n')

NEWS = $(shell cat include/news.html)

### REFERENCED IN Makefile ###

RELEASE_SUBST :=             \
	DDL_URL_32                 \
	DDL_URL_32M                \
	DDL_URL_32CD               \
	DDL_URL_64                 \
	DDL_URL_64M                \
	GALLERY                    \
	GALLERY_NOSCRIPT           \
	ISO_32 ISO_64 ISO_32CD     \
	ISO_32_SIZE                \
	ISO_32CD_SIZE              \
	ISO_64_SIZE                \
	RELEASE_ANNOUNCEMENT_URL   \
	RELEASE_CODENAME           \
	RELEASE_CODENAME_LOWERCASE \
	RELEASE_DATE               \
	RELEASE_VERSION            \
	SHA256SUMS_URL_32          \
	SHA256SUMS_URL_32CD        \
	SHA256SUMS_URL_64          \
	SIG_URL_32                 \
	SIG_URL_32CD               \
	SIG_URL_64                 \
	TORRENT_URL_32             \
	TORRENT_URL_32CD           \
	TORRENT_URL_64						 \
	NEWS
