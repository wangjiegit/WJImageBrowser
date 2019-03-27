//
//  WJBannerView.h
//  WJBannerView
//
//  Created by 王杰 on 2018/10/25.
//  Copyright © 2018年 wangjie. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WJBannerViewDataSource, WJBannerViewDelegate;

@interface WJBannerView : UIView

@property (nonatomic, strong, readonly) UIImageView *currImageView;//当前的

@property (nonatomic, strong) UIImage *placeholderImage;//默认图片

@property (nonatomic, copy) NSString *pageImage;//翻页小点图片

@property (nonatomic, copy) NSString *currentPageImage;

@property (nonatomic, weak) id<WJBannerViewDataSource> dataSource;

@property (nonatomic, weak) id<WJBannerViewDelegate> delegate;

@property (nonatomic) NSUInteger timeInterval;//自动滚动时间间隔 默认3秒

//设置这个值的话 banner的宽不是屏幕的整个宽度 会显示上一张图片和下一张图片的一部分
@property (nonatomic) CGFloat middleImageViewEdgeLeft;//中间的view距离左边屏幕的距离 默认0

@property (nonatomic) CGFloat zoomScale;//缩小左右两边的imageView 默认0.92

- (void)reloadData;

- (void)scrollToIndex:(NSInteger)index;

@end

@protocol WJBannerViewDataSource <NSObject>

@required
//图片总个数
- (NSInteger)wj_numberOfRowInWJBannerView:(WJBannerView *)bannerView;

//获取当前图片urlString
- (NSURL *)wj_bannerView:(WJBannerView *)bannerView imageNameForIndex:(NSInteger)index;

@end;

@protocol WJBannerViewDelegate <NSObject>

@optional
//点击事件
- (void)wj_bannerView:(WJBannerView *)bannerView didSelectedRowAtIndex:(NSInteger)index;

@end
