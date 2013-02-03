SUBPROJECTS = tweak plugin app nexus

export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/aggregate.mk

SIM_APP_ID=9AECC9CF-5F87-4A0C-AE46-AF34B613FBC2

after-stage::
	- find $(THEOS_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;
ifeq ($(TARGET), simulator)
	mkdir -p "$(THEOS_STAGING_DIR)/Applications/$(SIM_APP_ID)"
	mv "$(THEOS_STAGING_DIR)/Applications/LivePapers.app" "$(THEOS_STAGING_DIR)/Applications/$(SIM_APP_ID)"
endif
