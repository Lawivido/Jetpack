include theos/makefiles/common.mk

TWEAK_NAME = jetpackmenu
<<<<<<< HEAD
jetpackmenu_FILES = Menu.xm Hooks.xm Settings.mm
=======
jetpackmenu_FILES = Tweak.xm Hooks.mm
>>>>>>> origin/master
jetpackmenu_FRAMEWORKS = UIKit
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
