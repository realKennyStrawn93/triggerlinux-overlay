# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 linux-info

DESCRIPTION="Service and tools for management of snap packages"
HOMEPAGE="http://snapcraft.io/"

MY_S="${S}/src/github.com/snapcore/${PN}"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/snapcore/${PN}.git"
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${MY_S}"
	KEYWORDS="~amd64"
else
	inherit golang-vcs-snapshot
	SRC_URI="https://github.com/snapcore/${PN}/releases/download/${PV}/${PN}_${PV}.vendor.tar.xz -> ${P}.tar.xz"
	MY_PV=${PV}
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="systemd qt "
RESTRICT="primaryuri strip"

PKG_LINGUAS="am bs ca cs da de el en_GB es fi fr gl hr ia id it ja lt ms nb oc pt_BR pt ru sv tr ug zh_CN"

CONFIG_CHECK="	CGROUPS \
		CGROUP_DEVICE \
		CGROUP_FREEZER \
		NAMESPACES \
		SQUASHFS \
		SQUASHFS_ZLIB \
		SQUASHFS_LZO \
		SQUASHFS_XZ \
		BLK_DEV_LOOP \
		SECCOMP \
		SECCOMP_FILTER \
		SECURITY_APPARMOR"

RDEPEND="!sys-apps/snap-confine
	sys-libs/libseccomp[static-libs]
	sys-apps/apparmor
	dev-libs/glib
	sys-fs/squashfs-tools:*
	sec-policy/apparmor-profiles
	qt? ( 
          dev-qt/qtcore
          dev-qt/qtnetwork )
	>=net-libs/libsoup-2.32
	>=dev-libs/json-glib-1.1.2"

DEPEND="${RDEPEND}
	>=dev-lang/go-1.9
	dev-python/docutils
	sys-devel/gettext
	sys-fs/xfsprogs
	app-emulation/snapd
	dev-util/gtk-doc"

REQUIRED_USE="systemd"

src_unpack() {
	if [[ ${PV} == 9999 ]]
	then
		git-r3_src_unpack
	else
		unpack
	fi
}

src_configure() {
	[[ ${PV} == 9999 ]] && MY_PV=$(date +%Y.%m.%d)
	debug-print-function $FUNCNAME "$@"

	test -f autogen.sh	# Sanity check, are we in the right directory?
	rm -f config.status
	# Regenerate the build system
}

src_compile() {
	cd ${MY_S}
	./autogen.sh --prefix="${D}usr" \
		--libdir="/usr/$(get_libdir)" \
		--libexecdir="/usr/$(get_libdir)/${PN}" \
		--enable-snapd_qt=$(usex qt) \
		--disable-silent-rules \
		--enable-introspection
	emake -C "${MY_S}"
}

src_install() {
	emake -C "${MY_S}" install DESTDIR="${D}"
}

pkg_postinst() {
	CMDLINE=$(cat /proc/cmdline) 
	if [[ $CMDLINE == *"apparmor=1"* ]] && [[ $CMDLINE == *"security=apparmor"* ]]; then
	    apparmor_parser -r /etc/apparmor.d/usr.lib.snapd.snap-confine.real
		einfo "Enable snapd snapd.socket and snapd.apparmor service, then reload the apparmor service to start using snapd"
	else 
		einfo ""
		einfo "Apparmor needs to be enabled and configured as the default security"
		einfo "Ensure /etc/default/grub is updated to include:"
		einfo "GRUB_CMDLINE_LINUX_DEFAULT=\"apparmor=1 security=apparmor\""
		einfo "Then update grub, enable snapd, snapd.socket and snapd.apparmor and reboot"
		einfo ""
	fi
}
