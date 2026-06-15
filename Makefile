ARCHS = arm64 arm64e
TARGET = iphone:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YallaLudoTweak
YallaLudoTweak_FILES = Tweak.mm
YallaLudoTweak_FRAMEWORKS = UIKit WebKit
YallaLudoTweak_PRIVATE_FRAMEWORKS = 
YallaLudoTweak_LIBRARIES = 

include $(THEOS_MAKE_INSTANCE)/tweak.mk

# If you want to add an HTML UI, you might put it in a Resources folder
# YallaLudoTweak_INSTALL_TARGET_PROCESSES = YallaLudo
# YallaLudoTweak_RESOURCE_BUNDLES = YallaLudoTweakResources.bundle

# To make a debian package
include $(THEOS_MAKE_INSTANCE)/debian.mk
