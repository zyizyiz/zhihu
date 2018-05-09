# zhihu 学习知乎日报开发
工程结合了知乎日报的API，使用了mvc设计模式，并使用懒加载视图控件。自定义了轮播图控件，轮播图随着tableview的下拉而拉伸。使用webview，并且加载了css样式。并在每块代码添加的详细的注释。

![image-20180509092315140](/var/folders/_n/9k_vxf4s56qgq1c5mvfxdk3w0000gn/T/abnerworks.Typora/image-20180509092315140.png)



![image-20180509092413887](/var/folders/_n/9k_vxf4s56qgq1c5mvfxdk3w0000gn/T/abnerworks.Typora/image-20180509092413887.png)

#### 代码注释：

![image-20180509094314438](/var/folders/_n/9k_vxf4s56qgq1c5mvfxdk3w0000gn/T/abnerworks.Typora/image-20180509094314438.png)

![image-20180509094442486](/var/folders/_n/9k_vxf4s56qgq1c5mvfxdk3w0000gn/T/abnerworks.Typora/image-20180509094442486.png)

### 注意：

**new 和 alloc 区别：**

两种方式创建对象现在基本上一样，区别就是使用new只能默认init进行初始化，alloc方式可以使用其它的init开头的方法进行初始化。**建议使用alloc进行初始化。**

**contentSize、contentInset、contentOffset 属性：**

- **contentSize:即内容,就是scrollview可以滚动的区域**,比如frame = (0 ,0 ,100 ,200)    contentSize = (100 ,400)，代表你的scrollview可以上下滚动，滚动区域为frame大小的两倍。其中常用的是contentSize.height = 内容的高度。
- **contentInset:即内边距**,contentInset = 在内容周围增加的间距(粘着内容),contentInset的单位是UIEdgeInsets,默认值为UIEdgeInsetsZero。
- **contentOffset:即偏移量,其中分为contentOffset.y=内容的顶部和frame顶部的差值**,contentOffset.x=内容的左边和frame左边的差值,下面重点阐述contentOffset.y,因为contentOffset.y最为常用。

