//
//  ZPPFallCollectionView.swift
//  ZPPFallCollection_Example
//
//  Created by admin on 2020/11/30.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

public protocol ZPPFallCollectionViewDelegate {
    /// 数据滚动完毕后 增加数据维持滚动样式 可循环添加数据 可新增数据
    func collectionScrollerEndNeedModeData()
}
public class ZPPFallCollectionView: UICollectionView {
    private var isResume = false
    private var timer: DispatchSourceTimer?
    private var deleagte: ZPPFallCollectionViewDelegate?
    private var seep: Int = 0
    private var startX: CGFloat = 0
    
    /// 自定义初始化方法
    /// - Parameters:
    ///   - frame: collection frame
    ///   - layout: collection layout
    ///   - delegate: ZPPFallCollectionViewDelegate
    ///   - seep: 滚动速度 - 取值范围 0 - 100
    ///   - startX: 滚动起始位置
    public convenience init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, delegate: ZPPFallCollectionViewDelegate, seep: Int, startX: CGFloat) {
        self.init(frame: frame, collectionViewLayout: layout)
        self.deleagte = delegate
        self.startX = startX
        self.seep = seep
        self.contentInset = UIEdgeInsetsMake(0, startX, 0, 0)
        addTimer()
    }
    
    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addTimer() {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: DispatchTimeInterval.milliseconds((100 - self.seep) / 10 + 3))
        timer?.setEventHandler {
            DispatchQueue.main.async {
                if  self.contentSize.width -  self.contentOffset.x < 800 {
                    if let delegateSafe = self.deleagte {
                        delegateSafe.collectionScrollerEndNeedModeData()
                        self.reloadData()
                    }else{
                        self.cancleTimer()
                    }
                }
                self.contentOffset = CGPoint(x: self.contentOffset.x + 0.35, y: 0)
            }
        }
        isResume = true
        timer?.resume()
    }
    public func suspend() {
        isResume = false
        timer?.suspend()
    }
    public func resume() {
        if isResume {
            return
        }
        timer?.resume()
    }
    private func cancleTimer() {
        isResume = false
        guard let t = timer else {
            return
        }
        t.cancel()
        timer = nil
    }
}
