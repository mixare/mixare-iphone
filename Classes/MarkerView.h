//
//  MarkerView.h
//  Mixare
//
//  Created by Obkircher Jakob on 19.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MarkerView : UIView <UIWebViewDelegate>{
    UIView * viewTouched;
    NSString * _url;
    UIView* loadView;
}
@property (nonatomic, retain) UIView * viewTouched;
@property (nonatomic, retain) NSString * url;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
