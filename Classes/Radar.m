//
//  Radar.m
//  Mixare
//
//  Created by Obkircher Jakob on 22.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Radar.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation Radar
@synthesize pois = _pois, range= _range, radius= _radius;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 115, 0.3);
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 125, 0.1);
    
    // Draw a radar and the view port 
    CGContextFillEllipseInRect(contextRef, CGRectMake(0.5, 0.5, RADIUS*2, RADIUS*2)); 
    CGContextSetRGBStrokeColor(contextRef, 0, 255, 0, 0.5);
    
    _range = _radius *1000;
    float scale = _range / RADIUS;
    if(_pois != nil){
        for(ARGeoCoordinate * poi in _pois){
            float x,y;
            //case1: azimiut is in the 1 quadrant of the radar
            if(poi.azimuth >=0 && poi.azimuth< M_PI/2){
                
                x = RADIUS + cosf((M_PI/2)-poi.azimuth)*(poi.radialDistance/scale);
                y = RADIUS - sinf((M_PI/2)-poi.azimuth)*(poi.radialDistance/scale); 
                
            }else if(poi.azimuth >M_PI/2 && poi.azimuth<M_PI){
                //case2: azimiut is in the 2 quadrant of the radar
                
                x = RADIUS + cosf(poi.azimuth- (M_PI/2))*(poi.radialDistance/scale);
                y = RADIUS + sinf(poi.azimuth- (M_PI/2))*(poi.radialDistance/scale); 
                
            }else if(poi.azimuth >M_PI && poi.azimuth<(3*M_PI/2)){
                //case3: azimiut is in the 3 quadrant of the radar
                
                x = RADIUS - cosf((3*M_PI/2)-poi.azimuth)*(poi.radialDistance/scale);
                y = RADIUS + sinf((3*M_PI/2)-poi.azimuth)*(poi.radialDistance/scale); 
                
            }else if(poi.azimuth >(3*M_PI/2) && poi.azimuth<(2*M_PI)){
                //case4: azimiut is in the 4 quadrant of the radar
                
                x = RADIUS - cosf(poi.azimuth - (3*M_PI/2))*(poi.radialDistance/scale);
                y = RADIUS - sinf(poi.azimuth - (3*M_PI/2))*(poi.radialDistance/scale);
                
            }else if(poi.azimuth ==0){
                x = RADIUS;
                y = RADIUS - poi.radialDistance/scale;
            }else if(poi.azimuth == M_PI/2){
                x = RADIUS + poi.radialDistance/scale;
                y = RADIUS;
            }else if(poi.azimuth == (3*M_PI/2)){
                x = RADIUS;
                y = RADIUS+ poi.radialDistance/scale;
            }else if(poi.azimuth == (3*M_PI/2)){
                x = RADIUS -poi.radialDistance/scale;
                y = RADIUS;
            }
            //drawing the radar point
            if([poi.source isEqualToString:@"WIKIPEDIA"]){
                CGContextSetRGBFillColor(contextRef, 255, 0, 0, 1);
            }else if([poi.source isEqualToString:@"BUZZ"]){
                CGContextSetRGBFillColor(contextRef, 0, 255, 0, 1);
            }
            if(x <= RADIUS*2 && x>=0 && y>=0 && y <= RADIUS*2){
                CGContextFillEllipseInRect(contextRef, CGRectMake(x,y, 2, 2)); 
            }
        }
    }
	
}


- (void)dealloc {
    [super dealloc];
}


@end
