//
//  PlacesLoader.m
//  Around Me
//
//  Created by jdistler on 06.02.13.
//  Copyright (c) 2015  lexin All rights reserved.
//

#import "PlacesLoader.h"

#import <CoreLocation/CoreLocation.h>
#import <Foundation/NSJSONSerialization.h>


//#import "var.h"

NSString * const apiURL = @"https://maps.googleapis.com/maps/api/place/";
//NSString * const apiKey = @"AIzaSyDFoGdRdyVe_dcPXHwxgxI9MfOUJWOd3C8";
//NSString * const apiKey = @"AIzaSyCDtEi-FAHnyCsJJizGzbJUdanTtxCclPU";

//AIzaSyCPaqwvuEOavbArYFG7RmTmR0jgqRi5WH0 - relevant

//AIzaSyCDtEi-FAHnyCsJJizGzbJUdanTtxCclPU -romanko
NSString * const apiKey = @"AIzaSyD0YfVGtW9M_qi6AWPvetgSmMBGCTsKn_4";


@interface PlacesLoader ()

@property (nonatomic, strong) SuccessHandler successHandler;
@property (nonatomic, strong) SuccessHandlerPhoto successHandlerPhoto;
@property (nonatomic, strong) ErrorHandler errorHandler;
@property (nonatomic, strong) NSMutableData *responseData;

@end


@implementation PlacesLoader

+ (PlacesLoader *)sharedInstance {
    static PlacesLoader *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[PlacesLoader alloc] init];

    });
    return instance;
}

