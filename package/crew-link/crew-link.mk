################################################################################
#
# crew-link
#
################################################################################

CREW_LINK_VERSION = 7cb35ca13c8358bfe8c42c48ec772788355a1f75
CREW_LINK_SITE = $(call github,rlaneve,dokku-link,$(CREW_LINK_VERSION))
CREW_LINK_DEPENDENCIES = crew
CREW_LINK_LICENSE_FILES = LICENSE

define CREW_LINK_CONFIGURE_CMDS
	find $(@D) -type f -exec sed -i -e 's/dokku/crew/g' {} \;
	find $(@D) -type f -exec sed -i -e 's/DOKKU/CREW/g' {} \;
endef

define CREW_LINK_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/var/lib/crew/plugins/link/
	$(INSTALL) -D -m 0755 $(@D)/* $(TARGET_DIR)/var/lib/crew/plugins/link/
endef

$(eval $(generic-package))
