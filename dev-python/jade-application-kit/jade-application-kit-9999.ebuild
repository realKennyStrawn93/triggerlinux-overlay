# Jade Application Kit (JAK): https://github.com/codesardine/Jade-Application-Kit

EAPI=7

PYTHON_COMPAT=(python{3_4,3_5,3_6,3_7})
inherit git-r3 distutils-r1

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
S=${WORKDIR}

src_prepare() {
	eapply_user
	git-r3_fetch ${EGIT_REPO_URI}
	git-r3_checkout ${EGIT_REPO_URI} ${S}/Jade-Application-Kit
}

src_install() {
	cd ${S}/Jade-Application-Kit
        distutils-r1_python install
}
