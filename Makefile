ARCHS = arm64 arm64e
TARGET = iphone:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YallaLudoTweak

YallaLudoTweak_FILES = Tweak.mm
YallaLudoTweak_FRAMEWORKS = UIKit WebKit

include $(THEOS)/makefiles/tweak.mk

include $(THEOS)/makefiles/package/debian.mk
