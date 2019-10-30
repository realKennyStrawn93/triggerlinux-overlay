# Jade Application Kit (JAK): https://github.com/codesardine/Jade-Application-Kit

EAPI=7

PYTHON_COMPAT=( python3_{1,2,3,4,5,6,7} )
inherit git-r3 distutils-r1 python-single-r1

DESCRIPTION="Jade Application Kit (JAK)"
HOMEPAGE="https://github.com/codesardine/Jade-Application-Kit"
EGIT_REPO_URI="https://github.com/codesardine/Jade-Application-Kit"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="network-sandbox"

DEPEND="
	>=dev-lang/python-3.6
	>=dev-python/pyside-5.12.14
"
RDEPEND="${DEPEND}"
S=${WORKDIR/Jade-Application-Kit}

src_prepare() {	
	use python && python-single-r1_pkg_setup
	eapply_user
	git-r3_fetch ${EGIT_REPO_URI}
	git-r3_checkout ${EGIT_REPO_URI} ${S}
}

src_install() {
	cd ${S}
        distutils-r1_python_install
}
