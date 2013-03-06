include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LivePapers
LivePapers_FILES = LivePapers.mm
LivePapers_INSTALL_PATH = /Library/PreferenceBundles
LivePapers_FRAMEWORKS = UIKit
LivePapers_PRIVATE_FRAMEWORKS = Preferences AppSupport
LivePapers_OBJCFLAGS = -I../common 

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LivePapers.plist$(ECHO_END)
