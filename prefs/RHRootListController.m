#import "RHRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <spawn.h>
#import <notify.h>

#define PREFS_PATH @"/var/jb/Library/Preferences/com.roothide1.tweak.plist"

@implementation RHRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}
	return _specifiers;
}

- (void)respring {
	pid_t pid;
	const char *args[] = {"sbreload", NULL};
	posix_spawn(&pid, "/var/jb/usr/bin/sbreload", NULL, NULL, (char* const*)args, NULL);
}

- (void)reloadPrefs {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.roothide1.tweak/prefsChanged"), NULL, NULL, TRUE);
}

@end
