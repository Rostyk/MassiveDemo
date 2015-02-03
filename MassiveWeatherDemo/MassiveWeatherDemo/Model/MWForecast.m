//
//  MWForecast.m
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import "MWForecast.h"

@implementation MWForecast

- (UIImage *)icon {
    UIImage *icon = nil;
    if(self.clouds > 0.0 && self.clouds <= 10.0) {
        icon = [UIImage imageNamed:@"sunny"];
    }
    if(self.clouds > 10.0 && self.clouds <= 50.0) {
        icon = [UIImage imageNamed:@"sunny_cloudy"];
    }
    if(self.clouds > 50.0 && self.clouds <= 60.0) {
        icon = [UIImage imageNamed:@"most_cloudy"];
    }
    if(self.clouds > 60.0 && self.clouds <= 100.0) {
        icon = [UIImage imageNamed:@"cloudy"];
    }
    if(self.windSpeed > 10.0) {
        icon = [UIImage imageNamed:@"wind"];
    }
    
    return icon;
}

@end
