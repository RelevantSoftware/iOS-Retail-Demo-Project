//
//  NSManagedObject+MagicalExport.h
//

#import <CoreData/CoreData.h>

@interface NSManagedObject(MagicalExport)

- (NSDictionary *)dictionaryValue;
- (BOOL)shouldIgnoreAttributeWithName:(NSString *)attributeName;
- (NSDictionary *)dictionaryToAppend;

@end
