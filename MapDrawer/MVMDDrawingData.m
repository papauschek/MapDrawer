//
//  MVMDDrawingData.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDDrawingData.h"
#import "MVMDCountry.h"

// Defined all JSON keys here to prevent future errors should keys change, by having a define once approach.
static NSString * const jsonPath = @"countries_small";
static NSString * const fileFormat = @"geojson";
static NSString * const boundaryBox = @"bbox";
static NSString * const features = @"features";
static NSString * const properties = @"properties";
static NSString * const name = @"name";
static NSString * const geometry = @"geometry";
static NSString * const objType = @"type";
static NSString * const pointCoordinates = @"coordinates";
static NSString * const polygon = @"Polygon";
static NSString * const multiPolygon =@"MultiPolygon";

@implementation MVMDDrawingData

-(id)init{
    self = [super init];
    if(self != nil) {
        self.countries = [[NSMutableArray alloc] init];
        [self loadCountries];
    }
    return self;
}

-(void)loadCountries{
    
    // It extracts the information from the GeoJSON file. This information is the map boundaries, the countries and its respective borders and 'holes'
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonPath ofType:fileFormat];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    id dataObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    if([dataObject isKindOfClass:[NSDictionary class]]){
        if([dataObject objectForKey:boundaryBox]){
            [self setMapBoundariesFrom:[dataObject objectForKey:boundaryBox]];
        }
        if([dataObject objectForKey:features]){
            for (NSDictionary* countryData in [dataObject objectForKey:features]){
                MVMDCountry *country = [[MVMDCountry alloc] init];
                country.name = [[countryData objectForKey:properties] objectForKey:name]; // Name is here for possible future use
                [self setCountryBordersAndHolesFrom:[countryData objectForKey:geometry] to:country];
                [self.countries addObject:country];
            }
        }
    }
    
    //Use this piece of code to solve the issue involving countries inside the area of other i.e Lesotho inside SouthAfrica
    //It sorts the list with a very basic guess of which country is bigger depending on the number of points and draws the bigger ones first
    [self.countries sortUsingComparator:^NSComparisonResult(MVMDCountry *obj1, MVMDCountry *obj2) {
        return [obj1 getArea] < [obj2 getArea];
    }];
}

//Sets up the boundaries with information from the JSON object
-(void)setMapBoundariesFrom:(NSArray *)boundaryBox{
    self.minimumLongitude = [boundaryBox objectAtIndex:0];
    self.minimumLatitude  = [boundaryBox objectAtIndex:1];
    self.maximumLongitude = [boundaryBox objectAtIndex:2];
    self.maximumLatitude  = [boundaryBox objectAtIndex:3];
}

//This code splits the regions in the json based on whether they're regions of the country or 'holes in it' and saves them into their own Array inside the MVMDCountry object
-(void)setCountryBordersAndHolesFrom:(NSDictionary *)geometry to:(MVMDCountry *)country{
    NSMutableArray *borders = [[NSMutableArray alloc] init];
    NSMutableArray *holes;
    NSString *type = [geometry objectForKey:objType];
    NSArray *coordinates = [geometry objectForKey:pointCoordinates];
    if(type){
        if([type isEqualToString:polygon]){
            if(coordinates){
                [borders addObject:[coordinates objectAtIndex:0]];
                if([coordinates count] > 1){
                    holes = [[NSMutableArray alloc] init];
                    for(int i = 1; i<[coordinates count]; i++){
                        [holes addObject:[coordinates objectAtIndex:i]];
                    }
                }
            }
            //countries with regions in different parts of the globe.
        }else if([type isEqualToString:multiPolygon]){
            if(coordinates){
                for(NSArray* array in coordinates){
                    [borders addObject:[array objectAtIndex:0]];
                    if([array count] > 1){
                        holes = [[NSMutableArray alloc] init];
                        for(int i = 1; i<[array count]; i++){
                            [holes addObject:[array objectAtIndex:i]];
                        }
                    }
                }
            }
        }}
    country.borders = borders;
    country.holes = holes;
}


@end
