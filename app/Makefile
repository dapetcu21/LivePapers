include theos/makefiles/common.mk

APPLICATION_NAME = LivePapers
OpenFlow_FILES = \
    OpenFlow/OpenFlow/AFItem.m \
    OpenFlow/OpenFlow/AFOpenFlowView.m \
    OpenFlow/OpenFlow/AFUIImageReflection.m

LivePapers_FILES = main.m \
    LivePapersApplication.m \
    LPRootViewController.m \
    LPPaper.m \
    LPPreviewView.m \
    LPPreview.m \
    LPPaper.m \
    LPPlugin.m \
    TPPropertyAnimation.m \
    $(OpenFlow_FILES)

LivePapers_OBJCFLAGS = -IOpenFlow/OpenFlow -I. -I../common 
LivePapers_PRIVATE_FRAMEWORKS = AppSupport
LivePapers_FRAMEWORKS = UIKit CoreGraphics QuartzCore 

include $(THEOS_MAKE_PATH)/application.mk
