@import ObjectiveC.runtime;

#import "SwizzlingHelper.h"

#import <TargetConditionals.h>

#import <dlfcn.h>

@import os.log;

os_log_t swizzleLog(void)
{
    static dispatch_once_t onceToken;
    static os_log_t _log;
    dispatch_once(&onceToken, ^{
        _log = os_log_create("___VARIABLE_bundleIdentifierPrefix:bundleIdentifier___.___VARIABLE_productName:RFC1034Identifier___", "SwizzlingHelper");
    });
    return _log;
}

@implementation SwizzlingHelper

/// The override and original methods will be either instance or class methods depending upon the `isClassMethod` argument.
+ (BOOL)swizzleClass:(Class)aClass
              method:(SEL)methodSelector
     overridingClass:(Class)overrideClass
       isClassMethod:(BOOL)isClassMethod
{
    Method original = (isClassMethod) ? class_getClassMethod(aClass, methodSelector) : class_getInstanceMethod(aClass, methodSelector);
    if (!original) os_log_error(swizzleLog(), "Missing %{public}@ method %{public}@", NSStringFromClass(aClass), NSStringFromSelector(methodSelector));
    if (!original) return NO;

    SEL replacementSelector = NSSelectorFromString([NSString stringWithFormat:@"__override_%@", NSStringFromSelector(methodSelector)]);
    Method replacement = (isClassMethod) ? class_getClassMethod(overrideClass, replacementSelector) : class_getInstanceMethod(overrideClass, replacementSelector);
    if (!replacement) os_log_error(swizzleLog(), "Missing %{public}@ method %{public}@", NSStringFromClass(overrideClass), NSStringFromSelector(replacementSelector));
    if (!replacement) return NO;

    SEL newOriginalSelector = NSSelectorFromString([NSString stringWithFormat:@"__original_%@", NSStringFromSelector(methodSelector)]);
    BOOL addResult = class_addMethod(aClass, newOriginalSelector, method_getImplementation(original), method_getTypeEncoding(original));
    if (!addResult) os_log_error(swizzleLog(), "Failed to reintroduce original selector as %{public}@ on class %{public}@", NSStringFromSelector(newOriginalSelector), NSStringFromClass(aClass));
    if (!addResult) return NO;

    method_exchangeImplementations(original, replacement);

    return YES;
}

+ (BOOL)loadSystemFrameworkWithRelativePath:(NSString *)relativePath
{
    const char *rootPath = getenv("DYLD_ROOT_PATH");
    if (rootPath == NULL) rootPath = "";
    
    const char *relativePathStr = relativePath.UTF8String;

    size_t len = strlen(rootPath) + strlen(relativePathStr) + 2;
    char *frameworkPath = malloc(len);
    snprintf(frameworkPath, len, "%s/%s", rootPath, relativePathStr);

    void *handle = dlopen(frameworkPath, RTLD_NOW);

    if (handle == NULL) os_log_error(swizzleLog(), "Failed to load system framework %{public}s", frameworkPath);

    free(frameworkPath);

    return handle != NULL;
}

@end
