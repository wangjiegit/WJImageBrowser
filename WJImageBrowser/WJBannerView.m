//
//  WJBannerView.m
//  WJBannerView
//
//  Created by 王杰 on 2018/10/25.
//  Copyright © 2018年 wangjie. All rights reserved.
//

#import "WJBannerView.h"
#import <UIImageView+WebCache.h>

@interface WJBannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *currImageView;//当前的

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIImageView *otherImageView;

@property (nonatomic) NSInteger currIndex;//当前index

@property (nonatomic) NSInteger nextIndex;//下一个（前一个或者后一个）

@end

@implementation WJBannerView {
    NSTimer *timer;//定时器
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.zoomScale = 0.95;
        self.timeInterval = 3;
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) [self stopTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(self.middleImageViewEdgeLeft, 0, CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2, self.frame.size.height);
    NSInteger num = [self.dataSource wj_numberOfRowInWJBannerView:self];
    CGSize size = [self.pageControl sizeForNumberOfPages:num];
    self.pageControl.frame = CGRectMake((self.frame.size.width - size.width) / 2, self.frame.size.height - 20, size.width, 20);
}

- (void)setupUI {
    [self addSubview:self.contentView];
    [self addSubview:self.pageControl];
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedItem)];
    [self addGestureRecognizer:tgr];
}

#pragma mark Funcion

- (void)reloadData {
    assert(self.dataSource);
    [self stopTimer];
    NSInteger num = [self.dataSource wj_numberOfRowInWJBannerView:self];
    if (num == 0) return;
    if (num > 1) [self startTimer];
    self.currIndex = 0;
    self.pageControl.numberOfPages = num;

    CGFloat width = CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2;
    
    //设置scrollView可滚动的范围
    self.contentView.contentSize = num > 1 ? CGSizeMake(3 * width, 0) : CGSizeZero;
    //设置scrollView的偏移量
    self.contentView.contentOffset = num > 1 ? CGPointMake(width, 0) : CGPointZero;
    //设置当前图片位置
    self.currImageView.frame = CGRectMake((num > 1 ? width : 0), 0, width, CGRectGetHeight(self.bounds));
    //获取第一张图片
    NSURL *imgName = [self.dataSource wj_bannerView:self imageNameForIndex:0];
    [self.currImageView sd_setImageWithURL:imgName placeholderImage:self.placeholderImage];
    
    if (self.middleImageViewEdgeLeft > 0 && num > 1) {
        NSURL *leftImgName = [self.dataSource wj_bannerView:self imageNameForIndex:(num - 1)];
        [self.leftImageView sd_setImageWithURL:leftImgName placeholderImage:self.placeholderImage];
        NSURL *rightImgName = [self.dataSource wj_bannerView:self imageNameForIndex:1];
        [self.rightImageView sd_setImageWithURL:rightImgName placeholderImage:self.placeholderImage];
        [self resetFrame];
    }
}

- (void)scrollToIndex:(NSInteger)index {
    if (index == self.currIndex) return;
    NSInteger num = [self.dataSource wj_numberOfRowInWJBannerView:self];
    if (index < num) {
        self.nextIndex = index;
        [self changeShowView];
    }
}

//缩放成原来的默认大小
- (void)resetFrame {
    NSInteger num = [self.dataSource wj_numberOfRowInWJBannerView:self];
    CGFloat width = CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2;
    self.currImageView.frame = CGRectMake((num > 1 ? width : 0), 0, width, CGRectGetHeight(self.bounds));

    CGFloat zoomX =  width * (1 - self.zoomScale) / 2.0;//缩放过的坐标
    CGFloat zoomY = CGRectGetHeight(self.bounds) * (2 - 2 * self.zoomScale) / 2.0;
    CGRect rect = CGRectMake(zoomX, zoomY, width * self.zoomScale, CGRectGetHeight(self.bounds) * (self.zoomScale * 2 - 1));
    self.leftImageView.frame = [self getChangedframeByX:0 scale:self.zoomScale];
    
    rect.origin.x = 2 * width + width * (1 - self.zoomScale) / 2.0;
    self.rightImageView.frame = [self getChangedframeByX:2 * width scale:self.zoomScale];
}

