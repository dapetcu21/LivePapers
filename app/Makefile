include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = LivePapers
OpenFlow_FILES = \
    OpenFlow/OpenFlow/AFItem.m \
    OpenFlow/OpenFlow/AFOpenFlowView.m

ColorPicker_FILES = \
	LPColorWheel.m \
	ColorPicker/InfColorBarPicker.m \
	ColorPicker/InfColorIndicatorView.m \
	ColorPicker/InfColorPickerController.m \
	ColorPicker/InfColorSquarePicker.m \
	ColorPicker/InfHSBSupport.m \
	ColorPicker/InfSourceColorView.m 

LivePapers_FILES = main.m \
    LivePapersApplication.m \
    LPRootViewController.m \
    LPPaper.m \
    LPPreviewView.m \
    LPPreview.m \
    LPPaper.m \
    LPPlugin.m \
    LPNotifications.m \
    TPPropertyAnimation.m \
	$(OpenFlow_FILES) \
	$(ColorPicker_FILES)

ifneq ($(TARGET), simulator)
    LivePapers_FILES += ../common/LPDisplayLink.mm 
	LivePapers_LDFLAGS = -lsubstrate
endif

LivePapers_OBJCFLAGS = -IOpenFlow/OpenFlow -I. -I../common 
LivePapers_PRIVATE_FRAMEWORKS = AppSupport SpringBoardUI
LivePapers_FRAMEWORKS = UIKit CoreGraphics QuartzCore 

include $(THEOS_MAKE_PATH)/application.mk
