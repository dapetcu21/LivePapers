export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = BubblesPro
BubblesPro_FILES = BubblesPro.mm \
				   BubblesPrefsController.mm \
				   common/LPColorWheel.m \
				   common/ColorPicker/InfColorBarPicker.m \
				   common/ColorPicker/InfColorIndicatorView.m \
				   common/ColorPicker/InfColorPickerController.m \
				   common/ColorPicker/InfColorSquarePicker.m \
				   common/ColorPicker/InfHSBSupport.m \
				   common/ColorPicker/InfSourceColorView.m 

BubblesPro_INSTALL_PATH = /Library/LivePapers/Plugins
BubblesPro_FRAMEWORKS = UIKit CoreGraphics 
BubblesPro_OBJCFLAGS = -DPH_APP_TARGET=Bubbles -I../common

after-stage::
	- find $(THEOS_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;

include $(THEOS_MAKE_PATH)/library.mk
