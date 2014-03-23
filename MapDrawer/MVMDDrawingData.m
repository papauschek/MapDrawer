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



@end
