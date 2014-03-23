//
//  MVMDMapView.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDMapView.h"
#import "MVMDDrawingData.h"
#import "MVMDCountry.h"

@implementation MVMDMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

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

 //Only override drawRect: if you perform custom drawing.
 //An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    for(MVMDCountry *country in self.countries){
        
        if(country.borders){
            for(NSArray *borders in country.borders){
                [self drawPolygonFromArrayOfPoints:borders withColour: [UIColor grayColor]];
                NSLog(@"Drawing %@ now", country.name);
            }
        }
        if(country.holes){
            for(NSArray *holes in country.holes){
                [self drawPolygonFromArrayOfPoints:holes withColour:[UIColor whiteColor]];
            }
        }
    }
}


-(CGPoint)translateCoodinatesToCGPointWithLongitude:(CGFloat)longitude andLatitude: (CGFloat)latitude{
    CGFloat width = self.maximumLongitude - self.minimumLongitude;
    CGFloat height = self.maximumLatitude - self.minimumLatitude;
    CGFloat trueLongitude;
    CGFloat trueLatitude;
    if(longitude > 0){
        trueLongitude = fabsf(self.minimumLongitude) + longitude;
        trueLongitude = (trueLongitude*320)/width;
    }
    else{
        trueLongitude = self.minimumLongitude - longitude;
        trueLongitude = (trueLongitude*320)/width;
    }
    if(latitude > 0){
        trueLatitude = self.maximumLatitude - latitude;
        trueLatitude = (trueLatitude*568)/height;
    }
    else{
        trueLatitude = self.maximumLatitude + fabsf(latitude);
        trueLatitude = (trueLatitude*568)/height;
    }
    NSLog(@"True values are %f and %f", trueLongitude, trueLatitude);
    return CGPointMake(trueLongitude, trueLatitude);
}

-(void)drawPolygonFromArrayOfPoints:(NSArray *)array withColour:(UIColor *) color{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    

    for(int i = 0; i < [array count]; i++)
    {
        
        CGPoint point = [self translateCoodinatesToCGPointWithLongitude: [[[array objectAtIndex:i] objectAtIndex:0] floatValue]
                                                             andLatitude:[[[array objectAtIndex:i] objectAtIndex:1] floatValue]];
        if(i == 0)
        {
            CGContextMoveToPoint(context, point.x, point.y);
        }
        else
        {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    
    CGContextStrokePath(context);
}

@end
