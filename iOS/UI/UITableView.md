# LearniOS

## UI

### UITableView 
* sectionIndexBackgroundColor

### 隐藏空白行
http://blog.csdn.net/yangbingbinga/article/details/43114813

```
self.tableView.tableFooterView=[[UIView alloc]init];
```


### 创建有间隔的cell
http://www.jianshu.com/p/01f61359b30d

```
- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10;
//    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 2 * frame.origin.x;
    [super setFrame:frame];
}
```
