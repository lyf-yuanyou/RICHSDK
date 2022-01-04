//
//  MJCustomGifHeader.swift
//  richsdkdemo
//
//  Created by 11号 on 2021/3/10.
//

import MJRefresh
import UIKit

public extension UIScrollView {
    /// 下拉刷新GIF样式
    ///
    /// - rich: rich动画
    /// - spinFade: 球-fade-旋转
    enum RefreshStyle {
        /// rich动画
        case rich
        /// 球-fade-旋转
        case spinFade
    }

    /// 刷新类型
    ///
    /// - header: 下拉刷新
    /// - footer: 上拉加载
    /// - none: 无
    enum RefreshType {
        /// 下拉刷新
        case header
        /// 上拉加载
        case footer
        /// 无
        case none
    }

    /// 添加头部刷新YM logo帧动画
    /// - Parameters:
    ///   - block: 刷新要做的事情，例如请求
    ///   - style: 下拉刷新GIF样式
    func addHeaderRefresh(block: @escaping VoidBlock, style: RefreshStyle = .spinFade) {
        self.mj_header = style == .rich ? MJCustomGifHeader(refreshingBlock: block) : BallSpinFadeHeader(refreshingBlock: block)
    }

    /// 添加脚部刷新
    /// - Parameters:
    ///   - block: 刷新要做的事情，例如请求
    func addFooterRefresh(block: @escaping VoidBlock) {
        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: block)
        self.mj_footer?.isAutomaticallyChangeAlpha = true
    }

    func endHeaderRefresh() {
        self.mj_header?.endRefreshing()
    }

    func endFooterRefresh() {
        self.mj_footer?.endRefreshing()
    }

    func endRefreshWithNoMoreData() {
        self.mj_footer?.endRefreshingWithNoMoreData()
    }
}

/// 下拉刷新logo的帧动画
class MJCustomGifHeader: MJRefreshGifHeader {
    override func prepare() {
        super.prepare()

        let defaulArr = getRefreshingImageArrayWithStartIndex(1, 2)
        let refreshArr = getRefreshingImageArrayWithStartIndex(3, 6)

        // 普通状态
        self.setImages(defaulArr, for: MJRefreshState.idle)
        // 即将刷新状态
        self.setImages(refreshArr, for: MJRefreshState.pulling)
        // 正在刷新状态
        self.setImages(refreshArr, for: MJRefreshState.refreshing)
    }

    func getRefreshingImageArrayWithStartIndex(_ startIndex: Int, _ endIndex: Int) -> [UIImage] {
        var imgArr = [UIImage]()
        for index in startIndex...endIndex {
            let imageName = "load_\(index).png"
            let image = UIImage(named: imageName, in: Localized.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
//            let image = UIImage(named: imageName)
            guard image != nil else { continue }
            imgArr.append(image!)
        }
        return imgArr
    }

    override func placeSubviews() {
        super.placeSubviews()

        // 隐藏状态显示文字
        stateLabel?.isHidden = true
        // 隐藏更新时间文字
        lastUpdatedTimeLabel?.isHidden = true
        // 设置自动切换透明度
        isAutomaticallyChangeAlpha = true
    }
}

/// 下拉刷新转圈动画
class BallSpinFadeHeader: MJRefreshHeader {
    weak var imageView: UIImageView!

    override func prepare() {
        super.prepare()
        let imageView = UIImageView(image: UIImage(named: "tra_loading", in: Localized.bundle, compatibleWith: nil))
        self.addSubview(imageView)
        self.imageView = imageView
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }

    override var state: MJRefreshState {
        didSet {
            switch state {
            case .refreshing:
                // 把图像已z轴旋转
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.fromValue = 0
                animation.toValue = 2 * Double.pi
                animation.duration = 1
                animation.repeatCount = 100
                animation.fillMode = .forwards
                imageView.layer.add(animation, forKey: "transform.rotation.z")
            default:
                imageView.layer.removeAnimation(forKey: "transform.rotation.z")
            }
        }
    }
 }
