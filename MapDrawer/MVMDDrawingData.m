//
//  MVMDDrawingData.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDDrawingData.h"
#import "MVMDCountry.h"

// Used instead of define because static variables are used at runtime instead of compiling time.
static const NSString *jsonPath = @"countries_small";
static const NSString *fileFormat = @"geojson";
static const NSString *boundaryBox = @"bbox";
static const NSString *features = @"features";
static const NSString *properties = @"properties";
static const NSString *name = @"name";
static const NSString *geometry = @"geometry";
static const NSString *objType = @"type";
static const NSString *pointCoordinates = @"coordinates";
static const NSString *polygon = @"Polygon";
static const NSString *multiPolygon =@"MultiPolygon";

@implementation MVMDDrawingData

-(id)init{
    self = [super init];
    if(self != nil) {
        self.countries = [[NSMutableArray alloc] init];
        [self extractUsefulInformation];
    }
    return self;
}

-(void)extractUsefulInformation{
    
    // It extrans the information from the GeoJSON file. This info is the map boundaries, the countries and its respective borders and 'holes'
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
                country.name = [[countryData objectForKey:properties] objectForKey:name]; // Name is here mainly for debugging purposes
                [self setCountryBordersAndHolesFrom:[countryData objectForKey:geometry] to:country];
                [self.countries addObject:country];
            }
        }
    }
    
    //Use this piece of code to sort out the problem of Lesotho
    [self.countries sortUsingComparator:^NSComparisonResult(MVMDCountry *obj1, MVMDCountry *obj2) {
        return [obj1 getArea] < [obj2 getArea];
    }];
}

//Sets up the values as the boundaries
-(void)setMapBoundariesFrom:(NSArray *)boundaryBox{
    self.minimumLongitude = [boundaryBox objectAtIndex:0];
    self.minimumLatitude  = [boundaryBox objectAtIndex:1];
    self.maximumLongitude = [boundaryBox objectAtIndex:2];
    self.maximumLatitude  = [boundaryBox objectAtIndex:3];
}

//This code splits the regions in the json based on whether they're regions of the country or 'holes in it' and assign them to its respective country
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
