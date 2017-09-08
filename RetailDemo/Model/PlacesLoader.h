//
//  PlacesLoader.h
//  Around Me
//
//  Created by jdistler on 06.02.13.
//  Copyright (c) 2015  lexin All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Place.h"
@class CLLocation;

typedef void (^SuccessHandler)(NSDictionary *responseDict);
typedef void (^SuccessHandlerPhoto)(UIImage *responseDict);
typedef void (^ErrorHandler)(NSError *error);

@class Place;


@interface PlacesLoader : NSObject
{
    BOOL isWorksNow;

}
@property (nonatomic,strong) NSMutableDictionary* dictPlacesByCategoriesTypes;
@property (nonatomic,strong) NSMutableArray* arrPlacesTypesForReq;
@property (nonatomic,strong) NSMutableArray* arrPlacesTypes;
@property (nonatomic,strong) NSMutableArray* arrPlacesTypes_selectedIndexes;
@property (assign,readwrite) int maxCount;
+ (PlacesLoader *)sharedInstance;
- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;
- (void)loadDetailInformation:(NSString *)placeid successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;
- (void)loadPhoto:(NSString*)photo_reference withWidth:(int)w successHanlder:(SuccessHandlerPhoto)handler errorHandler:(ErrorHandler)errorHandler;
-(NSString*)convertGoogleTypeFormOur:(enum TYPE) tInput;
-(UIColor*) getColorByCategory:(enum CATEGORY)cat;
-(UIColor*) getAlternativeColorByCategory:(enum CATEGORY)cat;
-(NSString*)getNameTypeFormOur:(enum TYPE) tInput;
-(NSMutableDictionary*)makeObjectForCategorywithType:(enum TYPE) type;
@end
