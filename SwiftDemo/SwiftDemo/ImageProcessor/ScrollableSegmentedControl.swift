//
//  ScrollableSegmentedControl.swift


import UIKit

class ScrollableSegmentedControl: UIControl {

    // MARK: - Constants
    private let cellId = "segment_cell"
    
    // MARK: - CollectionView
    
    private lazy var collectionView: UICollectionView = {
        
        //创建UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: self.margin,
                                           bottom: 0, right: self.margin)
        let cv = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        cv.register(SegmentCell.self, forCellWithReuseIdentifier: cellId)
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    @IBInspectable public var bounceOnScroll: Bool = true {
        didSet {
            collectionView.bounces = bounceOnScroll
        }
    }
    
    //修改item间的左右间距
    @IBInspectable public var margin: CGFloat = 10 {
        didSet {
            self.collectionView.collectionViewLayout.invalidateLayout()
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: margin,
                                               bottom: 0, right: margin)
            self.collectionView.collectionViewLayout = layout
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Items
    
    @IBInspectable public var items: [String] = ["item0", "item1", "item2", "item3", "item4", "item5", "item6", "item7"] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var selectedItem: String {
        return self.items[self.selectedIndex]
    }
    
    @IBInspectable public var selectedIndex: Int = 0 {
        didSet {
            collectionView.reloadData()
            sendActions(for: .valueChanged)
            hapticsHandler()
        }
    }
    
    // MARK: - Cell Label & Background
    
    @IBInspectable public var selectedBackgroundColor: UIColor = UIColor.systemIndigo.withAlphaComponent(0.1)
    @IBInspectable public var unselectedBackgroundColor: UIColor = UIColor.clear
    @IBInspectable public var selectedTextColor: UIColor = UIColor.systemIndigo
    @IBInspectable public var unselectedTextColor: UIColor = UIColor.label
    @IBInspectable public var font: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    /// Trailing & Leading Insets for the Labels within the cells
    @IBInspectable public var labelPadding: CGFloat = 10 {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Haptics
    
    /// This property enables haptic feedback when tapping on the buttons
    ///  The default value for this property is true
    @IBInspectable public var isHapticsEnabled: Bool = true
    
    public var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light
    public var hapticIntensity: CGFloat = 1.0
    
    private func hapticsHandler() {
        if isHapticsEnabled {
            UIImpactFeedbackGenerator(style: hapticStyle)
                .impactOccurred(intensity: hapticIntensity)
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = true
        self.addSubview(self.collectionView)
        self.collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

}

// MARK: - Delegate

extension ScrollableSegmentedControl: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }
}

// MARK: - Datasource

extension ScrollableSegmentedControl: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? SegmentCell else {
            return UICollectionViewCell()
        }
        cell.label.font = self.font
        cell.label.text = items[indexPath.row]
        
        if indexPath.row == selectedIndex {
            cell.backgroundColor = selectedBackgroundColor
            cell.label.textColor = selectedTextColor
        } else {
            cell.backgroundColor = unselectedBackgroundColor
            cell.label.textColor = unselectedTextColor
        }
        
        cell.layer.cornerRadius = cell.frame.height / 2
        
        return cell
    }
}

// MARK: - FlowLayout

extension ScrollableSegmentedControl: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // Handle Edge Case
        if self.items.isEmpty {
            return CGSize(width: 128, height: self.frame.height)
        }

        // Label for calculating the Width
        let tempLabel = UILabel()
        tempLabel.text = self.items[indexPath.item]
        tempLabel.font = self.font

        // * 2 for leading & trailing
        let width = tempLabel.intrinsicContentSize.width + (self.labelPadding * 2)
        return CGSize(width: width, height: self.frame.height)
    }
}

// MARK: - SegmentCell

private class SegmentCell: UICollectionViewCell {

    public lazy var label: UILabel = {
        let lbl = UILabel(frame: self.bounds)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }

    private func setup() {
        addSubview(label)
        label.center = self.center
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
