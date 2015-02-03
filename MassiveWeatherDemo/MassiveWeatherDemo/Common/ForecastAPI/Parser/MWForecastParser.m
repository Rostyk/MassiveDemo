//
//  MWForecastParser.m
//  MassiveWeatherDemo
//
//  Created by Ross on 2/3/15.
//  Copyright (c) 2015 Massive. All rights reserved.
//

#import "MWForecastParser.h"
#import "XMLDictionary.h"
#import "MWForecast.h"

@implementation MWForecastParser

- (NSArray *)forecastItemsOfXML:(NSXMLParser *)xmlParser {
    NSDictionary *dictionary = [NSDictionary dictionaryWithXMLParser:xmlParser];
    return [self parseValues:dictionary[@"product"][@"time"]];
}


/* Parse forecast xml into model objects;
 (!)Move all the onstant strings to separate header later */

- (NSArray *)parseValues:(NSArray *)timeSlotForecasts {
    NSMutableArray *forecastItems = [[NSMutableArray alloc] init];
    
    for (NSDictionary *forecastLocation in timeSlotForecasts) {
        NSDictionary *forecast = forecastLocation[@"location"];
        float clouds = 0.0;
        NSString *temperature = nil;
        NSString *windDirection = nil;
        float windSpeed = 0.0;
        NSDate *date = nil;
        float humidity = 0.0;
        
        if([forecast objectForKey:@"temperature"]) {
            temperature = forecast[@"temperature"][@"_value"];
        }
        if([forecast objectForKey:@"cloudiness"]) {
            clouds = [forecast[@"cloudiness"][@"_percent"] floatValue];
        }
        if([forecast objectForKey:@"windDirection"]) {
            windDirection = forecast[@"windDirection"][@"_name"];
        }
        if([forecast objectForKey:@"windSpeed"]) {
            windSpeed = [forecast[@"windSpeed"][@"_mps"] floatValue];
        }
        if([forecast objectForKey:@"humidity"]) {
            humidity = [forecast[@"humidity"][@"_value"] floatValue];
        }
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy:MM:dd'T'HH:mm:ss'Z'"];
        date = [dateFormat dateFromString:forecastLocation[@"_from"]];
        
        if(temperature && windSpeed > 0.0 && windDirection && clouds > 0.0) {
            MWForecast *forecastItem = [[MWForecast alloc] init];
            forecastItem.date = date;
            forecastItem.windDirection = windDirection;
            forecastItem.windSpeed = windSpeed;
            forecastItem.clouds = clouds;
            forecastItem.temperature = temperature;
            forecastItem.humidity = humidity;
            [forecastItems addObject:forecastItem];
        }
    }
    
    return forecastItems;
}

@end
