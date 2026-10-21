#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <sys/stat.h>
#import <unistd.h>
#import <errno.h>

#define PREFS_PATH @"/var/jb/Library/Preferences/com.roothide1.tweak.plist"

static NSDictionary *prefs = nil;

static BOOL isAppHidden() {
    if (!prefs) return NO;
    
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    if (!bundleID) return NO;
    
    NSArray *hiddenApps = prefs[@"hiddenApps"];
    if (!hiddenApps || ![hiddenApps isKindOfClass:[NSArray class]]) return NO;
    
    return [hiddenApps containsObject:bundleID];
}

static void loadPrefs() {
    prefs = [NSDictionary dictionaryWithContentsOfFile:PREFS_PATH];
}

// File existence checks
%hook NSFileManager

- (BOOL)fileExistsAtPath:(NSString *)path {
    if (isAppHidden()) {
        // Common jailbreak paths to hide
        NSArray *jailbreakPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Applications/Zebra.app",
            @"/Applications/Filza.app",
            @"/bin/bash",
            @"/bin/sh",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/var/lib/cydia",
            @"/var/jb",
            @"/var/mobile/Library/SBSettings/Themes",
            @"/private/var/lib/apt",
            @"/private/var/lib/cydia",
            @"/private/var/jb",
            @"/private/var/tmp/cydia.log",
            @"/usr/bin/ssh",
            @"/usr/bin/sshd",
            @"/usr/libexec/sftp-server"
        ];
        
        for (NSString *jbPath in jailbreakPaths) {
            if ([path isEqualToString:jbPath] || [path hasPrefix:jbPath]) {
                return NO;
            }
        }
    }
    return %orig;
}

- (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory {
    if (isAppHidden()) {
        NSArray *jailbreakPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Applications/Zebra.app",
            @"/Applications/Filza.app",
            @"/bin/bash",
            @"/bin/sh",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/var/lib/cydia",
            @"/var/jb",
            @"/private/var/lib/apt",
            @"/private/var/lib/cydia",
            @"/private/var/jb",
            @"/usr/bin/ssh",
            @"/usr/bin/sshd"
        ];
        
        for (NSString *jbPath in jailbreakPaths) {
            if ([path isEqualToString:jbPath] || [path hasPrefix:jbPath]) {
                if (isDirectory) *isDirectory = NO;
                return NO;
            }
        }
    }
    return %orig;
}

%end

// C function hooks
%hookf(int, access, const char *pathname, int mode) {
    if (isAppHidden() && pathname) {
        NSString *path = [NSString stringWithUTF8String:pathname];
        NSArray *jailbreakPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Applications/Zebra.app",
            @"/Applications/Filza.app",
            @"/bin/bash",
            @"/bin/sh",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/var/lib/cydia",
            @"/var/jb",
            @"/private/var/lib/apt",
            @"/private/var/lib/cydia",
            @"/private/var/jb",
            @"/usr/bin/ssh",
            @"/usr/bin/sshd"
        ];
        
        for (NSString *jbPath in jailbreakPaths) {
            if ([path isEqualToString:jbPath] || [path hasPrefix:jbPath]) {
                errno = ENOENT;
                return -1;
            }
        }
    }
    return %orig;
}

%hookf(int, stat, const char *pathname, struct stat *statbuf) {
    if (isAppHidden() && pathname) {
        NSString *path = [NSString stringWithUTF8String:pathname];
        NSArray *jailbreakPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Applications/Zebra.app",
            @"/Applications/Filza.app",
            @"/bin/bash",
            @"/bin/sh",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/var/lib/cydia",
            @"/var/jb",
            @"/private/var/lib/apt",
            @"/private/var/lib/cydia",
            @"/private/var/jb"
        ];
        
        for (NSString *jbPath in jailbreakPaths) {
            if ([path isEqualToString:jbPath] || [path hasPrefix:jbPath]) {
                errno = ENOENT;
                return -1;
            }
        }
    }
    return %orig;
}

%hookf(int, lstat, const char *pathname, struct stat *statbuf) {
    if (isAppHidden() && pathname) {
        NSString *path = [NSString stringWithUTF8String:pathname];
        NSArray *jailbreakPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Applications/Zebra.app",
            @"/Applications/Filza.app",
            @"/bin/bash",
            @"/bin/sh",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/var/lib/cydia",
            @"/var/jb",
            @"/private/var/lib/apt",
            @"/private/var/lib/cydia",
            @"/private/var/jb"
        ];
        
        for (NSString *jbPath in jailbreakPaths) {
            if ([path isEqualToString:jbPath] || [path hasPrefix:jbPath]) {
                errno = ENOENT;
                return -1;
            }
        }
    }
    return %orig;
}

%hookf(FILE *, fopen, const char *filename, const char *mode) {
    if (isAppHidden() && filename) {
        NSString *path = [NSString stringWithUTF8String:filename];
        NSArray *jailbreakPaths = @[
            @"/Applications/Cydia.app",
            @"/Applications/Sileo.app",
            @"/Applications/Zebra.app",
            @"/Applications/Filza.app",
            @"/bin/bash",
            @"/bin/sh",
            @"/usr/sbin/sshd",
            @"/etc/apt",
            @"/Library/MobileSubstrate/MobileSubstrate.dylib",
            @"/var/lib/cydia",
            @"/var/jb",
            @"/private/var/lib/apt",
            @"/private/var/lib/cydia",
            @"/private/var/jb"
        ];
        
        for (NSString *jbPath in jailbreakPaths) {
            if ([path isEqualToString:jbPath] || [path hasPrefix:jbPath]) {
                errno = ENOENT;
                return NULL;
            }
        }
    }
    return %orig;
}

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL,
        (CFNotificationCallback)loadPrefs,
        CFSTR("com.roothide1.tweak/prefsChanged"),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce);
}
