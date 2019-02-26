//
//  ValueAdjustView.swift
//  ValueAdjust
//
//  Created by Sansi Mac on 2019/2/18.
//  Copyright © 2019 gh. All rights reserved.
//
// swiftlint:disable line_length

import UIKit

class GHValueAdjustView: UIView {
    private var origPoint: CGPoint = CGPoint.zero

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.init(red: 21/255.0, green: 24/255.0, blue: 38/255.0, alpha: 1.0)
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.init(red: 48/255.0, green: 54/255.0, blue: 76/255.0, alpha: 1.0).cgColor

        addSubview(thumbView)
        addSubview(volumeView)
        addSubview(valueLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        valueLabel.frame = CGRect(x: 0, y: bounds.maxY-50-17, width: bounds.width, height: 17)
        volumeView.frame = CGRect(x: (bounds.width-25)/2, y: bounds.maxY-25-25, width: 25, height: 25)
    }
    // MARK: - 懒加载
    fileprivate lazy var thumbView: ThumbChangeView = {
        let view = ThumbChangeView(frame: CGRect(x: bounds.minX, y: bounds.height, width: bounds.width, height: 0))
        return view
    }()
    private lazy var valueLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.textAlignment = .center
        label.textColor = UIColor(red: 16/255.0, green: 69/255.0, blue: 151/255.0, alpha: 1.0)
        label.text = "0%"
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)
        return label
    }()
    private lazy var volumeView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: (bounds.width-25)/2, y: bounds.maxY-25-25, width: 25, height: 25))
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "icon_volume_s")
        return imgView
    }()

    // MARK: - touches 音量值调节
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: self) {
            origPoint = position
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: self) {
            let offsetY = origPoint.y - position.y
            let value = thumbView.bounds.height + offsetY
            setThumbValue(value)
            origPoint = position
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let position: CGPoint = touches.first?.location(in: self) {
            let offsetY = origPoint.y - position.y
            let value = thumbView.bounds.height + offsetY
            setThumbValue(value)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    /// 设置音量 0-100
    ///
    /// - Parameter percent: 0-100 Int
    func setVolumeValue(_ percent: Int) {
        let value = bounds.height*CGFloat(percent)/100
        setThumbValue(value)
    }
    private func setThumbValue(_ height: CGFloat) {
        var value = height
        if value >= bounds.height {
            value = bounds.height
        } else if value <= 0 {
            value = 0
        }
        print("===== \(value)")
        let percent = Int((value / bounds.height)*100)
        let volume = "\(percent)%"
        if percent == 0 {
            volumeView.image = imageFromBundle(named: "icon_volume_n")
            valueLabel.textColor = UIColor(red: 92/255.0, green: 94/255.0, blue: 104/255.0, alpha: 1.0)
        } else {
            volumeView.image = imageFromBundle(named: "icon_volume_s")
            valueLabel.textColor = UIColor(red: 16/255.0, green: 69/255.0, blue: 151/255.0, alpha: 1.0)
        }
        valueLabel.text = volume
        thumbView.frame = CGRect(x: bounds.minX, y: bounds.height-value, width: bounds.width, height: value)
    }

    private func imageFromBundle(named name: String) -> UIImage {
        let bundlePath = Bundle.main.path(forResource: "GHValueAdjustView", ofType: ".bundle")
        let path = Bundle(path: bundlePath!)
        let img = UIImage(named: name, in: path, compatibleWith: nil)
        return img!
    }

}

private class ThumbChangeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 238/255.0, green: 242/255.0, blue: 251/255.0, alpha: 1.0)

        layer.cornerRadius = 12
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.init(red: 37/255.0, green: 40/255.0, blue: 44/255.0, alpha: 1.0).cgColor

        //        layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //    lazy var gradientLayer: CAGradientLayer = {
    //        let layer = CAGradientLayer()
    //        layer.colors = [UIColor(red: 244/255.0, green: 235/255.0, blue: 255/255.0, alpha: 1.0).cgColor, UIColor(red: 238/255.0, green: 242/255.0, blue: 251/255.0, alpha: 1.0).cgColor]
    //        layer.locations = [0.0, 1.0]
    //        layer.startPoint = CGPoint(x: 0.5, y: 0)
    //        layer.endPoint = CGPoint(x: 0.5, y: 1)
    //        layer.frame = bounds
    //        return layer
    //    }()
}
