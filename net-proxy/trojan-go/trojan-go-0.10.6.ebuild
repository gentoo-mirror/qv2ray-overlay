# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd go-module

DESCRIPTION="A Trojan proxy written in Go"
HOMEPAGE="https://github.com/p4gefau1t/trojan-go"
SRC_URI="
	https://github.com/p4gefau1t/trojan-go/archive/refs/tags/v${PV}.tar.gz
	https://github.com/blackteahamburger/gentoo-go-deps/releases/download/${P}/${P}-deps.tar.xz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="
	app-alternatives/v2ray-geoip
	app-alternatives/v2ray-geosite
"
RDEPEND="
	!net-proxy/trojan-go
	${DEPEND}
"
BDEPEND="dev-lang/go"

S=${WORKDIR}/trojan-go-${PV}

src_compile() {
	ego build -tags "full"
}

src_install() {
	dobin trojan-go

	insinto /etc/trojan-go
	doins example/*.json

	systemd_dounit example/*.service

	dosym /usr/share/v2ray/geosite.dat /usr/share/trojan-go/geosite.dat
	dosym /usr/share/v2ray/geoip.dat /usr/share/trojan-go/geoip.dat
}
