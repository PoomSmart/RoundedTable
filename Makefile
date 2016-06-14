GO_EASY_ON_ME = 1
SDKVERSION = 9.0
DEBUG = 0
PACKAGE_VERSION = 1.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RoundedTable
RoundedTable_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = RoundedTableSettings
RoundedTableSettings_FILES = RoundedTablePreferenceController.m
RoundedTableSettings_INSTALL_PATH = /Library/PreferenceBundles
RoundedTableSettings_PRIVATE_FRAMEWORKS = Preferences
RoundedTableSettings_FRAMEWORKS = UIKit
RoundedTableSettings_LIBRARIES = cepheiprefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RoundedTable.plist$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR) -name .DS_Store | xargs rm -rf$(ECHO_END)
