# XMFlowLayout
UICollection的自定义布局

看了一下网上有关UICollectionViewLayout的文章，大部分都是对于一些方法的解释，或者是瀑布流等等一些自定义效果，效果非常好。对于多个分组呢？有headerView和footerView呢？很难找到相关文章，所以就想分享一下如何去处理多个分组且有headerView和footerView的自定义布局。
首先来看一下系统的UICollectionViewFlowLayout，代码如下
```
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
```
效果如下

![image](http://upload-images.jianshu.io/upload_images/8553605-966fb58ae18cead1.gif?imageMogr2/auto-orient/strip)

可以看到这样的效果是不满足需求的，那我们就开始去自定义它，创建一个layout继承自UICollectionViewFlowLayout，核心代码如下
```
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
```
```
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
        NSInteger col = (self.collectionView.frame.size.width - (left + right)) / (cellW + self.cellSpace);
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
```
这样去掉用
```
        XMFlowLayout *layout = [[XMFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.cellInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.cellSpace = 10;
```
效果如下

![image](http://upload-images.jianshu.io/upload_images/8553605-a5c358edbb77e31c.gif?imageMogr2/auto-orient/strip)

看起来任然不够理想稍微调整一下调用方式
```
        XMFlowLayout *layout = [[XMFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.footerReferenceSize = CGSizeMake(self.view.frame.size.width, 50);
        layout.cellInset = UIEdgeInsetsMake(10, (self.view.frame.size.width - 320) / 2, 10, (self.view.frame.size.width - 320) / 2);
        layout.cellSpace = 10;
```
![image](http://upload-images.jianshu.io/upload_images/8553605-db15b10d02062708.gif?imageMogr2/auto-orient/strip)

你可以通过itemsize和cellInset和cellSpace精准的控制你想要的效果，这里只是处理了垂直方向的定制，水平方向的也是一样的道理
