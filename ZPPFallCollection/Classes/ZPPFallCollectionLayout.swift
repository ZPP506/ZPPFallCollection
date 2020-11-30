//
//  ZPPFallCollectionLayout.swift
//  ZPPProduct
//
//  Created by admin on 2020/11/26.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
public protocol ZPPFallCollectionLayoutDelegate: NSObjectProtocol {
    /// 计算item宽度的代理方法，将item的宽度与indexPath传递给外界
    func waterfallLayout(_ waterfallLayout: ZPPFallCollectionLayout?, itemHeightForWidth itemWidth: CGFloat, at indexPath: IndexPath?) -> CGFloat
}

public class ZPPFallCollectionLayout: UICollectionViewLayout {
    //总共多少行，默认是2
    var columnCount = 0
    //行间距，默认是0
    var columnSpacing = 0
    //列间距，默认是0
    var rowSpacing = 0
    //section与collectionView的间距，默认是（0，0，0，0）
    var sectionInset: UIEdgeInsets = .zero
    //用来记录每一行的最大y值
    private var maxYDic: [String : CGFloat] = [String : CGFloat]()
    //保存每一个item的attributes
    private var attributesArray: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    // 设置代理
    public weak var delegate: ZPPFallCollectionLayoutDelegate?
    
    
    // MARK:- 构造方法
    override init() {
        super.init()
        columnCount = 2
    }
    
    public init(columnCount: Int) {
        super.init()
        self.columnCount = columnCount
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func setColumnSpacing(_ columnSpacing: Int, rowSpacing rowSepacing: Int, sectionInset: UIEdgeInsets) {
        self.columnSpacing = columnSpacing
        rowSpacing = rowSepacing
        self.sectionInset = sectionInset
    }
    
    public override func prepare() {
        super.prepare()
        //初始化字典，有几行就有几个键值对
        for i in 0..<columnCount {
            let magin = sectionInset.left
            maxYDic[String(i)] = magin
        }
        let itemCount = collectionView?.numberOfItems(inSection: 0)  ?? 0
        attributesArray.removeAll()
        for i in 0..<itemCount{
            let attributes = layoutAttributesForItem(at: IndexPath(item: i, section: 0))
            if let attributes = attributes {
                attributesArray.append(attributes)
            }
        }
    }
    public override var collectionViewContentSize: CGSize {
        //遍历字典，找出最长的那一行
        let max = CGFloat(maxYDic.values.max() ?? 0)
        return CGSize(width: CGFloat(max + sectionInset.bottom), height: 0)
    }
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //根据indexPath获取item的attributes
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        //获取collectionView的宽度
        let collectionViewZheight = collectionView?.frame.size.height ?? 0
        
        //item的宽度 = (collectionView的宽度 - 内边距与列间距) / 行数
        let itemAllHeight = collectionViewZheight - sectionInset.top - sectionInset.bottom - CGFloat((columnCount - 1)) * CGFloat(columnSpacing)
        let itemHeight =  itemAllHeight / CGFloat(columnCount)
        
        //获取item的宽度，由外界计算得到
        let itemWidth = delegate?.waterfallLayout(self, itemHeightForWidth: itemHeight, at: indexPath) ?? .zero
        
        //找出最短的那一行
        let min = CGFloat(maxYDic.values.min() ?? 0)
       
       let index = maxYDic.firstIndex(where: {
            $0.value == min
       })
        var minIndex = "0"
        if let indexSafe = index {
            let dic = maxYDic[indexSafe]
            minIndex = dic.key
        }
        //根据最短行的计算item的Y值
        let itemY = sectionInset.left + (CGFloat(columnSpacing) + itemHeight) * (CGFloat(Double(minIndex) ?? 0) )
        
        //item的y值 = 最短行的最大y值 + 行间距
        let itemXZ = min + CGFloat(rowSpacing)
        
        //设置attributes的frame
        attributes.frame = CGRect(x: itemXZ, y: itemY, width: itemWidth, height: itemHeight)
        
        //更新字典中的最大y值
        maxYDic[minIndex] = CGFloat(attributes.frame.maxX)
        
        return attributes
    }
    
    //返回rect范围内item的attributes
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }
}
