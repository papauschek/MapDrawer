//
//  MVMDCountry.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDCountry.h"

@implementation MVMDCountry

//This method returns the number of points in each country. This is a basic way of measuring the size of a country
-(NSInteger)getArea{
    return [[self.borders objectAtIndex:0] count];
}
@end
