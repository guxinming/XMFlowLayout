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
@property (strong, nonatomic) NSMutableArray *headerRectArray;
@property (strong, nonatomic) NSMutableArray *attributesArray;
@property (strong, nonatomic) NSMutableArray *itemRectArray;
@property (strong, nonatomic) NSMutableArray *footerRectArray;

@end

@implementation XMFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    if (!self.attributesArray) {
        self.attributesArray = [[NSMutableArray alloc] init];
        self.headerRectArray = [[NSMutableArray alloc] init];
        self.itemRectArray = [[NSMutableArray alloc] init];
        self.footerRectArray = [[NSMutableArray alloc] init];
    } else {
        [self.attributesArray removeAllObjects];
        [self.headerRectArray removeAllObjects];
        [self.itemRectArray removeAllObjects];
        [self.footerRectArray removeAllObjects];
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
    
    CGFloat left = self.cellInset.left;
    CGFloat right = self.cellInset.right;
    CGFloat top = self.cellInset.top;
    CGFloat bottom = self.cellInset.bottom;
    CGFloat cellW = self.itemSize.width;
    CGFloat cellH = self.itemSize.height;
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        //计算header的frame
        CGRect headerRect = CGRectMake(0, contentH, self.headerReferenceSize.width, self.headerReferenceSize.height);
        [self.headerRectArray addObject:[NSValue valueWithCGRect:headerRect]];
        contentH += self.headerReferenceSize.height;
        [self.attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathWithIndex:i]]];
        
        NSInteger item = [self.collectionView numberOfItemsInSection:i];
        //每一行有几个item
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        [self.itemRectArray addObject:itemArray];
        NSInteger col = (self.collectionView.frame.size.width - (left + right) + self.cellSpace) / (cellW + self.cellSpace);
        NSInteger row = item % col == 0 ? item / col : item / col + 1;
        for (int j = 0; j < item; j++) {
            CGRect itemRect = CGRectMake(left + j % col * (cellW + self.cellSpace), contentH + top + j / col * (self.itemSize.height + self.cellSpace), cellW, cellH);
            [itemArray addObject:[NSValue valueWithCGRect:itemRect]];
            
            [self.attributesArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
        }
        contentH += (top + row * cellH + (row - 1) * self.cellSpace + bottom);
        
        //计算footerFrame
        CGRect footerRect = CGRectMake(0, contentH, self.headerReferenceSize.width, self.headerReferenceSize.height);
        [self.footerRectArray addObject:[NSValue valueWithCGRect:footerRect]];
        contentH += self.footerReferenceSize.height;
        [self.attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathWithIndex:i]]];
    }
    self.contentSize = CGSizeMake(self.collectionView.frame.size.width, contentH);
}

- (void)calculationHorizontalInfo {
    CGFloat contentW = 0;
    
    CGFloat left = self.cellInset.left;
    CGFloat right = self.cellInset.right;
    CGFloat top = self.cellInset.top;
    CGFloat bottom = self.cellInset.bottom;
    CGFloat cellW = self.itemSize.width;
    CGFloat cellH = self.itemSize.height;
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        //计算header的frame
        CGRect headerRect = CGRectMake(contentW, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
        [self.headerRectArray addObject:[NSValue valueWithCGRect:headerRect]];
        contentW += self.headerReferenceSize.width;
        [self.attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathWithIndex:i]]];
        
        NSInteger item = [self.collectionView numberOfItemsInSection:i];
        //每一行有几个item
        NSMutableArray *itemArray = [[NSMutableArray alloc] init];
        [self.itemRectArray addObject:itemArray];
        NSInteger row = (self.collectionView.frame.size.height - (top + bottom) + self.cellSpace) / (cellH + self.cellSpace);
        NSInteger col = item % row == 0 ? item / row : item / row + 1;
        for (int j = 0; j < item; j++) {
            CGRect itemRect = CGRectMake(contentW + left + j % col * (cellW + self.cellSpace), top + j / col * (self.itemSize.height + self.cellSpace), cellW, cellH);
            [itemArray addObject:[NSValue valueWithCGRect:itemRect]];
            
            [self.attributesArray addObject:[self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:j inSection:i]]];
        }
        contentW += (left + col * cellW + (col - 1) * self.cellSpace + right);
        
        //计算footerFrame
        CGRect footerRect = CGRectMake(contentW, 0, self.headerReferenceSize.width, self.headerReferenceSize.height);
        [self.footerRectArray addObject:[NSValue valueWithCGRect:footerRect]];
        contentW += self.footerReferenceSize.width;
        [self.attributesArray addObject:[self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathWithIndex:i]]];
    }
    self.contentSize = CGSizeMake(contentW, self.collectionView.frame.size.height);
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attrs = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    attrs.frame = [self.itemRectArray[indexPath.section][indexPath.row] CGRectValue];
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [[super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath] copy];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attrs.frame = [self.headerRectArray[indexPath.section] CGRectValue];
    } else {
        attrs.frame = [self.footerRectArray[indexPath.section] CGRectValue];
    }
    return attrs;
}


@end
