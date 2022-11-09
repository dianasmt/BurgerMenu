//
//  ATMServiceTooltip.swift
//  RMT-Mobile-New-iOS
//
//  Created by Islam Shamkhanov on 16.09.2022.
//

import Foundation
import UIKit

class ATMServiceTooltip: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .fontSFProText(type: .regular, size: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var containerView = UIView()
    
    private var tooltipLayer: CAShapeLayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(88)
            make.centerX.centerY.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.height.equalTo(titleLabel).offset(10)
            make.width.equalTo(titleLabel).offset(25)
            make.centerX.equalToSuperview()
        }
    }
    
    private func drawShape() {
        let width = (titleLabel.frame.width + 25)
        let height = (titleLabel.frame.height + 10)
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 15)
        path.move(to: CGPoint(x: width/2-5, y: height))
        path.addLine(to: CGPoint(x: width/2+5, y: height))
        path.addLine(to: CGPoint(x: width/2, y: height + 6))
        path.addLine(to: CGPoint(x: width/2-5, y: height))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.customDarkGray.cgColor
        shapeLayer.path = path.cgPath
        
        let pathBounds = shapeLayer.path!.boundingBoxOfPath
        let shapeFrame = CGRect(x: pathBounds.origin.x , y: pathBounds.origin.y, width:
        pathBounds.size.width, height: pathBounds.size.height)
        shapeLayer.bounds = shapeFrame
        shapeLayer.frame  = shapeLayer.bounds
        containerView.frame = shapeLayer.frame
        tooltipLayer?.removeFromSuperlayer()
        self.tooltipLayer = shapeLayer
        containerView.layer.insertSublayer(tooltipLayer!, at: 0)
        frame = containerView.frame
    }
    
    func fill(title: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.layoutIfNeeded()
        drawShape()
    }
}

