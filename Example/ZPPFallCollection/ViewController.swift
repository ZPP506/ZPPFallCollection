//
//  ViewController.swift
//  ZPPProduct
//
//  Created by admin on 2020/7/21.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import ZPPFallCollection
class ZPPModel: NSObject {
    
    @objc var img: String = ""
    @objc var nickName: String = ""
    @objc var w: CGFloat = 0
    @objc var h: CGFloat = 0
    
    init(dic: [String:Any]) {
        super.init()
        setValuesForKeys(dic)
    }
}
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,ZPPFallCollectionLayoutDelegate, ZPPFallCollectionViewDelegate {
   
    
    lazy var models: [ZPPModel] = {
        let path = Bundle.main.path(forResource: "1.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path ?? "") as! [[String: Any]]
        var models = [ZPPModel]()
        for item in array {
            let model = ZPPModel.init(dic: item)
            models.append(model)
        }
        return models
    }()
    private lazy var collectionView: ZPPFallCollectionView = {
        let layout = ZPPFallCollectionLayout(columnCount: 3)
        layout.delegate = self
        let v = ZPPFallCollectionView(frame: .zero, collectionViewLayout: layout, delegate: self, seep: 70, startX: UIScreen.main.bounds.size.width)
        v.delegate = self
        v.dataSource = self
        v.register(UINib.init(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "\(CollectionViewCell.self)")
        v.backgroundColor = .white
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CollectionViewCell.self)", for: indexPath) as!
            CollectionViewCell
        cell.model = models[indexPath.row]
        return cell
    }
    func waterfallLayout(_ waterfallLayout: ZPPFallCollectionLayout?, itemHeightForWidth itemWidth: CGFloat, at indexPath: IndexPath?) -> CGFloat {
        let model = models[indexPath?.row ?? 0]
        let width = model.nickName.width(font: .systemFont(ofSize: 17))
        return width + 30 + 10 + 20
    }
    func collectionScrollerEndNeedModeData() {
        /// 几何形式增加数据 不建议这么做 将self.models 使用临时数据存储
        self.models.append(contentsOf: self.models)
    }
}

extension String {
    
    func width(font: UIFont) -> CGFloat {
        let label = UILabel()
        label.text = self
        label.sizeToFit()
        return label.frame.size.width
    }
    
    
}
