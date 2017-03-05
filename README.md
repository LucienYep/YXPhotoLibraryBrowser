# YXPhotoLibraryBrowser
使用方法:
```
extern NSString * sendSelectImageNotification;
//监听此通知可获取选中的图片数组
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getImages:) name:sendSelectImageNotification object:nil];
```
```
//进入多选界面
PhotoPickerGroupViewController *groupVC = [[PhotoPickerGroupViewController alloc] init];
//设置最大多选数量
groupVC.maxSelectedCount = 5;
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:groupVC];
[self presentViewController:nav animated:true completion:nil];
```
更详尽的介绍请移步[使用介绍](http://www.jianshu.com/p/9c2da8853435),谢谢!
