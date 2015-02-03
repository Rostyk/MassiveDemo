//
//  MWForecastItemsManager.h
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MWForecast;
@class MWLocation;

@interface MWForecastItemsManager : NSObject

+ (instancetype)sharedManager;
- (void)setForecastItems:(NSArray *)forecastItems;

- (MWForecast *)forecastForDaySinceToday:(NSUInteger)day;
- (void)addForecastLocation:(MWLocation *)forecastLocation;

- (NSArray *)locations;
- (MWLocation *)locationAtIndex:(NSUInteger)index;
@end
