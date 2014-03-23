//
//  MVMDDrawingData.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDDrawingData.h"
#import "MVMDCountry.h"

@implementation MVMDDrawingData

-(id)init{
    self = [super init];
    if(self != nil) {
        self.countries = [[NSMutableArray alloc]init];
        [self extractUsefulInformation];
    }
    return self;
}

-(void)extractUsefulInformation{
    
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countries_small" ofType:@"geojson"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    id dataObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    if([dataObject isKindOfClass:[NSDictionary class]]){
        [self setMapBoundariesFrom:[dataObject objectForKey:@"bbox"]];
        for (NSDictionary* countryData in [dataObject objectForKey:@"features"]){
            MVMDCountry *country = [[MVMDCountry alloc]init];
            country.name = [[countryData objectForKey:@"properties"] objectForKey:@"name"];
            [self setCountryBordersAndHolesFrom:[countryData objectForKey:@"geometry"] to:country];
            [self.countries addObject:country];
        }
    }
}

-(void)setMapBoundariesFrom:(NSArray *)boundaryBox{
    self.minimumLongitude = [boundaryBox objectAtIndex:0];
    self.minimumLatitude  = [boundaryBox objectAtIndex:1];
    self.maximumLongitude = [boundaryBox objectAtIndex:2];
    self.maximumLatitude  = [boundaryBox objectAtIndex:3];
}

-(void)setCountryBordersAndHolesFrom:(NSDictionary *)geometry to:(MVMDCountry *)country{
    NSMutableArray *borders = [[NSMutableArray alloc]init];
    NSMutableArray *holes = [[NSMutableArray alloc]init];
    NSString *type = [geometry objectForKey:@"type"];
    NSArray *coordinates = [geometry objectForKey:@"coordinates"];
    
    if([type isEqualToString:@"Polygon"]){
        
        [borders addObject:[coordinates objectAtIndex:0]];
        if([coordinates count] > 1){
            for(int i = 1; i<[coordinates count]; i++){
                [holes addObject:[coordinates objectAtIndex:i]];
            }
        }
    }else if([type isEqualToString:@"MultiPolygon"]){
        for(NSArray* array in coordinates){
            [borders addObject:[array objectAtIndex:0]];
            if([array count] > 1){
                for(int i = 1; i<[array count]; i++){
                    [holes addObject:[array objectAtIndex:i]];
                }
            }
        }
    }
    country.borders = borders;
    country.holes = holes;
}


@end
