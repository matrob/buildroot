################################################################################
#
# crew-hostname
#
################################################################################

CREW_HOSTNAME_VERSION = 83088725097c531149691f6dad736fcf83f6e7a6
CREW_HOSTNAME_SITE = $(call github,michaelshobbs,dokku-hostname,$(CREW_HOSTNAME_VERSION))
CREW_HOSTNAME_DEPENDENCIES = crew
CREW_HOSTNAME_LICENSE_FILES = LICENSE

define CREW_HOSTNAME_CONFIGURE_CMDS
	find $(@D) -type f -exec sed -i -e 's/dokku/crew/g' {} \;
	find $(@D) -type f -exec sed -i -e 's/DOKKU/CREW/g' {} \;
endef

define CREW_HOSTNAME_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/var/lib/crew/plugins/hostname/
	$(INSTALL) -D -m 0755 $(@D)/* $(TARGET_DIR)/var/lib/crew/plugins/hostname/
endef

$(eval $(generic-package))
