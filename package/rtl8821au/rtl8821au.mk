################################################################################
#
# rtl8821au
#
################################################################################

RTL8821AU_VERSION = 73a9507d69eaccb6b1e3f185deda6484ef462170
RTL8821AU_SITE = $(call github,paralin,rtl8821au,$(RTL8821AU_VERSION))
RTL8821AU_LICENSE = GPLv2
RTL8821AU_LICENSE_FILES = COPYING

RTL8821AU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8821A=y  \
	CONFIG_RTL8821AU=m \
	USER_EXTRA_CFLAGS=-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN

$(eval $(kernel-module))
$(eval $(generic-package))
