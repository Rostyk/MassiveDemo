//
//  MWForecastItemsManager.m
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

//Basically our norwegian API returns teh forecast for the nearest week
#define MAX_DAYS                                 7
#define NUMBER_OF_FORECAST_SLICES_PER_DAY        5

#import "MWForecastItemsManager.h"
@interface MWForecastItemsManager()
@property (nonatomic, strong) NSArray *forecastItems;
@property (nonatomic, strong) NSMutableArray *forecastLocations;
@end

@implementation MWForecastItemsManager

#pragma mark shared instance

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static MWForecastItemsManager *sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [self new];
                      sharedInstance.forecastLocations = [[NSMutableArray alloc] init];
                  });
    
    return sharedInstance;
}

#pragma mark manage forecast

- (void)setForecastItems:(NSArray *)forecastItems {
    _forecastItems = forecastItems;
}

- (MWForecast *)forecastForDaySinceToday:(NSUInteger)day {
    if(day > MAX_DAYS) {
        return nil;
    }
    
    NSUInteger chunk = day * NUMBER_OF_FORECAST_SLICES_PER_DAY;
    if(self.forecastItems.count < chunk) {
        return self.forecastItems[chunk];
    }
    else {
        return [self.forecastItems lastObject];
    }
}


#pragma mark forecast locations

- (void)addForecastLocation:(MWLocation *)forecastLocation {
    [self.forecastLocations addObject:forecastLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MWReloadSideBarMenu" object:nil];
}

- (NSArray *)locations {
    return self.forecastLocations;
}

- (MWLocation *)locationAtIndex:(NSUInteger)index {
    if(self.forecastLocations.count > index)
       return self.forecastLocations[index];
    
    return nil;
}

@end
