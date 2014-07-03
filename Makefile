include theos/makefiles/common.mk

TWEAK_NAME = jetpackmenu
jetpackmenu_FILES = Tweak.xm Hooks.mm
jetpackmenu_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
