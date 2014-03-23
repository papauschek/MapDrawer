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
    
    CGRect viewRect = CGRectMake(0, 0, 2000, 2000);
    self.myView = [[MVMDMapView alloc] initWithFrame:viewRect andData:dd];
    
    self.scrollView.contentSize = self.myView.bounds.size;
    [self.scrollView addSubview:self.myView];
    self.scrollView.delegate = self;
    [self.myView setNeedsDisplay];
    self.scrollView.minimumZoomScale = 0.3;
     self.scrollView.maximumZoomScale = 4.0;
    [ self.scrollView setZoomScale: self.scrollView.minimumZoomScale];

    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.myView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
