//
//  MVMDMapView.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDMapView.h"
#import "MVMDDrawingData.h"

@implementation MVMDMapView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = UIColor.whiteColor;
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame andData:(MVMDDrawingData *)drawingData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.countries = drawingData.countries;
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

 //Only override drawRect: if you perform custom drawing.
 //An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for(NSArray *country in self.countries){
        if([country.holes count] > 1){
            for(NSArray *borders in country.borders){
                
            }
        }
    }
}

#pragma to-do
////
//- (CGPoint)geojsonCoordinateToCGPoint:(id)geojsonpoint withinRect:(CGRect)bounds{
//    
//}

@end
