//
// PullUpContainer.swift
// RMT-Mobile-New-iOS
//
// Created by Диана Смахтина on 26.08.22.
// 
//

import SnapKit
import RxSwift
import RxGesture

protocol PullUpContainerInterface {
    
    /// Pull up container height.
    var height: CGFloat { get }
    
    /// Custom subviews should be added to the content view.
    var contentContainerView: UIView { get }
    
    /// Pull up container initialization (subviews, gestures).
    func initialization()
}

class PullUpContainer: UIView, PullUpContainerInterface {
    
    // MARK: - Typealias
    typealias PullUpTouch = (willMove: Bool, diffBetweenTouchAndView: CGFloat)
    
    // MARK: - Consts
    private enum Consts {
        static let startHeight = 25 * Constants.screenFactor
    }
    
    // MARK: - Outlets
    let contentContainerView = UIView()
    private let contentView = UIView()
    private let headerContainerView = UIView()
    private lazy var topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGreyColor
        view.layer.cornerRadius = 2
        return view
    }()
    
    // MARK: - Properties
    var height: CGFloat = Consts.startHeight
    private let disposeBag = DisposeBag()
    private var touch: PullUpTouch = (willMove: false, diffBetweenTouchAndView: .zero)
    
    // MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialization()
    }
    
    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(corners: [.topLeft, .topRight])
    }
    
    // MARK: - Methods
    func initialization() {
        self.backgroundColor = .white
        self.addSubviews()
        self.addGestureRecognizers()
    }
    
    private func addSubviews() {
        self.addSubview(self.headerContainerView)
        self.addSubview(self.contentView)
        
        self.headerContainerView.addSubview(self.topLineView)
        self.contentView.addSubview(self.contentContainerView)
        
        self.headerContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50 * Constants.screenFactor)
        }
        
        self.contentView.snp.makeConstraints { make in
            make.top.equalTo(self.headerContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.height)
        }
        
        self.topLineView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(5 * Constants.screenFactor)
            make.width.equalTo(30 * Constants.screenFactor)
        }
        
        self.contentContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.headerContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func addGestureRecognizers() {
        self.headerContainerView.rx
            .panGesture()
            .when(.began)
            .asLocation(in: .superview)
            .withUnretained(self)
            .subscribe(onNext: { weakSelf, location in
                weakSelf.touch.diffBetweenTouchAndView = location.y - weakSelf.headerContainerView.bounds.minY
                weakSelf.touch.willMove = true
            })
            .disposed(by: self.disposeBag)
        
        self.rx
            .panGesture()
            .when(.changed, .ended)
            .do(onNext: { [weak self] event in
                if event.state == .ended {
                    self?.touch.willMove  = false
                }
            })
            .filter { _ in self.touch.willMove }
            .asLocation(in: .superview)
            .withUnretained(self)
            .map { weakSelf, location -> (PullUpContainer, CGFloat) in
                let yPos = location.y
                let diff = weakSelf.frame.minY - yPos + weakSelf.touch.diffBetweenTouchAndView
                return (weakSelf, weakSelf.height + diff)
            }
            .filter { weakSelf, resultHeight in
                guard
                    let superview = weakSelf.superview,
                    resultHeight >= Consts.startHeight,
                    resultHeight < superview.bounds.height - 100
                else { return false }
                return true
            }
            .subscribe(onNext: { weakSelf, resultHeight in
                weakSelf.height = resultHeight
                weakSelf.contentView.snp.updateConstraints { make in
                    make.height.equalTo(weakSelf.height)
                }
            })
            .disposed(by: self.disposeBag)
    }
}
