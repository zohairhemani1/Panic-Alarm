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
#import "Victims.h"

@interface Map (){
    checkInternet *c;
    float srcLat;
    float srcLon;
    float destLat;
    float destLon;
    NSString *srcText;
    NSString *destText;
    
    UIImage *img;
    NSString *profilePic ;
    NSString *imagePathString ;
    NSURL *imagePathUrl;
    NSData *data ;
    int count;
}

@end

@implementation Map

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
	// Do any additional setup after loading the view.
    
    c = [[checkInternet alloc]init];
    [c viewWillAppear:YES];
    
    count = 0;
    
    srcLat = 40.740010;
    srcLon = -73.997582;
    destLat = 40.740514;
    destLon = -74.001208;
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
//    srcText = @"Here is source";
//    destText = @"Here is Victim";
    
    (self.navigationController.navigationBar).titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
        //destLat = [[[Victims getPanicFromArray] valueForKey:@"latitude"][self.panicPersonId]floatValue];
        //destLon = [[[Victims getPanicFromArray] valueForKey:@"longitude"][self.panicPersonId]floatValue];

}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)route:(id)sender {
    
    NSLog(@"map is routing");
    
    MKPlacemark *myplace= [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(srcLat,srcLon) addressDictionary:nil];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:myplace];
    srcMapItem.name = @"";
    
    MKPlacemark *destplace= [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(destLat, destLon) addressDictionary:nil];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destplace];
    distMapItem.name = @"";
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(srcLat, srcLon);
    point.title = srcText;
    
    [self.mapView addAnnotation:point];
    
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate = CLLocationCoordinate2DMake(destLat, destLon);
    point2.title = destText;
    
    [self.mapView addAnnotation:point2];

    [self findDirectionsFrom:srcMapItem to:distMapItem];
  
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
    if (!pinView)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = [[UIColor whiteColor]CGColor];
        CGRect rect = CGRectMake(2,2,46,43);
        [imageView setFrame:rect];
        
        imageView.layer.cornerRadius=22.0;
        imageView.layer.masksToBounds=YES;
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:SFAnnotationIdentifier] ;
        
        if(count == 0)
        {
            profilePic = [[Victims getPanicFromArray] valueForKey:@"pic"][self.panicPersonId];
            imagePathString = @"http://fajjemobile.info/iospanic/assets/upload/";
            imagePathString = [imagePathString stringByAppendingString:profilePic];
            imagePathUrl = [NSURL URLWithString:imagePathString];
            data = [[NSData alloc]initWithContentsOfURL:imagePathUrl];
        
            img = [[UIImage alloc]initWithData:data];
            imageView.image = img;
            count ++;
        }
        else
        {
            NSData* myEncodedImageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userImage"];
            img = [UIImage imageWithData:myEncodedImageData];

            imageView.image = img;
        }
        
        [annotationView addSubview:imageView];
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}

//-(UIImage *)resizeUIImage: (UIImage *)providedImage giveRectangle:(CGRect)rectangle
//{
//    UIGraphicsBeginImageContext( rectangle.size );
//    [providedImage drawInRect:rectangle];
//    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    NSData *imageData = UIImagePNGRepresentation(picture1);
//    UIImage *img2=[UIImage imageWithData:imageData];
//    return img2;
//}

- (void)showDirections:(MKDirectionsResponse *)response
{
    for (MKRoute *route in response.routes)
    {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
}

- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.destination = destination;
    //request.requestsAlternateRoutes = YES;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         if (error) {
             NSLog(@"Error is %@",error);
         } else {
             [self didLoadedDirections:response];
         }
     }];
}

- (void)didLoadedDirections:(MKDirectionsResponse *)response
{
    MKRoute *route = (response.routes).firstObject;
    [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    
    NSMutableArray *_steps = [NSMutableArray arrayWithCapacity:(route.steps).count];
    for (MKRouteStep *_step in route.steps) {
        [_steps addObject:_step.instructions];
    }
    //self.routeSteps = _steps;
    
    //Set visible map rect
    MKMapRect zoomRect = MKMapRectNull;
    for (int idx = 0; idx < sizeof(route.polyline.points); idx++) {
        MKMapPoint annotationPoint = route.polyline.points[idx];
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    zoomRect = MKMapRectInset(zoomRect, -3000, -3000);
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
        MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polylineRender.lineWidth = 3.0f;
        polylineRender.strokeColor = [UIColor blueColor];
        return polylineRender;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self viewWillDisappear:YES];
}


//- (IBAction)zoomToCurrentLocation:(id)sender {
//
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [self.locationManager startUpdatingLocation];
//
//    float spanX = 0.00725;
//    float spanY = 0.00725;
//    MKCoordinateRegion region;
//    region.center.latitude = self.locationManager.location.coordinate.latitude;
//    region.center.longitude = self.locationManager.location.coordinate.longitude;
//    region.span.latitudeDelta = spanX;
//    region.span.longitudeDelta = spanY;
//    [self.mapView setZoomEnabled:YES];
//    [self.mapView setScrollEnabled:YES];
//
//    [self.mapView setRegion:region animated:YES];
//    self.mapView.userLocation.title = @"I'm Here";
//    self.mapView.userLocation.subtitle = @"Come and Find Me";
//
//
//    NSLog(@"Latitude is: %@", [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.latitude] );
//    NSLog(@"Longitude is: %@", [NSString stringWithFormat:@"%f",self.locationManager.location.coordinate.longitude] );
//    NSLog(@"-----------------");
//    NSLog(@"map Latitude is: %@", [NSString stringWithFormat:@"%f",self.mapView.userLocation.coordinate.latitude] );
//    NSLog(@"map Longitude is: %@", [NSString stringWithFormat:@"%f",self.mapView.userLocation.coordinate.longitude] );
//}

@end