-(NSMutableDictionary*)makeObjectForCategorywithType:(enum TYPE) type
{
    NSMutableDictionary* d = [NSMutableDictionary dictionary];


    [d setObject:[self getNameTypeFormOur:type] forKey:@"name"];
    [d setObject:[self convertGoogleTypeFormOur:type] forKey:@"type"];
    [d setObject:[self getIconNameTypeFormOur:type] forKey:@"icon"];

    NSString* sPin = [self getIconNameTypeFormOur:type] ;
    sPin = [sPin stringByReplacingOccurrencesOfString:@"_list" withString:@""];
    [d setObject:sPin forKey:@"pin"];


    return d;
}
-(NSString*)getIconNameTypeFormOur:(enum TYPE) tInput
{
    switch (tInput) {
        case TYPE_AIRPORT: return @"airport_list";
        case TYPE_ART_GALLERY: return @"art_gallery_list";
        case TYPE_BANK: return @"bank_list";
        case TYPE_BAR: return @"bar_list";
        case TYPE_BEAUTY: return @"beauty_list";
        case TYPE_BUS_STATION: return @"bus_station_list";
        case TYPE_CAFE: return @"cafe_list";
        case TYPE_CHURCH: return @"church_list";
        case TYPE_DOCTOR: return @"doctor_list";
        case TYPE_EMBASSY: return @"embassy_list";
        case TYPE_ESTABLISHMENT: return @"establishment_list";
        case TYPE_FINANCE: return @"finance_list";
        case TYPE_FOOD: return @"food_list";
        case TYPE_GROCERY: return @"grocery_list";
        case TYPE_GYM: return @"gym_list";
        case TYPE_GAS_STATION: return @"gas_station_list";
        case TYPE_HEALTH: return @"health_list";
        case TYPE_HOSPITAL: return @"hospital_list";
        case TYPE_LAWYER: return @"lawyer_list";
        case TYPE_GOVERMENT: return @"goverment_list";
        case TYPE_MEAL_ORDER: return @"meal_list";
        case TYPE_MOVIE: return @"movie_list";
        case TYPE_MUSEUM: return @"museum_list";
        case TYPE_NIGHT_CLUB: return @"night_club_list";
        case TYPE_PARK: return @"park_list";
        case TYPE_PARKING: return @"parking_list";
        case TYPE_PHARMACY: return @"pharmacy_list";
        case TYPE_POLICE: return @"police_list";
        case TYPE_POST_OFFICE: return @"post_office_list";
        case TYPE_RESTAURANT: return @"restaurant_list";
        case TYPE_SPA_SALON: return @"spa_salon_list";
        case TYPE_STADIUM: return @"stadium_list";
        case TYPE_STORE: return @"store_list";
        case TYPE_SUBWAY: return @"subway_list";
        case TYPE_TAXI: return @"taxi_list";
        case TYPE_TRAIN: return @"train_list";
        case TYPE_TRAVEL_AG: return @"travel_agency_list";
        case TYPE_UNIVERSITY: return @"university_list";
        case TYPE_ZOO: return @"zoo_list";

            break;

        default:
            break;
    }
    return @"";
}
-(NSString*)getNameTypeFormOur:(enum TYPE) tInput
{
    switch (tInput) {
        case TYPE_AIRPORT: return @"Airport";
        case TYPE_ART_GALLERY: return @"Art gallery";
        case TYPE_BANK: return @"Bank";
        case TYPE_BAR: return @"Bar";
        case TYPE_BEAUTY: return @"Beauty";
        case TYPE_BUS_STATION: return @"Bus station";
        case TYPE_CAFE: return @"Cafe";
        case TYPE_CHURCH: return @"Church";
        case TYPE_DOCTOR: return @"Doctor";
        case TYPE_EMBASSY: return @"Embassy";
        case TYPE_ESTABLISHMENT: return @"Establishment";
        case TYPE_FINANCE: return @"Finance";
        case TYPE_FOOD: return @"Food";
        case TYPE_GROCERY: return @"Grocery";
        case TYPE_GYM: return @"Gym";
        case TYPE_GAS_STATION: return @"Gas station";
        case TYPE_HEALTH: return @"Health";
        case TYPE_HOSPITAL: return @"Hospital";
        case TYPE_LAWYER: return @"Lawyer";
        case TYPE_GOVERMENT: return @"Government";
        case TYPE_MEAL_ORDER: return @"Meal order";
        case TYPE_MOVIE: return @"Movie";
        case TYPE_MUSEUM: return @"Museum";
        case TYPE_NIGHT_CLUB: return @"Night club";
        case TYPE_PARK: return @"Park";
        case TYPE_PARKING: return @"Parking";
        case TYPE_PHARMACY: return @"Pharmacy";
        case TYPE_POLICE: return @"Police";
        case TYPE_POST_OFFICE: return @"Post office";
        case TYPE_RESTAURANT: return @"Restaurant";
        case TYPE_SPA_SALON: return @"Spa";
        case TYPE_STADIUM: return @"Stadium";
        case TYPE_STORE: return @"Store";
        case TYPE_SUBWAY: return @"Subway";
        case TYPE_TAXI: return @"Taxi";
        case TYPE_TRAIN: return @"Train";
        case TYPE_TRAVEL_AG: return @"Travel ag.";
        case TYPE_UNIVERSITY: return @"University";
        case TYPE_ZOO: return @"Zoo";

            break;

        default:
            break;
    }
    return @"";
}
-(NSString*)convertGoogleTypeFormOur:(enum TYPE) tInput
{
    switch (tInput) {
        case TYPE_AIRPORT: return @"airport";
        case TYPE_ART_GALLERY: return @"art_gallery";
        case TYPE_BANK: return @"bank";
        case TYPE_BAR: return @"bar";
        case TYPE_BEAUTY: return @"beauty_salon";
        case TYPE_BUS_STATION: return @"bus_station";
        case TYPE_CAFE: return @"cafe";
        case TYPE_CHURCH: return @"church";
        case TYPE_DOCTOR: return @"doctor";
        case TYPE_EMBASSY: return @"embassy";
        case TYPE_ESTABLISHMENT: return @"establishment";
        case TYPE_FINANCE: return @"finance";
        case TYPE_FOOD: return @"food";
        case TYPE_GROCERY: return @"grocery_or_supermarket";
        case TYPE_GYM: return @"gym";
        case TYPE_GAS_STATION: return @"gas_station";
        case TYPE_HEALTH: return @"health";
        case TYPE_HOSPITAL: return @"hospital";
        case TYPE_LAWYER: return @"lawyer";
        case TYPE_GOVERMENT: return @"local_government_office";
        case TYPE_MEAL_ORDER: return @"meal_delivery|meal_takeaway";
        case TYPE_MOVIE: return @"movie_theater";
        case TYPE_MUSEUM: return @"museum";
        case TYPE_NIGHT_CLUB: return @"night_club";
        case TYPE_PARK: return @"park";
        case TYPE_PARKING: return @"parking";
        case TYPE_PHARMACY: return @"pharmacy";
        case TYPE_POLICE: return @"police";
        case TYPE_POST_OFFICE: return @"post_office";
        case TYPE_RESTAURANT: return @"restaurant";
        case TYPE_SPA_SALON: return @"spa";
        case TYPE_STADIUM: return @"stadium";
        case TYPE_STORE: return @"store";
        case TYPE_SUBWAY: return @"subway_station";
        case TYPE_TAXI: return @"taxi_stand";
        case TYPE_TRAIN: return @"train_station";
        case TYPE_TRAVEL_AG: return @"travel_agency";
        case TYPE_UNIVERSITY: return @"university";
        case TYPE_ZOO: return @"zoo";

            break;

        default:
            break;
    }
    return @"";
}

-(UIColor*) getColorByCategory:(enum CATEGORY)cat
{
    UIColor*color = [UIColor grayColor];

    switch (cat) {

        case CATEGORY_TRANSPORT:
            color = [UIColor colorWithRed:0.0 green:0.46 blue:1.0 alpha:1.0];
            break;
        case CATEGORY_SHOPPING:
            color = [UIColor colorWithRed:1.0 green:0.60 blue:0.0 alpha:1.0];
            break;
        case CATEGORY_ACTIVITIES:
            color = [UIColor colorWithRed:0.10 green:0.67 blue:0.00 alpha:1.0];
            break;
        case CATEGORY_BUILDINGS:
            color = [UIColor colorWithRed:0.99 green:0.16 blue:0.31 alpha:1.0];
            break;
        case CATEGORY_SERVICES:
            color = [UIColor colorWithRed:0.49 green:0.17 blue:0.84 alpha:1.0];
            break;
        default:
            break;
    }
    return color;
}

