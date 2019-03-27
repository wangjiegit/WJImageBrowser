//
//  WJImageBrowserView.h
//  WJImageBrowser
//
//  Created by 王杰 on 2018/10/23.
//  Copyright © 2018年 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WJSectorProgressView;

typedef NS_ENUM(NSInteger, WJImageBrowserViewType) {
    WJImageBrowserViewTypeDefault = 0,
    WJImageBrowserViewTypeBanner = 1,
};

@interface WJImageBrowserView : UIView<UIScrollViewDelegate>

@property (nonatomic, copy) NSArray<UIImageView *> *originalViews;//原图片视图集合 如果是banner的话 穿当前imageview一个就行

@property (nonatomic) WJImageBrowserViewType browserViewType;//默认普通的 如果是banner的话 需要设置

@property (nonatomic, copy) NSArray<NSString *> *urls;//高清图片

@property (nonatomic) NSUInteger currentIndex;//当前选中的index

@property (nonatomic, copy) void(^closeBlock)(NSInteger index);//即将关闭时回调

- (void)show;//展示图片浏览器

@end

////////////////////////////////////////////////////////////////////////////////////////////
@interface WJImageBrowserItem : UIView<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;//用来放大缩小

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) WJSectorProgressView *progressView;//下载进度条

@property (nonatomic) BOOL isloading;//是否在加载中

@property (nonatomic, copy) void(^gestureBeganBlock)(void);//手势开始

@property (nonatomic, copy) void(^gestureCancelBlock)(void);//手势取消

@property (nonatomic, copy) void(^closeBlcok)(void);//关闭图片浏览器回调

- (void)loadImgUrl:(NSString *)urlString;//加载url图片

- (void)configContentSize;//配置内容大小

@end

////////////////////////////////////////////////////////////////

@interface WJSectorProgressView : UIView

@property (nonatomic) CGFloat radius;//外圆半径 默认20

@property (nonatomic) CGFloat progress;//进度

@end
