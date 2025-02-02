# Jade Application Kit (JAK): https://github.com/codesardine/Jade-Application-Kit

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit git-r3 distutils-r1 python-r1

DESCRIPTION="Jade Application Kit (JAK)"
HOMEPAGE="https://github.com/codesardine/Jade-Application-Kit"
EGIT_REPO_URI="https://github.com/codesardine/Jade-Application-Kit"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="network-sandbox"

REQUIRED_USE="$(python_gen_useflags ${PYTHON_COMPAT})"

DEPEND="
	${PYTHON_DEPS}
	>=dev-qt/qtwebengine-5.12.3
	>=dev-python/pyside2-5.12.5
"
RDEPEND="${DEPEND}"
S=${WORKDIR/Jade-Application-Kit}

src_prepare() {	
	eapply_user
	git-r3_fetch ${EGIT_REPO_URI}
	git-r3_checkout ${EGIT_REPO_URI} ${S}
}

src_install() {
	cd ${S}
        python_foreach_impl distutils-r1_python_install
}
