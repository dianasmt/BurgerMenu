import UIKit

open class StickyPullUpController: UIViewController {
    
    // MARK: - Open properties
    
    /**
     The closure to execute before the view controller's view move to a sticky point.
     The target sticky point, expressed in the pull up controller coordinate system, is provided in the closure parameter.
     */
    open var willMoveToStickyPoint: ((_ point: CGFloat) -> Void)?
    
    /**
     The closure to execute after the view controller's view move to a sticky point.
     The sticky point, expressed in the pull up controller coordinate system, is provided in the closure parameter.
     */
    open var didMoveToStickyPoint: ((_ point: CGFloat) -> Void)?
    
    /**
     The closure to execute when the view controller's view is dragged.
     The point, expressed in the pull up controller parent coordinate system, is provided in the closure parameter.
     */
    open var onDrag: ((_ point: CGFloat) -> Void)?
    
    /**
     The desired size of the pull up controller’s view, in screen units.
     The default value is width: UIScreen.main.bounds.width, height: 400.
     */
    open var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
    
    /**
     The desired size of the pull up controller’s view, in screen units when the device is in landscape mode.
     The default value is (x: 10, y: 10, width: 300, height: UIScreen.main.bounds.height - 20).
     */
    open var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 10, y: 10, width: 300, height: UIScreen.main.bounds.height - 20)
    }
    
    /**
     A list of y values, in screen units expressed in the pull up controller coordinate system.
     At the end of the gestures the pull up controller will scroll to the nearest point in the list.
     
     Please keep in mind that this array should contains only sticky points in the middle of the pull up controller's view;
     There is therefore no need to add the fist one (pullUpControllerPreviewOffset), and/or the last one (pullUpControllerPreferredSize.height).
     
     For a complete list of all the sticky points you can use `pullUpControllerAllStickyPoints`.
     */
    open var pullUpControllerMiddleStickyPoints: [CGFloat] {
        return []
    }
    
    /**
     A CGFloat value that determines how much the pull up controller's view can bounce outside it's size.
     The default value is 0 and that means the the view cannot expand beyond its size.
     */
    open var pullUpControllerBounceOffset: CGFloat {
        return 0
    }
    
    /**
     A CGFloat value that represent the current point, expressed in the pull up controller coordinate system,
     where the pull up controller's view is positioned.
     */
    open var pullUpControllerCurrentPointOffset: CGFloat {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return 0 }
        return parentViewHeight - (topConstraint?.constant ?? 0)
    }
    
    // MARK: - Public properties
    
    /**
     A list of y values, in screen units expressed in the pull up controller coordinate system.
     At the end of the gesture the pull up controller will scroll at the nearest point in the list.
     */
    public final var pullUpControllerAllStickyPoints: [CGFloat] {
        var scAllStickyPoints = [initialStickyPointOffset, pullUpControllerPreferredSize.height].compactMap { $0 }
        scAllStickyPoints.append(contentsOf: pullUpControllerMiddleStickyPoints)
        return scAllStickyPoints.sorted()
    }
    
    private var leftConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    
    private var portraitPreviousStickyPointIndex: Int?
    
    fileprivate weak var internalScrollView: UIScrollView?
    
    private var initialInternalScrollViewContentOffset: CGPoint = .zero
    private var initialStickyPointOffset: CGFloat?
    private var currentStickyPointIndex: Int {
        let stickyPointTreshold = (self.parent?.view.frame.height ?? 0) - (topConstraint?.constant ?? 0)
        let stickyPointsLessCurrentPosition = pullUpControllerAllStickyPoints.map { abs($0 - stickyPointTreshold) }
        guard let minStickyPointDifference = stickyPointsLessCurrentPosition.min() else { return 0 }
        return stickyPointsLessCurrentPosition.firstIndex(of: minStickyPointDifference) ?? 0
    }
    
    // MARK: - Open methods
    
    /**
     This method will move the pull up controller's view in order to show the provided visible point.
     
     You may use on of `pullUpControllerAllStickyPoints` item to provide a valid visible point.
     - parameter visiblePoint: the y value to make visible, in screen units expressed in the pull up controller coordinate system.
     - parameter animated: Pass true to animate the move; otherwise, pass false.
     - parameter completion: The closure to execute after the animation is completed. This block has no return value and takes no parameters. You may specify nil for this parameter.
     */
    open func pullUpControllerMoveToVisiblePoint(_ visiblePoint: CGFloat, animated: Bool, completion: (() -> Void)?) {
        guard
            isPortrait,
            let parentViewHeight = parent?.view.frame.height
            else { return }
        topConstraint?.constant = parentViewHeight - visiblePoint
        willMoveToStickyPoint?(visiblePoint)
        pullUpControllerAnimate(
            withDuration: animated ? 0.3 : 0,
            animations: { [weak self] in
                self?.parent?.view?.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.didMoveToStickyPoint?(visiblePoint)
                completion?()
        })
    }
    
    /**
     This method update the pull up controller's view size according to `pullUpControllerPreferredSize` and `pullUpControllerPreferredLandscapeFrame`.
     If the device is in portrait, the pull up controller's view will be attached to the nearest sticky point after the resize.
     - parameter animated: Pass true to animate the resize; otherwise, pass false.
    */
    open func updatePreferredFrameIfNeeded(animated: Bool) {
        guard
            let parentView = parent?.view
            else { return }
        refreshConstraints(newSize: parentView.frame.size,
                           customTopOffset: parentView.frame.size.height - (pullUpControllerAllStickyPoints.first ?? 0))
        
        pullUpControllerAnimate(
            withDuration: animated ? 0.3 : 0,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    /**
     This method will be called when an animation needs to be performed.
     You can consider override this method and customize the animation using the method
     `UIView.animate(withDuration:, delay:, usingSpringWithDamping:, initialSpringVelocity:, options:, animations:, completion:)`
     - parameter duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
     - parameter animations: A block object containing the changes to commit to the views.
     - parameter completion: A block object to be executed when the animation sequence ends.
    */
    open func pullUpControllerAnimate(withDuration duration: TimeInterval,
                                      animations: @escaping () -> Void,
                                      completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let isNewSizePortrait = size.height > size.width
        var targetStickyPoint: CGFloat?
        
        if !isNewSizePortrait {
            portraitPreviousStickyPointIndex = currentStickyPointIndex
        } else if
            let portraitPreviousStickyPointIndex = portraitPreviousStickyPointIndex,
            portraitPreviousStickyPointIndex < pullUpControllerAllStickyPoints.count
        {
            targetStickyPoint = pullUpControllerAllStickyPoints[portraitPreviousStickyPointIndex]
            self.portraitPreviousStickyPointIndex = nil
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.refreshConstraints(newSize: size)
            if let targetStickyPoint = targetStickyPoint {
                self?.pullUpControllerMoveToVisiblePoint(targetStickyPoint, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - Setup
    
    fileprivate func setup(superview: UIView, initialStickyPointOffset: CGFloat) {
        self.initialStickyPointOffset = initialStickyPointOffset
        view.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(view)
        view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,
                                            y: superview.bounds.height),
                            size: view.frame.size)
        
        setupPanGestureRecognizer()
        setupConstraints()
        refreshConstraints(newSize: superview.frame.size,
                           customTopOffset: superview.frame.height - initialStickyPointOffset)
    }
    
    private func setupPanGestureRecognizer() {
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        panGestureRecognizer?.minimumNumberOfTouches = 1
        panGestureRecognizer?.maximumNumberOfTouches = 1
        panGestureRecognizer?.delegate = self
        if let panGestureRecognizer = panGestureRecognizer {
            view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    private func setupConstraints() {
        guard
            let parentView = parent?.view
            else { return }
        
        topConstraint = view.topAnchor.constraint(equalTo: parentView.topAnchor)
        leftConstraint = view.leftAnchor.constraint(equalTo: parentView.leftAnchor)
        widthConstraint = view.widthAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.width)
        heightConstraint = view.heightAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.height)
        heightConstraint?.priority = .defaultLow
        bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        let constraintsToActivate = [topConstraint,
                                     leftConstraint,
                                     widthConstraint,
                                     heightConstraint,
                                     bottomConstraint].compactMap { $0 }
        NSLayoutConstraint.activate(constraintsToActivate)
    }
    
    private func refreshConstraints(newSize: CGSize, customTopOffset: CGFloat? = nil) {
        if newSize.height > newSize.width {
            setPortraitConstraints(parentViewSize: newSize, customTopOffset: customTopOffset)
        } else {
            setLandscapeConstraints()
        }
    }
    
    private func nearestStickyPointY(yVelocity: CGFloat) -> CGFloat {
        var currentStickyPointIndex = self.currentStickyPointIndex
        // MARK: - allow this property to be customized
        if abs(yVelocity) > 700 { // 1000 points/sec = "fast" scroll
            if yVelocity > 0 {
                currentStickyPointIndex = max(currentStickyPointIndex - 1, 0)
            } else {
                currentStickyPointIndex = min(currentStickyPointIndex + 1, pullUpControllerAllStickyPoints.count - 1)
            }
        }
        
        return (parent?.view.frame.height ?? 0) - pullUpControllerAllStickyPoints[currentStickyPointIndex]
    }
    
    @objc private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            isPortrait,
            let topConstraint = topConstraint,
            let lastStickyPoint = pullUpControllerAllStickyPoints.last,
            let parentView = parent?.view
            else { return }
        
        let parentViewHeight = parentView.frame.height
        var yTranslation = gestureRecognizer.translation(in: parentView).y
        gestureRecognizer.setTranslation(.zero, in: view)
        
        let scrollViewPanVelocity = internalScrollView?.panGestureRecognizer.velocity(in: parentView).y ?? 0
        let isScrollingDown = scrollViewPanVelocity > 0
        
        /**
         A Boolean value that controls whether the scroll view scroll should pan the parent view up **or** down.
         
         1. The user should be able to drag the view down through the internal scroll view when
            - the scroll direction is down (`isScrollingDown`)
            - the internal scroll view is scrolled to the top (`scrollView.contentOffset.y <= 0`)
         
         2. The user should be able to drag the view up through the internal scroll view when
            - the scroll direction is up (`!isScrollingDown`)
            - the PullUpController's view is fully opened. (`topConstraint.constant != parentViewHeight - lastStickyPoint`)
         */
        let shouldDragView: Bool = {
            // Condition 1
            let shouldDragViewDown = isScrollingDown && internalScrollView?.contentOffset.y ?? 0 <= 0
            // Condition 2
            let shouldDragViewUp = !isScrollingDown && topConstraint.constant != parentViewHeight - lastStickyPoint
            return shouldDragViewDown || shouldDragViewUp
        }()
        
        switch gestureRecognizer.state {
        case .began:
            initialInternalScrollViewContentOffset = internalScrollView?.contentOffset ?? .zero
            
        case .changed:
            // the user is scrolling the internal scroll view
            if scrollViewPanVelocity != 0, let scrollView = internalScrollView {
                // if the user shouldn't be able to drag the view up through the internal scroll view reset the translation
                guard
                    shouldDragView
                    else {
                        yTranslation = 0
                        return
                    }
                // disable the bounces when the user is able to drag the view through the internal scroll view
                scrollView.bounces = false
                if isScrollingDown {
                    if pullUpControllerBounceOffset <= 0 {
                        // take the initial internal scroll view content offset into account when scrolling down is the bouncing is not enabled
                        yTranslation -= initialInternalScrollViewContentOffset.y
                    }
                    initialInternalScrollViewContentOffset = .zero
                } else {
                    // If the user is scrolling "fast" disable the interna scroll view scroll
                    // MARK: - allow this property to be customized
                    if abs(scrollViewPanVelocity) > 1000 {
                        scrollView.isScrollEnabled = false
                    }
                    if topConstraint.constant > parentViewHeight - lastStickyPoint - pullUpControllerBounceOffset {
                        // keep the initial internal scroll view content offset when scrolling up
                        internalScrollView?.contentOffset = initialInternalScrollViewContentOffset
                    }
                }
            }
            setTopOffset(topConstraint.constant + yTranslation)
            
        case .ended:
            internalScrollView?.bounces = true
            internalScrollView?.isScrollEnabled = true
            guard
                shouldDragView
                else { return }
            let yVelocity = gestureRecognizer.velocity(in: view).y // v = px/s
            let targetTopOffset = nearestStickyPointY(yVelocity: yVelocity)
            let distanceToConver = topConstraint.constant - targetTopOffset // px
            let animationDuration = max(0.08, min(0.3, TimeInterval(abs(distanceToConver/yVelocity)))) // s = px/v
            setTopOffset(targetTopOffset, animationDuration: animationDuration)
            
        default:
            break
        }
    }
    
    private func setTopOffset(_ value: CGFloat, animationDuration: TimeInterval? = nil) {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return }
        var value = value
        if  let firstStickyPoint = pullUpControllerAllStickyPoints.first,
            let lastStickyPoint = pullUpControllerAllStickyPoints.last {
            value = max(value, parentViewHeight - lastStickyPoint - pullUpControllerBounceOffset)
            value = min(value, parentViewHeight - firstStickyPoint + pullUpControllerBounceOffset)
        }
        let targetPoint = parentViewHeight - value
        /*
         `willMoveToStickyPoint` and `didMoveToStickyPoint` should be
         called only if the user has ended the gesture
         */
        let shouldNotifyObserver = animationDuration != nil
        topConstraint?.constant = value
        onDrag?(targetPoint)
        if shouldNotifyObserver {
            willMoveToStickyPoint?(targetPoint)
        }
        pullUpControllerAnimate(
            withDuration: animationDuration ?? 0,
            animations: { [weak self] in
                self?.parent?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                if shouldNotifyObserver {
                    self?.didMoveToStickyPoint?(targetPoint)
                }
            }
        )
    }
    
    private func setPortraitConstraints(parentViewSize: CGSize, customTopOffset: CGFloat? = nil) {
        if let customTopOffset = customTopOffset {
            topConstraint?.constant = customTopOffset
        } else {
            topConstraint?.constant = nearestStickyPointY(yVelocity: 0)
        }
        leftConstraint?.constant = (parentViewSize.width - min(pullUpControllerPreferredSize.width, parentViewSize.width))/2
        widthConstraint?.constant = pullUpControllerPreferredSize.width
        heightConstraint?.constant = pullUpControllerPreferredSize.height
        heightConstraint?.priority = .defaultLow
        bottomConstraint?.constant = 0
    }
    
    private func setLandscapeConstraints() {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return }
        let landscapeFrame = pullUpControllerPreferredLandscapeFrame
        topConstraint?.constant = landscapeFrame.origin.y
        leftConstraint?.constant = landscapeFrame.origin.x
        widthConstraint?.constant = landscapeFrame.width
        heightConstraint?.constant = landscapeFrame.height
        heightConstraint?.priority = .defaultHigh
        bottomConstraint?.constant = parentViewHeight - landscapeFrame.height - landscapeFrame.origin.y
    }
    
}

