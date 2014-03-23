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
    CGRect viewRect = CGRectMake(0, 0, 2000, 2000);
    MVMDMapView* myView = [[MVMDMapView alloc] initWithFrame:viewRect andData:dd];
    
    self.scrollView.contentSize = myView.bounds.size;
    [self.scrollView addSubview:myView];
    self.scrollView.delegate = self;
    [myView setNeedsDisplay];
    self.scrollView.minimumZoomScale = self.scrollView.frame.size.width / myView.frame.size.width;
     self.scrollView.maximumZoomScale = 2.0;
    [ self.scrollView setZoomScale: self.scrollView.minimumZoomScale];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
