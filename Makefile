export THEOS_PACKAGE_SCHEME = rootless

TARGET := iphone:clang:latest:15.0
ARCHS := arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AzotaPanel
AzotaPanel_FILES = Tweak.xm
AzotaPanel_FRAMEWORKS = UIKit
AzotaPanel_CFLAGS = -fobjc-arc
AzotaPanel_INSTALL_PATH = /Library/MobileSubstrate/DynamicLibraries

include $(THEOS_MAKE_PATH)/tweak.mk
