//
//  OnboardingWelcomeScreenViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Aibek on 26.07.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class OnboardingWelcomeViewController: BaseViewController {
    
    // MARK: - Consts
    private enum Consts {
        static let titleButtonContinue = "onboarding_welcome_screen_continue_button_state_one"
        static let titleButtonRegister = "onboarding_welcome_screen_continue_button_state_two"
    }
    
    // MARK: - Outlets
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width,
                                 height: UIScreen.main.bounds.height - 268)
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.className)
        return collectionView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(.localString(stringKey: Consts.titleButtonContinue), for: .normal)
        button.titleLabel?.font = .fontSFProText(type: .regular, size: 16)
        button.setTitleColor(.customBlack, for: .normal)
        button.backgroundColor = .customYellow
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = interactor?.pages.count ?? 0
        pc.currentPageIndicatorTintColor = .customYellow
        pc.layer.borderColor = UIColor.gray.cgColor
        pc.pageIndicatorTintColor = .customGray
        pc.isUserInteractionEnabled = false
        return pc
    }()
    
    // MARK: - Override properties
    override var titleLabel: String? {
        return .localString(stringKey: Consts.titleButtonRegister)
    }
    
    // MARK: - Properties
    var router: OnboardingWelcomeRoutingLogic?
    var interactor: OnboardingWelcomeInteractor?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubviews()
        setupLayouts()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        [collectionView, pageControl, continueButton].forEach { view.addSubview($0) }
    }
    
    private func setupLayouts() {
        pageControl.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(20)
            maker.right.left.equalToSuperview()
            maker.bottom.equalToSuperview().inset(160)
        }
        
        continueButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(60)
            maker.width.equalTo(345)
            maker.bottom.equalToSuperview().inset(57)
        }
        
        collectionView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(88)
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(pageControl.snp.top).inset(201)
        }
    }
}

// MARK: - Actions
extension OnboardingWelcomeViewController {
    @objc private func handleNext() {
        let currentPage = pageControl.currentPage
        let pagesCount = interactor?.pages.count ?? .zero
        let nextIndex = min(currentPage + 1, pagesCount - 1)
        executeNext(nextIndex: nextIndex)
    }
    
    private func executeNext(nextIndex: Int) {
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.isPagingEnabled = false
        collectionView.scrollToItem(at: indexPath,
                                    at: .left,
                                    animated: true)
        collectionView.isPagingEnabled = true
        
        let titleKey = nextIndex == 3 ? Consts.titleButtonRegister
                                      : Consts.titleButtonContinue
        continueButton.setTitle(.localString(stringKey: titleKey), for: .normal)
    }
}

// MARK: -UICollectionViewDelegateFlowLayout
extension OnboardingWelcomeViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let nextIndex = Int(x / view.frame.width)
        executeNext(nextIndex: nextIndex)
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate
extension OnboardingWelcomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor?.pages.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.className, for: indexPath) as? PageCell
        else { return UITableViewCell() }
        guard let page = interactor?.pages[indexPath.row] else { return cell }
        cell.updateUI(page: page)
        return cell
    }
}

extension OnboardingWelcomeViewController: OnboardingWelcomePresentorOutput {
    func displayData(pages: [PageModel]) {
        pageControl.numberOfPages = pages.count
        collectionView.reloadData()
    }
}
