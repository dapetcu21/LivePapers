include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LivePapers 
LivePapers_FRAMEWORKS = UIKit CoreGraphics
LivePapers_OBJCFLAGS = -I../common 
LivePapers_FILES = Tweak.xm \
                   LPController.m \
                   LPView.m \
                   LPScreenView.m \
                   LPPlugin.m  \
                   LPWallpaper.m \
                   LPIntermediateVC.m \

include $(THEOS_MAKE_PATH)/tweak.mk
