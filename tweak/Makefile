include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LivePapers 
LivePapers_FRAMEWORKS = UIKit CoreGraphics QuartzCore GraphicsServices
LivePapers_PRIVATE_FRAMEWORKS = GraphicsServices
LivePapers_OBJCFLAGS = -I../common 
LivePapers_FILES = Tweak.xm \
                   LPController.m \
                   LPView.m \
                   LPScreenView.m \
                   LPPlugin.m  \
                   LPWallpaper.m \
                   LPIntermediateVC.mm \
                   LPUITouch.mm \
                   ../common/LPDisplayLink.mm \

include $(THEOS_MAKE_PATH)/tweak.mk