-(UIColor*) getAlternativeColorByCategory:(enum CATEGORY)cat
{
    UIColor*color_2 = [UIColor grayColor];

    switch (cat) {

        case CATEGORY_TRANSPORT:
            color_2 = [UIColor colorWithRed:0.63 green:0.51 blue:0.88 alpha:1];
            break;
        case CATEGORY_SHOPPING:
            color_2 = [UIColor colorWithRed:0.99 green:0.51 blue:0.5 alpha:1];
            break;
        case CATEGORY_ACTIVITIES:
            color_2 = [UIColor colorWithRed:0.55 green:0.82 blue:0.48 alpha:1];
            break;
        case CATEGORY_BUILDINGS:
            color_2 = [UIColor colorWithRed:0.96 green:0.47 blue:0.68 alpha:1];
            break;
        case CATEGORY_SERVICES:
            color_2 = [UIColor colorWithRed:0.49 green:0.17 blue:0.84 alpha:1];
            break;
        default:
            break;
    }
    return color_2;
}


-(id)init
{
    self = [super init];
    self.arrPlacesTypes = [NSMutableArray array];
    self.arrPlacesTypesForReq = [NSMutableArray array];
    self.arrPlacesTypes_selectedIndexes = [NSMutableArray array];
    self.dictPlacesByCategoriesTypes = [NSMutableDictionary dictionary];

    NSMutableDictionary* dDefault  = [NSMutableDictionary dictionary];
    [dDefault  setObject:@"cafe" forKey:@"type"];
    [dDefault  setObject:@"Cafe" forKey:@"name"];
    [dDefault  setObject:@"cafe_list" forKey:@"icon"];
    [dDefault  setObject:@"cafe" forKey:@"pin"];
    [self.arrPlacesTypesForReq addObject:dDefault];

  
    return self;
}

- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    if (isWorksNow==false)
    {

        _responseData = nil;
        _successHandler = handler;
        _errorHandler = errorHandler;
        CLLocationDegrees latitude = [location coordinate].latitude;
        CLLocationDegrees longitude = [location coordinate].longitude;

        NSMutableString *uri = [NSMutableString stringWithString:apiURL];
        NSString* str = @"cafe";
        if ([[PlacesLoader sharedInstance].arrPlacesTypesForReq count]>0)
            str=@"";

        NSMutableArray* arr = [NSMutableArray array];

        for (NSDictionary*d in [PlacesLoader sharedInstance].arrPlacesTypesForReq)
        {
            if (![arr containsObject:d]) {
                [arr addObject:d];
            }
        }

        for (NSDictionary*d in arr)
        {
            NSString* strAdd = [d objectForKey:@"type"];
            if ([str length]<1)
                str = [NSString stringWithFormat:@"%@",strAdd];
            else
                str = [NSString stringWithFormat:@"%@|%@",str,strAdd];


        }
        //rankby prominence
        //[uri appendFormat:@"nearbysearch/json?location=%f,%f&radius=%d&sensor=true&types=%@&rankBy=distance&key=%@", latitude, longitude, radius, str,apiKey];

        //rankby distance
        [uri appendFormat:@"nearbysearch/json?types=%@&location=%f,%f&sensor=true&rankby=distance&key=%@", str, latitude, longitude,apiKey];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];

        [request setHTTPShouldHandleCookies:YES];
        [request setHTTPMethod:@"GET"];


        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        isWorksNow=true;
        NSLog(@"Starting connection: %@ for request: %@", connection, request);
    }
}

- (void)loadDetailInformation:(NSString *)placeid successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    _responseData = nil;
    _successHandler = handler;
    _errorHandler = errorHandler;

    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    [uri appendFormat:@"details/json?placeid=%@&key=%@", placeid, apiKey];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];

    [request setHTTPShouldHandleCookies:YES];
    [request setHTTPMethod:@"GET"];


    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    NSLog(@"Starting connection: %@ for request: %@", connection, request);
}

- (void)loadPhoto:(NSString*)photo_reference withWidth:(int)w successHanlder:(SuccessHandlerPhoto)handler errorHandler:(ErrorHandler)errorHandler {
    _responseData = nil;
    _successHandlerPhoto = handler;

    _errorHandler = errorHandler;

    NSMutableString *uri = [NSMutableString stringWithString:apiURL];
    [uri appendFormat:@"photo?photo_reference=%@&maxwidth=%d&key=%@", photo_reference, w,apiKey];


    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);

    dispatch_async(backgroundQueue, ^{
        UIImage* im = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];

        dispatch_async(dispatch_get_main_queue(), ^{
            if(_successHandlerPhoto) {


                _successHandlerPhoto(im);
            }

        });
    });

}



#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if(!_responseData) {
        _responseData = [NSMutableData dataWithData:data];
    } else {
        [_responseData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    isWorksNow=false;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];


    id object = nil;
    object = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingAllowFragments error:nil];

        
    if(_successHandler) {
        _successHandler(object);
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    isWorksNow=false;
    if(_errorHandler) {
        _errorHandler(error);
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
