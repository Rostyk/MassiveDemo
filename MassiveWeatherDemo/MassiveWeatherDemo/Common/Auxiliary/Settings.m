//
//  Settings.m
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "Settings.h"
#import <CoreLocation/CoreLocation.h>

@implementation Settings

NSString * const kBaseURL = @"http://api.yr.no/weatherapi/locationforecast/1.9/?%@";

NSString * const kDefaultLatitude = @"";
NSString * const kDefaulLongitude = @"";

+ (NSString *)forecastURL:(CLLocation *)location {
    NSString *locationString = [NSString stringWithFormat:@"lat=%f;lon=%f",location.coordinate.latitude, location.coordinate.longitude];
    NSString *forecastURL = [NSString stringWithFormat:kBaseURL, locationString];
    
    return forecastURL;
}


@end
