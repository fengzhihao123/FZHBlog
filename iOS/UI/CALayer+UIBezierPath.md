## 绘制中部镂空view

```
- (void)createMiddleClearView1 {
    UIView *fatherView = [[UIView alloc]initWithFrame:self.view.bounds];
    fatherView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fatherView];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithRect:fatherView.bounds];
    UIBezierPath *sPath = [UIBezierPath bezierPathWithRect:CGRectMake(100, 200, 100, 100)];
    [bgPath appendPath:sPath];
    
    CAShapeLayer *bgShapeLayer = [CAShapeLayer layer];
    bgShapeLayer.fillColor = [UIColor redColor].CGColor;
    bgShapeLayer.path = bgPath.CGPath;
    // 重要
    bgShapeLayer.fillRule = kCAFillRuleEvenOdd;
    
    [fatherView.layer addSublayer:bgShapeLayer];
}

- (void)createMiddleClearView2 {
    UIView *fatherView = [[UIView alloc]initWithFrame:self.view.bounds];
    fatherView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:fatherView];
    
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithRect:fatherView.bounds];
    // 重要
    UIBezierPath *sPath = [[UIBezierPath bezierPathWithRect:CGRectMake(100, 200, 100, 100)] bezierPathByReversingPath];
    [bgPath appendPath:sPath];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor redColor].CGColor;
    maskLayer.path = bgPath.CGPath;
    fatherView.layer.mask = maskLayer;
}

```
