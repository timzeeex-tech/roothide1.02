export THEOS_PACKAGE_SCHEME = rootless

TARGET := iphone:clang:latest:15.0
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Roothide1.0

Roothide1.0_FILES = Tweak.xm
Roothide1.0_CFLAGS = -fobjc-arc
Roothide1.0_FRAMEWORKS = Foundation

SUBPROJECTS += prefs

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
