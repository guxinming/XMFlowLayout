//
//  XMFlowLayout.m
//  XMFlowLayout
//
//  Created by EDZ on 2018/8/27.
//  Copyright © 2018年 EDZ. All rights reserved.
//

#import "XMFlowLayout.h"

@interface XMFlowLayout ()
@property (nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSMutableArray *headerAttributesArray;
@property (strong, nonatomic) NSMutableArray *attributesArray;
@property (strong, nonatomic) NSMutableArray *itemAttributesArray;
@property (strong, nonatomic) NSMutableArray *footerAttributesArray;

@end

@implementation XMFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    if (CGSizeEqualToSize(self.itemSize, CGSizeZero)) {
        return;
    }
    
    if (!self.attributesArray) {
        self.attributesArray = [[NSMutableArray alloc] init];
    } else {
        [self.attributesArray removeAllObjects];
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        [self calculationVerticalInfo];
    } else {
        [self calculationHorizontalInfo];
    }
}

//计算垂直方向布局
- (void)calculationVerticalInfo {
    CGFloat contentH = 0;
    
    CGFloat left = self.sectionInset.left;
    CGFloat right = self.sectionInset.right;
    CGFloat top = self.sectionInset.top;
    CGFloat bottom = self.sectionInset.bottom;
    CGFloat cellW = self.itemSize.width;
    CGFloat cellH = self.itemSize.height;
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        //计算header的frame
        UICollectionViewLayoutAttributes *headerAttribute = [[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathWithIndex:i]] copy];
        if (headerAttribute) {
            CGRect headerRect = CGRectMake(0, contentH, headerAttribute.frame.size.width, headerAttribute.frame.size.height);
            headerAttribute.frame = headerRect;
            [self.attributesArray addObject:headerAttribute];
            contentH += headerAttribute.frame.size.height;
        }
        
        NSInteger item = [self.collectionView numberOfItemsInSection:i];
        //每一行有几个item
        NSInteger col = 0;
        float fCol = (self.collectionView.frame.size.width - (left + right) + self.cellSpace) / (cellW + self.cellSpace);
        if (fabs(ceil(fCol) - fCol) < 0.0001) {
            col = ceil(fCol);
        } else if (fabs(floor(fCol) - fCol) < 0.0001) {
            col = floor(fCol);
        } else {
            col = (NSInteger)fCol;
        }
        NSInteger row = item % col == 0 ? item / col : item / col + 1;
        for (int j = 0; j < item; j++) {
            
            UICollectionViewLayoutAttributes *itemAttribute = [[super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]] copy];
            if (itemAttribute) {
                CGRect itemRect = CGRectMake(left + j % col * (cellW + self.cellSpace), contentH + top + j / col * (self.itemSize.height + self.cellSpace), cellW, cellH);
                itemAttribute.frame = itemRect;
                [self.attributesArray addObject:itemAttribute];
            }
        }
        contentH += (top + row * cellH + (row - 1) * self.cellSpace + bottom);
        
        //计算footerFrame
        
        UICollectionViewLayoutAttributes *footerAttribute = [[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathWithIndex:i]] copy];
        if (footerAttribute) {
            CGRect footerRect = CGRectMake(0, contentH, footerAttribute.frame.size.width, footerAttribute.frame.size.height);
            footerAttribute.frame = footerRect;
            [self.attributesArray addObject:footerAttribute];
            contentH += footerAttribute.frame.size.height;
        }
    }
    self.contentSize = CGSizeMake(self.collectionView.frame.size.width, contentH);
}

- (void)calculationHorizontalInfo {
    CGFloat contentW = 0;

    CGFloat left = self.sectionInset.left;
    CGFloat right = self.sectionInset.right;
    CGFloat top = self.sectionInset.top;
    CGFloat bottom = self.sectionInset.bottom;
    CGFloat cellW = self.itemSize.width;
    CGFloat cellH = self.itemSize.height;
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        //计算header的frame
        UICollectionViewLayoutAttributes *headerAttribute = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathWithIndex:i]];
        if (headerAttribute) {
            CGRect headerRect = CGRectMake(contentW, 0, headerAttribute.size.width, headerAttribute.size.height);
            headerAttribute.frame = headerRect;
            [self.attributesArray addObject:headerAttribute];
            contentW += headerAttribute.size.width;
        }

        NSInteger item = [self.collectionView numberOfItemsInSection:i];
        //每一行有几个item
        NSInteger row = 0;
        float fRow = (self.collectionView.frame.size.height - (top + bottom) + self.cellSpace) / (cellH + self.cellSpace);
        if (fabs(ceil(fRow) - fRow) < 0.0001) {
            row = ceil(fRow);
        } else if (fabs(floor(fRow) - fRow) < 0.0001) {
            row = floor(fRow);
        } else {
            row = (NSInteger)fRow;
        }
        NSInteger col = item % row == 0 ? item / row : item / row + 1;
        for (int j = 0; j < item; j++) {
            UICollectionViewLayoutAttributes *itemAttribute = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]];
            if (itemAttribute) {
                CGRect itemRect = CGRectMake(contentW + left + j % col * (cellW + self.cellSpace), top + j / col * (self.itemSize.height + self.cellSpace), cellW, cellH);
                itemAttribute.frame = itemRect;
                [self.attributesArray addObject:itemAttribute];
            }
        }
        contentW += (left + col * cellW + (col - 1) * self.cellSpace + right);

        //计算footerFrame
        UICollectionViewLayoutAttributes *footerAttribute = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathWithIndex:i]];
        if (footerAttribute) {
            CGRect footerRect = CGRectMake(contentW, 0, footerAttribute.size.width, footerAttribute.size.height);
            footerAttribute.frame = footerRect;
            [self.attributesArray addObject:footerAttribute];
            contentW += footerAttribute.size.width;
        }
    }
    self.contentSize = CGSizeMake(contentW, self.collectionView.frame.size.height);
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

@end
