include $(TOPDIR)/rules.mk

PKG_NAME:=webdavfs
PKG_VERSION:=1.0
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/miquels/webdavfs/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=a3db114d53be3dc48eae6036988a2d9d5b8104bb9e5a886d5e7d46c345a1aee0
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_MAINTAINER:=jjm2473 <jjm2473@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE.md

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/miquels/webdavfs

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

TAR_OPTIONS:=--strip-components 1 $(TAR_OPTIONS)
TAR_CMD=$(HOST_TAR) -C $(PKG_BUILD_DIR) $(TAR_OPTIONS)

define Package/webdavfs
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Filesystem
  TITLE:=FUSE webdav filesystem
  URL:=https://github.com/miquels/webdavfs
  DEPENDS:=$(GO_ARCH_DEPENDS) +fuse-utils
endef

define Package/webdavfs/description
 Linux / OSX FUSE webdav filesystem. This filesystem behaves like a real network filesystem- no unnecessary copying of entire files.
endef

define Package/webdavfs/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/webdavfs $(1)/usr/sbin/webdavfs
	$(LN) webdavfs $(1)/usr/sbin/mount.webdavfs
	$(INSTALL_DIR) $(1)/sbin/fs
	$(LN) /usr/sbin/webdavfs $(1)/sbin/fs/mount.webdavfs
endef

$(eval $(call GoBinPackage,webdavfs))
$(eval $(call BuildPackage,webdavfs))
