# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

BRAVE_PN="${PN/-bin/}"

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW
"

inherit chromium-2 xdg-utils unpacker

DESCRIPTION="Dissenter Web Browser"
HOMEPAGE="https://dissenter.com"
SRC_URI="https://apps.gab.com/application/5d3f93a29dd49a5b1d9fc27f/resource/5dbdab9853c1056bd98c3525/content"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome-keyring"

DEPEND="gnome-base/gconf:2"
RDEPEND="
	${DEPEND}
	dev-libs/libpthread-stubs
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libxshmfence
	x11-libs/libXxf86vm
	x11-libs/libXScrnSaver
	x11-libs/libXrandr
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXinerama
	dev-libs/glib
	dev-libs/nss
	dev-libs/nspr
	net-print/cups
	sys-apps/dbus
	dev-libs/expat
	media-libs/alsa-lib
	x11-libs/pango
	x11-libs/cairo
	dev-libs/gobject-introspection
	dev-libs/atk
	app-accessibility/at-spi2-core
	app-accessibility/at-spi2-atk
	x11-libs/gtk+
	x11-libs/gdk-pixbuf
	virtual/libffi
	dev-libs/libpcre
	net-libs/gnutls
	sys-libs/zlib
	dev-libs/fribidi
	media-libs/harfbuzz
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/pixman
	>=media-libs/libpng-1.6.34
	media-libs/libepoxy
	dev-libs/libbsd
	dev-libs/libunistring
	dev-libs/libtasn1
	dev-libs/nettle
	dev-libs/gmp
	net-dns/libidn2
	media-gfx/graphite2
	app-arch/bzip2
"

QA_PREBUILT="*"

S=${WORKDIR}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	pushd "${S}/opt/${PN}.com/${PN}/locales" > /dev/null || die
		chromium_remove_language_paks
	popd > /dev/null || die

	default
}

src_install() {
	shopt -s extglob
	
	declare DISSENTER_HOME="${S}"/opt/"${PN}".com/"${PN}"
	declare DISSENTER_DOC="${S}"/usr/share/doc/"${PN}"-browser
	declare DISSENTER_MAN="${S}"/usr/share/man/man1
	
	gunzip "${DISSENTER_DOC}"/changelog.gz
	gunzip "${DISSENTER_MAN}"/"${PN}"-browser-stable.1.gz

	dosym "${DISSENTER_HOME}"/"${PN}" /usr/bin/"${PN}" || die

	newicon -s 16 "${DISSENTER_HOME}"/product_logo_16.png "${PN}".png || die
	newicon -s 22 "${DISSENTER_HOME}"/product_logo_22.png "${PN}".png || die
	newicon -s 24 "${DISSENTER_HOME}"/product_logo_24.png "${PN}".png || die
	newicon -s 32 "${DISSENTER_HOME}"/product_logo_32.png "${PN}".png || die
	newicon -s 48 "${DISSENTER_HOME}"/product_logo_48.png "${PN}".png || die
	newicon -s 64 "${DISSENTER_HOME}"/product_logo_64.png "${PN}".png || die
	newicon -s 128 "${DISSENTER_HOME}"/product_logo_128.png "${PN}".png || die
	newicon -s 256 "${DISSENTER_HOME}"/product_logo_256.png "${PN}".png || die

	cp -r ${S}/* ${D}/
	
	dodoc "${DISSENTER_DOC}"/changelog
	dodoc "${DISSENTER_MAN}"/"${PN}"-browser-stable.1
	
	rm -rf "${D}"/usr/share/doc/"${PN}"-browser
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	elog "If upgrading from an 0.25.x release or earlier, note that Brave has changed configuration folders."
	elog "you will have to import your browser data from Settings -> People -> Import Bookmarks and Settings"
	elog "then choose \"Brave (old)\". All your settings, bookmarks, and passwords should return."
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
