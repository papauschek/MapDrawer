//
//  MVMDCountry.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDCountry.h"

@implementation MVMDCountry

-(NSInteger)getArea{
    return [[self.borders objectAtIndex:0] count];
}
@end
