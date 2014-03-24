//
//  MVMDMapView.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDMapView.h"
#import "MVMDCountry.h"
#import "MVMDDrawingData.h"

@implementation MVMDMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

//custom initialiser obtaining data from the object that got it from the json
- (id)initWithFrame:(CGRect)frame andData:(MVMDDrawingData *)drawingData
{
    self = [super initWithFrame:frame];
    if (self) {
        self.countries        = drawingData.countries;
        self.maximumLongitude = [drawingData.maximumLongitude floatValue];
        self.maximumLatitude  = [drawingData.maximumLatitude floatValue];
        self.minimumLongitude = [drawingData.minimumLongitude floatValue];
        self.minimumLatitude  = [drawingData.minimumLatitude floatValue];
        self.backgroundColor  = [UIColor whiteColor];
    }
    return self;
}

// drawing method for the rectangle
- (void)drawRect:(CGRect)rect
{
    for(MVMDCountry *country in self.countries){
        if(country.borders){
            for(NSArray *borders in country.borders){
                [self drawPolygonFromArrayOfPoints:borders withColour: [UIColor grayColor]];
            }
        }
        if(country.holes){
            for(NSArray *holes in country.holes){
                [self drawPolygonFromArrayOfPoints:holes withColour:[UIColor whiteColor]];
            }
        }
    }
}

//Translate coordinates from the values given in the JSON to values matched to the Map
-(CGPoint)translateCoodinatesToCGPointWithLongitude:(CGFloat)longitude andLatitude: (CGFloat)latitude{
    CGFloat width = self.maximumLongitude - self.minimumLongitude;
    CGFloat height = self.maximumLatitude - self.minimumLatitude;
    CGFloat trueLongitude;
    CGFloat trueLatitude;
    //converts the coordinates into iOS coordinates according to the value of the variable
    if(longitude > 0){
        trueLongitude = fabsf(self.minimumLongitude) + longitude;
        trueLongitude = (trueLongitude*self.bounds.size.width)/width;
    }
    else{
        trueLongitude = longitude - self.minimumLongitude;
        trueLongitude = (trueLongitude*self.bounds.size.width)/width;
    }
    if(latitude > 0){
        trueLatitude = self.maximumLatitude - latitude;
        trueLatitude = (trueLatitude*self.bounds.size.height)/height;
    }
    else{
        trueLatitude = self.maximumLatitude + fabsf(latitude);
        trueLatitude = (trueLatitude*self.bounds.size.height)/height;
    }
    return CGPointMake(trueLongitude, trueLatitude);
}

//Draws the polygon from the coordinate points given in the json file
-(void)drawPolygonFromArrayOfPoints:(NSArray *)array withColour:(UIColor *) colour{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, colour.CGColor); //Sets up the colour that will be used to fill the land of the country
    CGContextSetLineWidth(context, 2.0);
    
    //Draws the lines of the polygon
    for(int i = 0; i < [array count]; i++){
        CGPoint point = [self translateCoodinatesToCGPointWithLongitude: [[[array objectAtIndex:i] objectAtIndex:0] floatValue]
                                                            andLatitude:[[[array objectAtIndex:i] objectAtIndex:1] floatValue]];
        if(i == 0){
            CGContextMoveToPoint(context, point.x, point.y);
        }
        else{
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    // fills the polygon with the colour provided
    CGContextClosePath(context);
    CGContextFillPath(context);

}

@end
