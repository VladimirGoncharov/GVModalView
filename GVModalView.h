//
//  GVModalView.h
//  GuessApp
//
//  Created by Владимир on 31.03.14.
//  Copyright (c) 2014 Goncharov Vladimir. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GVModalViewShowType)
{
    GVModalViewShowTypeDefault
};

typedef NS_ENUM(NSUInteger, GVModalViewDismissType)
{
    GVModalViewDismissTypeDefault
};

@interface GVModalView : UIView

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign, readonly) BOOL isShow;

- (void)showWithType:(GVModalViewShowType)type
          completion:(void(^)(BOOL finished))completion;
- (void)dismissWithType:(GVModalViewDismissType)type
             completion:(void(^)(BOOL finished))completion;

@end
