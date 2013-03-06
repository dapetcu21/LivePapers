include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = LPBuiltins
LPBuiltins_INSTALL_PATH = /Library/LivePapers/Plugins
LPBuiltins_FRAMEWORKS = UIKit CoreGraphics
LPBuiltins_OBJCFLAGS = -I../common 
LPBuiltins_FILES = LPBuiltins.m \
                   LPDefaultViewController.m \
                   LPDefaultPrefsController.m \
                   LPSolidViewController.m \
                   LPSolidPrefsController.m \

include $(THEOS_MAKE_PATH)/library.mk
