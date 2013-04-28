//
//  CoreWeatherTestsViewController.m
//  CoreWeatherTests
//
//  Created by Patrick Perini on 2/20/13.
//  Copyright (c) 2013 MegaBits. All rights reserved.
//

#import "CoreWeatherTestsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CoreWeather.h"

@interface CoreWeatherTestsViewController ()

@end

@implementation CoreWeatherTestsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude: 40.4547330
                                                 longitude: -79.982208];
    
    [CWForecaster setAPIKey: @"cyjevzbjacc3nhd2yh632cxy"];
    [CWForecaster dailyForecastsForLocation: loc forNumberOfDays: 2 completion:^(NSArray *forecasts) {
        NSLog(@"%@", forecasts);
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