//开启定时器
- (void)startTimer {
    [self stopTimer];
    timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(intervalRoll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

//关闭定时器
- (void)stopTimer {
    [timer invalidate];
    timer = nil;
}

//定时滚动
- (void)intervalRoll {
    CGFloat width = CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2;
    [self.contentView setContentOffset:CGPointMake(2 * width, 0) animated:YES];
}

#pragma mark Touch Event
//点击当前图片
- (void)didSelectedItem {
    if ([self.delegate respondsToSelector:@selector(wj_bannerView:didSelectedRowAtIndex:)]) {
        [self.delegate wj_bannerView:self didSelectedRowAtIndex:self.currIndex];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    //未翻页的情况下 不改变当前图片
    CGFloat width = CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2;
    if (offset.x == width) return;
    
    //如果偏移量大于scrollView的width，说明向右，反正向左
    BOOL theRight = offset.x > width;
    
    NSInteger num = [self.dataSource wj_numberOfRowInWJBannerView:self];
    //(self.currIndex + 1) % image.count 获取下一个对象
    self.nextIndex = theRight ? (self.currIndex + 1) % num : self.currIndex - 1;
    if (self.nextIndex < 0) self.nextIndex = num - 1;//获取数组最后一个
    NSInteger otherIndex = self.nextIndex;
    //otherImageView的坐标和图片
    if (self.middleImageViewEdgeLeft > 0) {
        CGFloat x =  theRight ? (3 * width): (-width);
        self.otherImageView.frame = [self getChangedframeByX:x scale:self.zoomScale];
        otherIndex = theRight ? (self.nextIndex + 1) % num : self.nextIndex - 1;
        if (otherIndex < 0) otherIndex = num - 1;
        
        CGFloat scale = [self imageZoomScaleByFrame:self.leftImageView.frame];
        self.leftImageView.frame = [self getChangedframeByX:0 scale:scale];
        
        scale = [self imageZoomScaleByFrame:self.currImageView.frame];
        self.currImageView.frame = [self getChangedframeByX:width scale:scale];
        
        scale = [self imageZoomScaleByFrame:self.rightImageView.frame];
        self.rightImageView.frame = [self getChangedframeByX:2 * width scale:scale];
    } else {
        CGFloat x =  theRight ? 2 * width : 0;
        CGRect rect = CGRectMake(x, 0, width, CGRectGetHeight(self.bounds));
        self.otherImageView.frame = rect;
    }
    NSURL *imgName = [self.dataSource wj_bannerView:self imageNameForIndex:otherIndex];
    [self.otherImageView sd_setImageWithURL:imgName placeholderImage:self.placeholderImage];
}

//缩放比例
- (CGFloat)imageZoomScaleByFrame:(CGRect)frame {
    CGFloat distance = fabs(frame.origin.x - self.contentView.contentOffset.x);
    CGFloat sx = self.zoomScale + (self.contentView.frame.size.width - distance) / self.contentView.frame.size.width / 10;
    if (sx < self.zoomScale) sx = self.zoomScale;
    if (sx > 1) sx = 1;
    return sx;
}

//x:传入的视图在scrollview上的x轴坐标   scale:缩放比例
- (CGRect)getChangedframeByX:(CGFloat)x scale:(CGFloat)scale {
    CGFloat width = CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2;
    CGFloat zoomX = x + width * (1 - scale) / 2.0;//缩放后的x的坐标
    CGFloat zoomY = CGRectGetHeight(self.bounds) * (2 - 2 * scale) / 2.0;
    return CGRectMake(zoomX, zoomY, width * scale, CGRectGetHeight(self.bounds) * (scale * 2 - 1));
}

//拖动的时候关闭定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

//手指离开拖动的时候开启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
    //当 bounces = NO时 解决手指一直滑动到scrollview的范围外的bug，这个时候的没有在减速
    if (!decelerate) [self pauseRoll];
}

//一次滚动结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self pauseRoll];
}

//一次滚动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pauseRoll];
}

//检查滚动后是否要改变s展示的视图
- (void)pauseRoll {
    //未翻页的情况下 不改变当前图片
    CGFloat width = CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2;
    if (self.contentView.contentOffset.x == width) return;
    [self changeShowView];
}

//展示滚动后的图片
- (void)changeShowView {
    self.currIndex = self.nextIndex;
    NSURL *imgName = [self.dataSource wj_bannerView:self imageNameForIndex:self.currIndex];
    [self.currImageView sd_setImageWithURL:imgName placeholderImage:self.placeholderImage];
    self.pageControl.currentPage = self.currIndex;
    
    if (self.middleImageViewEdgeLeft > 0) {
        NSInteger num = [self.dataSource wj_numberOfRowInWJBannerView:self];
        NSInteger leftIndex = self.currIndex - 1;
        if (leftIndex < 0) leftIndex = num - 1;
        NSURL *leftImgName = [self.dataSource wj_bannerView:self imageNameForIndex:leftIndex];
        [self.leftImageView sd_setImageWithURL:leftImgName placeholderImage:self.placeholderImage];
        NSInteger rightIndex = (self.currIndex + 1) % num;
        NSURL *rightImgName = [self.dataSource wj_bannerView:self imageNameForIndex:rightIndex];
        [self.rightImageView sd_setImageWithURL:rightImgName placeholderImage:self.placeholderImage];
        [self resetFrame];
    }
    self.contentView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds) - self.middleImageViewEdgeLeft * 2, 0);
}


#pragma mark Setter and Getter

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.scrollsToTop = NO;
        _contentView.bounces = NO;
        _contentView.delegate = self;
        _contentView.pagingEnabled = YES;
        _contentView.clipsToBounds = NO;
    }
    return _contentView;
}

- (UIImageView *)otherImageView {
    if (!_otherImageView) {
        _otherImageView = [[UIImageView alloc] init];
        _otherImageView.contentMode = UIViewContentModeScaleAspectFill;
        _otherImageView.clipsToBounds = YES;
        _otherImageView.layer.cornerRadius = 10;
        [self.contentView addSubview:_otherImageView];
    }
    return _otherImageView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        _leftImageView.layer.cornerRadius = 10;
        [self.contentView addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)currImageView {
    if (!_currImageView) {
        _currImageView = [[UIImageView alloc] init];
        _currImageView.contentMode = UIViewContentModeScaleAspectFill;
        _currImageView.clipsToBounds = YES;
        _currImageView.layer.cornerRadius = 10;
        [self.contentView addSubview:_currImageView];
    }
    return _currImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.clipsToBounds = YES;
        _rightImageView.layer.cornerRadius = 10;
        [self.contentView addSubview:_rightImageView];
    }
    return _rightImageView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

- (void)setPageImage:(NSString *)pageImage {
    _pageImage = [pageImage copy];
    [_pageControl setValue:[UIImage imageNamed:pageImage] forKey:@"_pageImage"];
}

- (void)setCurrentPageImage:(NSString *)currentPageImage {
    _currentPageImage = [currentPageImage copy];
    [_pageControl setValue:[UIImage imageNamed:currentPageImage] forKey:@"_currentPageImage"];
}

@end
