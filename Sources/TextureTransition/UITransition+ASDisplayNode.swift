import VDTransition
import AsyncDisplayKit

extension ASDisplayNode {

    /// Animate node with given transition.
    ///
    /// - Parameters:
    ///   - transition: Transition.
    ///   - direction: Transition direction.
    ///   - animation: Animation parameters.
    ///   - restoreState: Restore node state on animation completion
    ///   - completion: Block to be executed when animation finishes.
    public func animate(
        transition: NodeTransition,
        direction: TransitionDirection = .removal,
        animation: UIKitAnimation = .default,
        restoreState: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        var transition = transition
        UIView.performWithoutAnimation {
            transition.beforeTransition(view: self)
            transition.update(progress: direction.at(.start), view: self)
        }
        UIView.animate(with: animation) { [self] in
            transition.update(progress: direction.at(.end), view: self)
        } completion: { [self] _ in
            completion?()
            if restoreState {
                transition.setInitialState(view: self)
            }
        }
    }

    /// Animated change `isHidden` property with given transition.
    ///
    /// - Parameters:
    ///   - hidden: `isHidden` value to be set.
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func set(hidden: Bool, transition: NodeTransition, animation: UIKitAnimation = .default, completion: (() -> Void)? = nil) {
        set(
            hidden: hidden,
            insideAnimation: false,
            set: { $0.isHidden = $1 },
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    /// Animated remove from supernode with given transition.
    ///
    /// - Parameters:
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func removeFromSuperview(transition: NodeTransition, animation: UIKitAnimation = .default, completion: (() -> Void)? = nil) {
        addOrRemove(to: supernode, add: false, transition: transition, animation: animation, completion: completion)
    }

    /// Animated add a subview with given transition.
    ///
    /// - Parameters:
    ///   - subview: Subnode to be added.
    ///   - transition: Transition.
    ///   - animation: Animation parameters.
    ///   - completion: Block to be executed when transition finishes.
    public func add(subview: ASDisplayNode, transition: NodeTransition, animation: UIKitAnimation = .default, completion: (() -> Void)? = nil) {
        subview.addOrRemove(to: self, add: true, transition: transition, animation: animation, completion: completion)
    }

    /// Animated add or remove a subnode with given transition.
    public func addOrRemove(
        to supernode: ASDisplayNode?,
        add: Bool,
        transition: NodeTransition,
        animation: UIKitAnimation = .default,
        completion: (() -> Void)? = nil
    ) {
        set(
            hidden: !add,
            insideAnimation: false,
            set: { if $1 { $0.removeFromSupernode() } else { supernode?.addSubnode(self) } },
            transition: transition,
            animation: animation,
            completion: completion
        )
    }

    private func set(
        hidden: Bool,
        insideAnimation: Bool,
        set: @escaping (ASDisplayNode, Bool) -> Void,
        transition: NodeTransition,
        animation: UIKitAnimation = .default,
        completion: (() -> Void)? = nil
    ) {
        guard !transition.isIdentity else {
            set(self, hidden)
            completion?()
            return
        }
        let direction: TransitionDirection = hidden ? .removal : .insertion
        var transition = transition
        UIView.performWithoutAnimation {
            transition.beforeTransition(view: self)
            transition.update(progress: direction.at(.start), view: self)
            if !hidden, !insideAnimation {
                set(self, false)
            }
        }
        UIView.animate(with: animation) {
            if insideAnimation {
                set(self, hidden)
                self.supernode?.layoutIfNeeded()
            }
            transition.update(progress: direction.at(.end), view: self)
        } completion: { _ in
            if hidden, !insideAnimation {
                set(self, true)
            }
            transition.setInitialState(view: self)
            completion?()
        }
    }
}
