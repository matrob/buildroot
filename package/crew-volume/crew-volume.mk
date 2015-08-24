################################################################################
#
# crew-volume
#
################################################################################

CREW_VOLUME_VERSION = 4dcfcf40b9d3ade99217064cf285d6fd13d9fc35
CREW_VOLUME_SITE = $(call github,ohardy,dokku-volume,$(CREW_VOLUME_VERSION))
CREW_VOLUME_DEPENDENCIES = crew
CREW_VOLUME_LICENSE_FILES = LICENSE

define CREW_VOLUME_CONFIGURE_CMDS
	find $(@D) -type f -exec sed -i -e 's/dokku/crew/g' {} \;
	find $(@D) -type f -exec sed -i -e 's/DOKKU/CREW/g' {} \;
endef

define CREW_VOLUME_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/var/lib/crew/plugins/volume/
	$(INSTALL) -D -m 0755 $(@D)/* $(TARGET_DIR)/var/lib/crew/plugins/volume/
endef

$(eval $(generic-package))
