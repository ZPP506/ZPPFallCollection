## ios 铺满轨道弹幕效果实现 
为避免重复造轮子，网上查找了两个弹幕效果
1：[OCBarrage](https://github.com/ZPP506/OCBarrage) 标题很唬人 接入后各种问题 有需要的可以自行查看
2：[BarrageRenderer](https://github.com/unash/BarrageRenderer) 这个库还是值得推荐的写的很不错，一般弹幕需求基本都满足，但是弹幕轨道搜寻算法不太满足有点不太满足需求，并不能做到本例中的演示效果，偶尔还会出现弹幕重叠（也可能是我的使用方式不对）


3：本例写的比较糙， 性能是短板，有改进方案的老铁记得issues
实现思路：使用collectionView 自定义瀑布流， 然后使用定时器滚动collection的偏移量
![normal video (4).gif](https://upload-images.jianshu.io/upload_images/11285123-bba3f7ff91d34d65.gif?imageMogr2/auto-orient/strip)



### 链接地址
https://github.com/ZPP506/ZPPFallCollection.git
