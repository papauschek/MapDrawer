//
//  MVMDViewController.h
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVMDMapView.h"

@interface MVMDViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) MVMDMapView* myView;
-(UIImage *)drawCountriesWithData:(NSArray *)countries;

@end
