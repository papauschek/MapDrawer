//
//  MVMDMapView.h
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MVMDDrawingData;


@interface MVMDMapView : UIView

//properties to scale the map and the list of countries
@property (nonatomic, strong) NSArray* countries;
@property (nonatomic, assign) CGFloat maximumLongitude;
@property (nonatomic, assign) CGFloat minimumLongitude;
@property (nonatomic, assign) CGFloat maximumLatitude;
@property (nonatomic, assign) CGFloat minimumLatitude;

//public method to initiate the UIVIew subclass
- (id)initWithFrame:(CGRect)frame andData:(MVMDDrawingData *)drawingData;
@end
