//
//  GalleryViewController.swift
//  SwiftDemo
//
//  Created by xuzepei on 2025/11/21.
//

import UIKit

// MARK: - 1. ViewController

class GalleryViewController: UIViewController, UICollectionViewDelegate, CustomModeSwitchViewDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        // 1. 实例化封装后的模式切换 View
        let modeSwitchView = CustomModeSwitchView(frame: .zero)
        modeSwitchView.delegate = self
        
        // 2. 将 View 添加到控制器并设置 Auto Layout 约束
        self.view.addSubview(modeSwitchView)
        modeSwitchView.translatesAutoresizingMaskIntoConstraints = false
        
        // 假设 ModeSwitchView 位于屏幕底部上方，水平居中
        NSLayoutConstraint.activate([
            modeSwitchView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            // 使用固定的宽度和高度
            modeSwitchView.widthAnchor.constraint(equalToConstant: 200),
            modeSwitchView.heightAnchor.constraint(equalToConstant: 30),
            // 将其放置在 Y 坐标 200 的位置
            modeSwitchView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200)
        ])
        
        // 初始选中模式的反馈
        print("初始化完成，默认模式: \(modeSwitchView.modes[modeSwitchView.modes.count / 2])")
    }
    
    // MARK: - CustomModeSwitchViewDelegate
    
    func modeSwitchView(_ modeSwitchView: CustomModeSwitchView, didSelectMode mode: String, at index: Int) {
        print("当前选中模式已切换到: \(mode) (索引: \(index))")
        // 在这里可以执行相机模式切换的逻辑
    }
}


// MARK: - Protocol
protocol CustomModeSwitchViewDelegate: AnyObject {
    func modeSwitchView(_ modeSwitchView: CustomModeSwitchView, didSelectMode mode: String, at index: Int)
}


// MARK: - ModeCell：自定义 Cell 显示模式文字

class ModeCell: UICollectionViewCell {
    
    let modeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Label 基础设置
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        modeLabel.textColor = .white
        modeLabel.textAlignment = .center
        modeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        contentView.addSubview(modeLabel)
        
        NSLayoutConstraint.activate([
            modeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            modeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            modeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            modeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /// 配置文字和选中状态
    func configure(with modeName: String, isSelected: Bool) {
        modeLabel.text = modeName
        
        if isSelected {
            modeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            modeLabel.textColor = .systemYellow
        } else {
            modeLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            modeLabel.textColor = .white.withAlphaComponent(0.8)
        }
    }
}

// MARK: - ModeFlowLayout：支持缩放 + 居中吸附

class ModeFlowLayout: UICollectionViewFlowLayout {
    
    /// 动态宽度回调（由外部计算）
    var itemWidths: [CGFloat] = []
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        scrollDirection = .horizontal

        // 头尾间距 = (collection 宽度 - item 宽度) / 2
        let firstWidth = itemWidths.first ?? 60
        let lastWidth = itemWidths.last ?? 60
        
        let left = (collectionView.frame.width - firstWidth) / 2
        let right = (collectionView.frame.width - lastWidth) / 2
        
        sectionInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: right)
        minimumLineSpacing = 0
    }
    
    /// 动态缩放效果
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let list = super.layoutAttributesForElements(in: rect)?.map({ $0.copy() as! UICollectionViewLayoutAttributes }),
              let collectionView = self.collectionView else { return nil }
        
        let centerX = collectionView.contentOffset.x + collectionView.frame.width / 2
        let multiplier: CGFloat = 0.4
        
        for attr in list {
            let delta = abs(centerX - attr.center.x)
            let maxDelta = collectionView.frame.width / 2 + attr.size.width
            
            let factor = min(delta / maxDelta, 1.0) * multiplier
            let scale = 1 - factor
            
            attr.transform = CGAffineTransform(scaleX: scale, y: scale)
            let alphaFactor = 1.0 - (delta / maxDelta) * 0.5
            attr.alpha = max(0.6, alphaFactor)
        }
        return list
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// 居中吸附
    override func targetContentOffset(forProposedContentOffset proposed: CGPoint,
                                      withScrollingVelocity velocity: CGPoint)
    -> CGPoint {
        
        guard let collectionView = collectionView else { return proposed }
        
        let centerX = proposed.x + collectionView.frame.width / 2
        
        let rect = CGRect(x: proposed.x, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        guard let attributesArray = super.layoutAttributesForElements(in: rect) else {
            return proposed
        }
        
        var minDelta = CGFloat.greatestFiniteMagnitude
        
        for attr in attributesArray {
            let delta = attr.center.x - centerX
            if abs(delta) < abs(minDelta) { minDelta = delta }
        }
        
        return CGPoint(x: proposed.x + minDelta, y: proposed.y)
    }
}

// MARK: - CustomModeSwitchView：主组件（对外暴露的模式切换控件）

class CustomModeSwitchView: UIView {
    
