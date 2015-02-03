//
//  ServiceAPI.h
//  KranzlePDF
//
//  Created by Steven on 01/02/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@class CLLocation;

typedef void(^MWWeatherXMLProgress)(NSInteger progressCount, NSInteger totalCount);
typedef void(^MWWeatherXMLCompletion)(NSArray *forecastItems, ...);
typedef void(^MWWeatherXMLFailure)(id responseObject, NSError * error);

@interface ServiceAPI : NSObject

+ (instancetype)sharedInstance;

- (void)getWeatherForecast:(MWWeatherXMLCompletion)completion
                 failure:(MWWeatherXMLFailure)failure progress:(MWWeatherXMLProgress)progress
                 forLocation:(CLLocation *)location;

@end
