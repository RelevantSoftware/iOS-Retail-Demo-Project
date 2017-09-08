//
//  NSManagedObject+MagicalExport.m
//

#import "NSManagedObject+MagicalExport.h"
#import <MagicalRecord/MagicalRecord.h>

NSString * const kMagicalRecordExportableKey             = @"exportable";

@implementation NSManagedObject(MagicalExport)

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary addEntriesFromDictionary:[self dictionaryWithAttributes]];
    [dictionary addEntriesFromDictionary:[self dictionaryWithRelationships]];
    [dictionary addEntriesFromDictionary:[self dictionaryToAppend]];
    
    return dictionary.copy;
}

- (NSDictionary *)dictionaryWithAttributes {
    NSMutableDictionary *dictionaryWithAttributes = [NSMutableDictionary new];
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attributeName in attributes) {
        if (![self shouldIgnoreAttributeWithName:attributeName]) {
            NSAttributeDescription *attributeInfo = attributes[attributeName];
            NSString *lookupKey = [attributeInfo userInfo][kMagicalRecordImportAttributeKeyMapKey] ? : attributeName;
            id value = [self valueForKey:attributeName];
            if ([value isKindOfClass:[NSDate class]]) {
                NSString *dateFormat = attributeInfo.userInfo[kMagicalRecordImportCustomDateFormatKey] ?: kMagicalRecordImportDefaultDateFormatString;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = dateFormat;
                value = [dateFormatter stringFromDate:value];
            }
            if (value) {
                dictionaryWithAttributes[lookupKey] = value;
            }
        }
    }
    return dictionaryWithAttributes.copy;
}

- (NSDictionary *)dictionaryWithRelationships {
    NSDictionary *relationships = [[self entity] relationshipsByName];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    for(NSString *relationshipName in relationships) {
        NSRelationshipDescription *relationshipInfo = [relationships valueForKey:relationshipName];
        
        BOOL exportable = [[[relationshipInfo userInfo] valueForKey:kMagicalRecordExportableKey] boolValue];
        if(!exportable) continue;
        
        [result addEntriesFromDictionary:[self dictionaryForRelationshipDescription:relationshipInfo]];
    }
    return result.copy;
}

- (NSDictionary *)dictionaryForRelationshipDescription:(NSRelationshipDescription *)relationshipInfo {
    NSString *relationshipName = relationshipInfo.name;
    NSString *lookupKey = [[relationshipInfo userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey] ?: relationshipName;
    if(relationshipInfo.isToMany) {
        id<NSFastEnumeration> managedObjects = [self valueForKey:relationshipName];
        NSMutableArray *collection = [NSMutableArray array];
        for(NSManagedObject *managedObject in managedObjects) {
            [collection addObject:managedObject.dictionaryValue];
        }
        return @{lookupKey : collection};
    } else {
        NSManagedObject *managedObject = [self valueForKey:relationshipName];
        return @{lookupKey : managedObject.dictionaryValue};
    }
}

- (BOOL)shouldIgnoreAttributeWithName:(NSString *)attributeName {
    return NO;
}

- (NSDictionary *)dictionaryToAppend {
    return @{};
}

@end
