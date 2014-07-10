include theos/makefiles/common.mk

TWEAK_NAME = jetpackmenu
jetpackmenu_FILES = Menu.xm Hooks.xm Settings.mm
jetpackmenu_FRAMEWORKS = UIKit
jetpackmenu__CFLAGS += -fobjc-arc 
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
