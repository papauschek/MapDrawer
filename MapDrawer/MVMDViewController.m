//
//  MVMDViewController.m
//  MapDrawer
//
//  Created by Rodrigo Escobar on 23/03/2014.
//  Copyright (c) 2014 Rodrigo Escobar. All rights reserved.
//

#import "MVMDViewController.h"
#import "MVMDDrawingData.h"
#import "MVMDMapView.h"

@interface MVMDViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MVMDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MVMDDrawingData *dd = [[MVMDDrawingData alloc] init];
    
    //CGRect  viewRect = CGRectMake(0, 0, fabsf([dd.maximumLongitude floatValue]) + fabsf([dd.minimumLongitude floatValue]),fabsf([dd.maximumLatitude floatValue]) + fabsf([dd.minimumLatitude floatValue]));
    CGRect viewRect = CGRectMake(0, 0, 320, 568);
    MVMDMapView* myView = [[MVMDMapView alloc] initWithFrame:viewRect andData:dd];
    
    self.scrollView.contentSize = myView.bounds.size;
    [self.scrollView addSubview:myView];
    [myView setNeedsDisplay];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
