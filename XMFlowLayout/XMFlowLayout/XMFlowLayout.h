//
//  XMFlowLayout.h
//  XMFlowLayout
//
//  Created by EDZ on 2018/8/27.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMFlowLayout : UICollectionViewFlowLayout

/**
 cell与Collection的上下左右的边距
 */
@property (nonatomic) UIEdgeInsets cellInset;
/**
 cell之间的距离
 */
@property (nonatomic) CGFloat      cellSpace;

@end
