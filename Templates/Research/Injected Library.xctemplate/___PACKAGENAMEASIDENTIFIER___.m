#import "___FILEBASENAME___.h"

#import "SwizzlingHelper.h"

@import os.log;

os_log_t logger(void)
{
    static dispatch_once_t onceToken;
    static os_log_t _log;
    dispatch_once(&onceToken, ^{
        _log = os_log_create("___VARIABLE_bundleIdentifierPrefix:bundleIdentifier___.___VARIABLE_productName:RFC1034Identifier___", "___PACKAGENAMEASIDENTIFIER___");
    });
    return _log;
}

@implementation ___FILEBASENAMEASIDENTIFIER___

+ (void)load
{
    os_log(logger(), "Loaded into %{public}s", getprogname());
    
    /** Use SwizzleInstanceMethod/SwizzleClassMethod to swizzle Objective-C methods in the target binary **/
    /** Use [SwizzlingHelper loadSystemFrameworkWithRelativePath:...] if any frameworks must be loaded before performing the swizzling **/
}

@end
