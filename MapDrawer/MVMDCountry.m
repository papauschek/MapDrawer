//
//  MVMDCountry.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDCountry.h"

@implementation MVMDCountry

//method returns the number of points in the country shape. This was done to help solve the bug of Lesotho not showing because it was drawn before SouthAfrica
-(NSInteger)getArea{
    return [[self.borders objectAtIndex:0] count];
}
@end
