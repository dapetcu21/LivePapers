export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3

include theos/makefiles/common.mk

LIBRARY_NAME = BubblesPro
BubblesPro_FILES = BubblesPro.mm \
				   BubblesPrefsController.mm \
				   LPColorWheel.m \
				   ColorPicker/InfColorBarPicker.m \
				   ColorPicker/InfColorIndicatorView.m \
				   ColorPicker/InfColorPickerController.m \
				   ColorPicker/InfColorSquarePicker.m \
				   ColorPicker/InfHSBSupport.m \
				   ColorPicker/InfSourceColorView.m 

BubblesPro_INSTALL_PATH = /Library/LivePapers/Plugins
BubblesPro_FRAMEWORKS = UIKit CoreGraphics 
BubblesPro_OBJCFLAGS = -DPH_APP_TARGET=Bubbles

after-stage::
	- find $(THEOS_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;

include $(THEOS_MAKE_PATH)/library.mk
