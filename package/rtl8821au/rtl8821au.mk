################################################################################
#
# rtl8821au
#
################################################################################

RTL8821AU_VERSION = 83b1e07b9ab5a98f6585068de5a13ce9646aca9a
RTL8821AU_SITE = $(call github,paralin,rtl8821au,$(RTL8821AU_VERSION))
RTL8821AU_LICENSE = GPLv2
RTL8821AU_LICENSE_FILES = COPYING

RTL8821AU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8821AU=m \
	USER_EXTRA_CFLAGS=-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN

$(eval $(kernel-module))
$(eval $(generic-package))
