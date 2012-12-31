SUBPROJECTS = tweak plugin app nexus

export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3

include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/aggregate.mk

after-stage::
	- find $(THEOS_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;