extension StickyPullUpController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension UIViewController {
    
    /**
     Adds the specified pull up view controller as a child of the current view controller.
     - parameter pullUpController: the pull up controller to add as a child of the current view controller.
     - parameter initialStickyPointOffset: The point where the provided `pullUpController`'s view will be initially placed expressed in screen units of the pull up controller coordinate system.
     - parameter animated: Pass true to animate the adding; otherwise, pass false.
     */
    open func addPullUpController(_ pullUpController: StickyPullUpController,
                                  initialStickyPointOffset: CGFloat,
                                  animated: Bool) {
        assert(!(self is UITableViewController), "It's not possible to attach a PullUpController to a UITableViewController.")
        addChild(pullUpController)
        pullUpController.setup(superview: view, initialStickyPointOffset: initialStickyPointOffset)
        pullUpController.pullUpControllerAnimate(
            withDuration: animated ? 0.3 : 0,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    /**
     Adds the specified pull up view controller as a child of the current view controller.
     - parameter pullUpController: the pull up controller to add as a child of the current view controller.
     - parameter initialStickyPointOffset: The point where the provided `pullUpController`'s view will be initially placed expressed in screen units of the pull up controller coordinate system.
     - parameter duration: animation duration.
     */
    open func addPullUpController(_ pullUpController: StickyPullUpController,
                                  initialStickyPointOffset: CGFloat, duration: Double) {
        assert(!(self is UITableViewController), "It's not possible to attach a PullUpController to a UITableViewController.")
        addChild(pullUpController)
        pullUpController.setup(superview: view, initialStickyPointOffset: initialStickyPointOffset)
        pullUpController.pullUpControllerAnimate(
            withDuration: duration,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    /**
     Adds the specified pull up view controller as a child of the current view controller.
     - parameter pullUpController: the pull up controller to remove as a child from the current view controller.
     - parameter animated: Pass true to animate the removing; otherwise, pass false.
     */
    open func removePullUpController(_ pullUpController: StickyPullUpController, animated: Bool) {
        pullUpController.pullUpControllerMoveToVisiblePoint(0, animated: animated) {
            pullUpController.willMove(toParent: nil)
            pullUpController.view.removeFromSuperview()
            pullUpController.removeFromParent()
        }
    }
    
}

extension UIScrollView {
    
    /**
     Attach the scroll view to the provided pull up controller in order to move it with the scroll view content.
     - parameter pullUpController: the pull up controller to move with the current scroll view content.
     */
    open func attach(to pullUpController: StickyPullUpController) {
        pullUpController.internalScrollView = self
    }
    
    /**
     Remove the scroll view from the pull up controller so it no longer moves with the scroll view content.
     - parameter pullUpController: the pull up controller to be removed from controlling the scroll view.
     */
    open func detach(from pullUpController: StickyPullUpController) {
        pullUpController.internalScrollView = nil
    }

}

extension StickyPullUpController {
    var isOnTop: Bool {
        return pullUpControllerCurrentPointOffset > bottomHeaderHeight()
    }

    var isOpened: Bool {
        return pullUpControllerCurrentPointOffset > (pullUpControllerAllStickyPoints.max() ?? 0.0) - 10
    }

    var isNearTop: Bool {
        return pullUpControllerCurrentPointOffset > bottomHeaderHeight() + 10
    }

    func addPullUp(viewController: UIViewController) {
        viewController.addPullUpController(self, initialStickyPointOffset: bottomHeaderHeight(), animated: true)
    }

    func addPullUp(with duration: Double, viewController: UIViewController) {
        viewController.addPullUpController(self, initialStickyPointOffset: bottomHeaderHeight(), duration: duration)
    }

    func didPressPullUpButton() {
        if isOnTop {
            pullUpControllerMoveToVisiblePoint(initialStickyPointOffset ?? 100, animated: true, completion: nil)
        } else {
            pullUpControllerMoveToVisiblePoint(pullUpControllerPreferredSize.height, animated: true, completion: nil)
        }
    }

    func bottomHeaderHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let homescreenContentHeight = screenWidth / 0.845
        return screenHeight - homescreenContentHeight
    }
}
