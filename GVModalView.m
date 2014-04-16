//
//  GVModalView.m
//  GuessApp
//
//  Created by Владимир on 31.03.14.
//  Copyright (c) 2014 Goncharov Vladimir. All rights reserved.
//

#import "GVModalView.h"

@interface GVModalView()

@property (nonatomic, assign) BOOL isShow;

@end

@implementation GVModalView

@synthesize backgroundView = _backgroundView;

- (id)initWithFrame:(CGRect)frame
{
    self        = [super initWithFrame:frame];
    if (self)
    {
        [self __initialize];
    }
    return self;
}

- (void)__initialize
{
    UIViewController *rootViewController    = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    self.frame                              = rootViewController.view.bounds;
    self.backgroundColor                    = [UIColor clearColor];
    self.autoresizingMask                   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - accessory

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView)
    {
        [_backgroundView removeFromSuperview];
        _backgroundView         = nil;
    }
    
    backgroundView.frame        = self.bounds;
    [self insertSubview:backgroundView
                atIndex:0];
    _backgroundView             = backgroundView;
}

- (void)setContentView:(UIView *)contentView
{
    if (_contentView)
    {
        [_contentView removeFromSuperview];
        _contentView         = nil;
    }
    
    contentView.frame        = self.bounds;
    [self insertSubview:contentView
                atIndex:1];
    _contentView             = contentView;
}

#pragma mark - present and dissmis

- (void)showWithType:(GVModalViewShowType)type
          completion:(void (^)(BOOL))completion
{
    if (self.isShow)
    {
        return;
    }
    
    self.isShow                             = YES;
    __weak typeof(self) wself               = self;
    
    UIViewController *rootViewController    = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    
    switch (type)
    {
        default:
        {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            CGFloat duration                        = 1.0f;
            self.backgroundView.alpha               = 0.0f;
            
            [[rootViewController view] addSubview:self];
            
            NSArray *values                         = @[@0.0, @1.05, @0.8, @1.02, @1.0];
            CAKeyframeAnimation *bounceAnimation    = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
            bounceAnimation.values = values;
            [bounceAnimation setTimingFunctions:@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]]];
            bounceAnimation.duration                = duration;
            [bounceAnimation setCompletion:^(BOOL finished) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                BLOCK_SAFE_RUN(completion, finished);
            }];
            [self.contentView.layer addAnimation:bounceAnimation
                                          forKey:nil];
            
            [UIView animateWithDuration:duration
                             animations:^{
                                 wself.backgroundView.alpha             = 0.25f;
                             }];
        }; break;
    }
}

- (void)dismissWithType:(GVModalViewDismissType)type
             completion:(void (^)(BOOL))completion
{
    if (!self.isShow)
    {
        return;
    }
    
    self.isShow                             = NO;
    __weak typeof(self) wself               = self;
    
    switch (type)
    {
        default:
        {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            
            CGFloat duration                        = 1.0f;

            
            [UIView animateWithDuration:duration
                             animations:^{
                                 wself.backgroundView.alpha             = 0.0f;
                             }];
            
            [UIView animateWithDuration:duration
                             animations:^{
                                 wself.contentView.alpha                = 0.0f;
                             }];
            
            NSArray *values                             = @[@1.0, @1.05, @0.0];
            CAKeyframeAnimation *bounceAnimation        = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
            bounceAnimation.values                      = values;
            [bounceAnimation setTimingFunctions:@[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]]];
            bounceAnimation.duration                    = duration;
            [bounceAnimation setCompletion:^(BOOL finished)
             {
                 [wself removeFromSuperview];
                 [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                 
                 BLOCK_SAFE_RUN(completion, finished);
             }];
            
            [self.contentView.layer addAnimation:bounceAnimation
                                          forKey:nil];
        }; break;
    }
}

@end
