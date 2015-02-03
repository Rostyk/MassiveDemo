//
//  MWLocationManager.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

/**
 *  Error domain used for error created directly by MWLocationManager
 */
extern NSString *const MWLocationManagerErrorDomain;

/**
 *  MWLocationManagerErrorDomain custom error codes
 */
typedef NS_ENUM(NSInteger, MWLocationManagerErrorCode) {
    MWLocationManagerErrorCodeUnknown = 0,
    MWLocationManagerErrorCodeTimedOut
};

typedef void (^MWLocationManagerCompletionHandler)(CLLocation *location, NSString *cityName, NSError *error, BOOL locationServicesDisabled);


@interface MWLocationManager : NSObject

/**
 *  Location received from Location services
 */
@property (nonatomic, readonly) CLLocation *location;

@property (nonatomic, assign) NSUInteger maxErrorsCount;
@property (nonatomic, assign) NSTimeInterval errorTimeout;

/**
 *  @return Shared singleton instance
 */
+ (MWLocationManager *)sharedManager;

- (void)updateLocationWithCompletionHandler:(MWLocationManagerCompletionHandler)completion;
- (void)getCityNameOfLocation:(CLLocation *)location completion:(MWLocationManagerCompletionHandler)completion;

@end
