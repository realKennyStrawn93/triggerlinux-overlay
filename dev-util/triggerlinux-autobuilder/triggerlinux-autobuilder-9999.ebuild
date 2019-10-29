# TriggerLinux build scripts ebuild
# Installs https://github.com/realKennyStrawn93/TriggerLinux to /opt

EAPI=7

DESCRIPTION="TriggerLinux Catalyst wrapper scripts"
HOMEPAGE="https://github.com/realKennyStrawn93/TriggerLinux"
EGIT_REPO_URI="https://github.com/realKennyStrawn93/TriggerLinux"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="network-sandbox"

DEPEND="
	app-portage/layman
	app-admin/sudo
	dev-util/catalyst
	dev-vcs/git
	net-misc/wget
"
RDEPEND="${DEPEND}"
S=${WORKDIR}

src_install() {
	git clone --depth 1 $EGIT_REPO_URI $S/TriggerLinux
        mkdir $D/opt
	cp -r $S/TriggerLinux $D/opt/TriggerLinux
}
