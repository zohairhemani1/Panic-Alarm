//
//  Map.m
//  Panic AAlaram Application
//
//  Created by Zainu Corporation on 17/05/2014.
//  Copyright (c) 2014 Zohair Hemani - Stanford Assignment. All rights reserved.
//


#import "Map.h"
#import <CoreLocation/CoreLocation.h>
#import "checkInternet.h"
#import "Log.h"
#define METERS_PER_MILE 1609.344
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface Map (){
    checkInternet *c;

    NSString *srcText;
    NSString *destText;
    
    int count;
    
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
    MKDirectionsRequest *directionsRequest;

}

@end

@implementation Map

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
	// Do any additional setup after loading the view.
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    directionsRequest = [MKDirectionsRequest new];
    
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    
    [directionsRequest setSource:source];
    
    CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(self.destinationLatitude, self.destinationLongitude);
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    [directionsRequest setDestination:destination];
    
    MKPointAnnotation *destPin = [[MKPointAnnotation alloc] init];
    destPin.coordinate = CLLocationCoordinate2DMake(self.destinationLatitude, self.destinationLongitude);
    
    destPin.title = self.pinTitle;
    destPin.subtitle = self.pinSubtitle;
        
    [self.mapView addAnnotation:destPin];
    
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

//  NSLog(@"the map is %f",source.placemark.location.coordinate.longitude);
//  CLLocationCoordinate2D sourceCoords = CLLocationCoordinate2DMake([[[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"]floatValue], [[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]floatValue]);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(destinationCoords, 1000.0*METERS_PER_MILE, 100.0*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)route:(id)sender {
    
    [self drawDirections];
  
}

-(void)drawDirections
{
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"There was an error getting your directions");
            return;
        }
        
        _currentRoute = [response.routes firstObject];
        [self plotRouteOnMap:_currentRoute];
    }];
}

#pragma mark - Utility Methods
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mapView removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mapView addOverlay:_routeOverlay];
    
}


#pragma mark - MKMapViewDelegate methods
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 2.0;
    return renderer;
}

@end

