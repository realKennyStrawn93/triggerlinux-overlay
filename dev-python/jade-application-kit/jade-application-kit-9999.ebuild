# Jade Application Kit (JAK): https://github.com/codesardine/Jade-Application-Kit

EAPI=7

DESCRIPTION="Jade Application Kit (JAK)"
HOMEPAGE="https://github.com/codesardine/Jade-Application-Kit"
EGIT_REPO_URI="https://github.com/codesardine/Jade-Application-Kit"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~*"
IUSE=""
RESTRICT="network-sandbox"

DEPEND="
	>=dev-lang/python-3.6
	>=dev-python/pyside-5.12.14
"
RDEPEND="${DEPEND}"
S=${WORKDIR}

src_install() {
	git clone --depth 1 $EGIT_REPO_URI $S/Jade-Application-Kit
	cd $S/Jade-Application-Kit
        ./setup.py --prefix=$D install
}
