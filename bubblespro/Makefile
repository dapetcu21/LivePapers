export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = BubblesPro
BubblesPro_FILES = BubblesPro.mm \
				   BubblesPrefsController.mm \

BubblesPro_INSTALL_PATH = /Library/LivePapers/Plugins
BubblesPro_FRAMEWORKS = UIKit CoreGraphics 
BubblesPro_OBJCFLAGS = -DPH_APP_TARGET=Bubbles -I../common

after-stage::
	- find $(THEOS_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;

include $(THEOS_MAKE_PATH)/library.mk
