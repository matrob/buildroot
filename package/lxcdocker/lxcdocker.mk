################################################################################
#
# lxcdocker
#
################################################################################

LXCDOCKER_VERSION = 1.9.1
LXCDOCKER_SITE = $(call github,docker,docker,v$(LXCDOCKER_VERSION))
LXCDOCKER_DEPENDENCIES = sqlite host-golang
LXCDOCKER_LICENSE = Apache
LXCDOCKER_LICENSE_FILES = LICENSE

ifeq ($(BR2_PACKAGE_LXCDOCKER_DAEMON),y)
LXCDOCKER_BUILD_TAGS += daemon
endif

ifeq ($(BR2_PACKAGE_LXCDOCKER_EXPERIMENTAL),y)
LXCDOCKER_BUILD_TAGS += experimental
endif

ifeq ($(BR2_PACKAGE_LXCDOCKER_DRIVER_BTRFS),y)
LXCDOCKER_DEPENDENCIES += btrfs-progs
else
LXCDOCKER_BUILD_TAGS += exclude_graphdriver_btrfs
endif

ifneq ($(BR2_PACKAGE_LXCDOCKER_DRIVER_OVERLAYFS),y)
LXCDOCKER_BUILD_TAGS += exclude_graphdriver_overlayfs
endif

ifeq ($(BR2_PACKAGE_LXCDOCKER_DRIVER_AUFS),y)
LXCDOCKER_DEPENDENCIES += aufs-util
else
LXCDOCKER_BUILD_TAGS += exclude_graphdriver_aufs
endif

ifeq ($(BR2_PACKAGE_LXCDOCKER_DRIVER_DEVICEMAPPER),y)
LXCDOCKER_DEPENDENCIES += lvm2
else
LXCDOCKER_BUILD_TAGS += exclude_graphdriver_devicemapper
endif

ifeq ($(BR2_PACKAGE_LXCDOCKER_DRIVER_VFS),y)
LXCDOCKER_DEPENDENCIES += gvfs
else
LXCDOCKER_BUILD_TAGS += exclude_graphdriver_vfs
endif

# hack to fix jump in seccomp
define LXCDOCKER_CONFIGURE_CMDS
	echo "clone git github.com/golang/protobuf ab974be44dc3b7b8a1fb306fb32fe9b9f3864b3d" >> $(@D)/hack/vendor.sh
	go(){ $(GOLANG) $$@; } && export -f go && \
		export GITCOMMIT=$(LXCDOCKER_VERSION) && \
		export VERSION=$(LXCDOCKER_VERSION) && \
		export GOPATH=$(TARGET_DIR)/usr/src/go/ && \
		cd $(@D) && ./hack/vendor.sh
	ln -fs $(@D) $(@D)/vendor/src/github.com/docker/docker
endef

define LXCDOCKER_BUILD_CMDS
	export GOPATH="$(@D)/.gopath:$(@D)/vendor"; \
	export CGO_ENABLED=1; \
	export CGO_NO_EMULATION=1; \
	export CGO_CFLAGS='-I$(STAGING_DIR)/usr/include/ -I$(TARGET_DIR)/usr/include -I$(LINUX_HEADERS_DIR)/fs/'; \
	export LDFLAGS="-X main.GITCOMMIT $(LXCDOCKER_VERSION) -X main.VERSION $(LXCDOCKER_VERSION_ID) -w -linkmode external -extldflags '-Wl,--unresolved-symbols=ignore-in-shared-libs' -extld '$(TARGET_CC)'"; \
	cd $(@D); \
 	mkdir -p bin; \
	bash ./hack/make/.go-autogen; \
	$(GOLANG_ENV) $(GOLANG) build -v -o "$(@D)/bin/docker" -a -tags "$(LXCDOCKER_BUILD_TAGS)" -ldflags "$$LDFLAGS" ./docker
endef

define LXCDOCKER_INSTALL_TARGET_CMDS
	cp -L $(@D)/bin/docker $(TARGET_DIR)/usr/bin/docker
endef

define LXCDOCKER_USERS
	- - docker -1 * - - - Docker Application Container Framework
endef

$(eval $(generic-package))
