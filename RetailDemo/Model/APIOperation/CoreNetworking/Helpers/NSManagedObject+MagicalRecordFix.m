//
//  NSManagedObject+MagicalRecordFix.m
//

#import "NSManagedObject+MagicalRecordFix.h"
#import <objc/runtime.h>
#import <MagicalRecord/MagicalRecord.h>

@implementation NSManagedObject (MagicalRecordFix)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = object_getClass((id)self);
        SEL originalSelector = NSSelectorFromString(@"MR_entityName");
        SEL swizzledSelector = @selector(_entityName);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

+ (NSString *) _entityName {
    NSMutableString *className = NSStringFromClass(self).mutableCopy;
    NSInteger dotLocation;
    while ((dotLocation = [className rangeOfString:@"."].location) != NSNotFound) {
        [className deleteCharactersInRange:NSMakeRange(0, dotLocation + 1)];
    }
    return className.copy;
}

@end
