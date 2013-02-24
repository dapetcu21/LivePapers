export TARGET_IPHONEOS_DEPLOYMENT_VERSION = 4.3

include theos/makefiles/common.mk

LIBRARY_NAME = Nexus
Nexus_FILES = Nexus.mm \
    NexusViewController.mm \
    NexusPrefsController.mm \
    LPGL/LPUtil.mm \
    LPGL/LPVector2.mm \
    LPGL/LPVector3.mm \
    LPGL/LPMatrix4.mm \
    LPGL/LPGLViewController.mm 

Nexus_INSTALL_PATH = /Library/LivePapers/Plugins
Nexus_FRAMEWORKS = UIKit CoreGraphics OpenGLES GLKit

after-stage::
	- find $(THEOS_STAGING_DIR) -iname '*.plist' -or -iname '*.strings' -exec plutil -convert binary1 {} \;

include $(THEOS_MAKE_PATH)/library.mk
