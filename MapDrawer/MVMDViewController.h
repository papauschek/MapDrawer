//
//  MVMDViewController.h
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVMDViewController : UIViewController <UIScrollViewDelegate>

-(UIImage *)drawCountriesWithData:(NSArray *)countries;

@end