    private static let identifier = "mode_cell"
    
    /// 模式名称数组
    var modes: [String] = [] {
        didSet {
            calculateItemWidths()   // 关键：动态计算宽度
            collectionView.reloadData()
            
            if modes.count > 0 {
                let idx = modes.count / 2
                selectedModeIndex = idx
                
                collectionView.layoutIfNeeded()
                collectionView.scrollToItem(at: IndexPath(item: idx, section: 0),
                                            at: .centeredHorizontally,
                                            animated: false)
            }
        }
    }
    
    /// 存放每个 mode 的宽度（由文字宽度决定）
    private var itemWidths: [CGFloat] = []
    
    /// 当前选中下标
    private var selectedModeIndex: Int = 0 {
        didSet {
            if oldValue != selectedModeIndex {
                refreshVisibleCells()
                delegate?.modeSwitchView(self, didSelectMode: modes[selectedModeIndex], at: selectedModeIndex)
            }
        }
    }
    
    weak var delegate: CustomModeSwitchViewDelegate?
    
    private let collectionView: UICollectionView
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        let layout = ModeFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: frame)
        
        setupCollectionView(layout: layout)
        
        // 默认模式
        self.modes = ["Photo", "Video", "Time-Lapse"]
        calculateItemWidths()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - 动态计算每个模式文字宽度
    
    private func calculateItemWidths() {
        itemWidths = modes.map { title in
            let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            let textWidth = (title as NSString).size(withAttributes: [.font: font]).width
            return textWidth + 4    // 加 padding，避免太贴边
        }
        
        // 同步给 layout
        if let layout = collectionView.collectionViewLayout as? ModeFlowLayout {
            layout.itemWidths = itemWidths
        }
    }
    
    // MARK: - CollectionView Setup
    
    private func setupCollectionView(layout: ModeFlowLayout) {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.decelerationRate = .init(rawValue: 0.97)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ModeCell.self, forCellWithReuseIdentifier: Self.identifier)
    }
    
    // MARK: - 刷新可见 Cell（用于选中态变化）
    
    private func refreshVisibleCells() {
        for cell in collectionView.visibleCells {
            if let modeCell = cell as? ModeCell,
               let index = collectionView.indexPath(for: cell)?.item {
                modeCell.configure(with: modes[index], isSelected: index == selectedModeIndex)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CustomModeSwitchView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        modes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.identifier,
                                                            for: indexPath) as? ModeCell else {
            return UICollectionViewCell()
        }
        
        let isSel = indexPath.item == selectedModeIndex
        cell.configure(with: modes[indexPath.item], isSelected: isSel)
        return cell
    }
}

// MARK: - Delegate + FlowLayout

extension CustomModeSwitchView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    /// 动态返回 ItemSize
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidths[indexPath.item]
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    /// 点击 cell → 居中吸附 + 切换模式
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        selectedModeIndex = indexPath.item
    }
    
    /// 滚动停止后更新中心模式
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCenterMode()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate dec: Bool) {
        if !dec { updateCenterMode() }
    }
    
    private func updateCenterMode() {
        guard let layout = collectionView.collectionViewLayout as? ModeFlowLayout else { return }
        
        let centerX = collectionView.contentOffset.x + collectionView.frame.width / 2
        let rect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        
        guard let attrs = layout.layoutAttributesForElements(in: rect) else { return }
        
        var minDelta: CGFloat = .greatestFiniteMagnitude
        var index: Int?
        
        for a in attrs {
            let d = abs(a.center.x - centerX)
            if d < minDelta {
                minDelta = d
                index = a.indexPath.item
            }
        }
        
        if let idx = index, idx != selectedModeIndex {
            selectedModeIndex = idx
        }
    }
}

