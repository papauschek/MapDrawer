//
//  MVMDCountry.h
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVMDCountry : NSObject

//properties extracted from the json will be put in here
@property (nonatomic) NSString* name;
@property (nonatomic, strong) NSArray* borders;
@property (nonatomic, strong) NSArray* holes;

-(NSInteger)getArea;
@end
