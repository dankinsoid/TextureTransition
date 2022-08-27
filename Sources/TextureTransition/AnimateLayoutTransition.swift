import VDTransition
import AsyncDisplayKit

extension ASDisplayNode {

    public func defaultAnimateLayoutTransition(
        _ context: ASContextTransitioning,
        animation: UIKitAnimation = .default,
        parallelAnimations: (() -> Void)? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard context.isAnimated() else {
            parallelAnimations?()
            completion?(true)
            context.completeTransition(true)
            return
        }
        var insertions: [ASDisplayNode: NodeTransition] = [:]
        context.insertedSubnodes().forEach {
            $0.frame = context.finalFrame(for: $0)
            var transition = $0.transition
            transition.beforeTransition(view: $0)
            transition.update(progress: .insertion(.start), view: $0)
            insertions[$0] = transition
        }
        var removals: [ASDisplayNode: NodeTransition] = [:]
        context.removedSubnodes().forEach {
            $0.frame = context.initialFrame(for: $0)
            var transition = $0.transition
            transition.beforeTransition(view: $0)
            transition.update(progress: .removal(.start), view: $0)
            removals[$0] = transition
        }
        let subnodes = self.subnodes ?? []
        UIView.animate(with: animation) {
            insertions.forEach { $0.value.update(progress: .insertion(.end), view: $0.key) }
            removals.forEach { $0.value.update(progress: .removal(.end), view: $0.key) }
            subnodes.forEach {
                guard insertions[$0] == nil, removals[$0] == nil else { return }
                let finalFrame = context.finalFrame(for: $0)
                guard finalFrame.origin.x != .infinity, finalFrame.origin.y != .infinity else { return }
                $0.frame = context.finalFrame(for: $0)
            }
            parallelAnimations?()
        } completion: {
            removals.forEach { $0.value.setInitialState(view: $0.key) }
            insertions.forEach { $0.value.setInitialState(view: $0.key) }
            completion?($0)
            context.completeTransition($0)
        }
    }
}

extension ASDisplayNode {

    public var transition: NodeTransition {
        get {
            (objc_getAssociatedObject(self, &transitionKey) as? TransitionWrapper)?.transition ?? .identity
        }
        set {
            objc_setAssociatedObject(self, &transitionKey, TransitionWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private final class TransitionWrapper {

    var transition: NodeTransition

    init(_ transition: NodeTransition) {
        self.transition = transition
    }
}

private var transitionKey = "transitionKey"
