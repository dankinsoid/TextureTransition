import VDTransition
import AsyncDisplayKit

public typealias NodeTransition = UITransition<ASDisplayNode>

extension ASDisplayNode: Transformable {

    public var affineTransform: CGAffineTransform {
        get { view.transform }
        set { view.transform = newValue }
    }

    public var isLtrDirection: Bool {
        view.isLtrDirection
    }
}

extension UITransition where Base == ASDisplayNode {

    /// A transition from transparent to opaque on insertion, and from opaque to transparent on removal.
    public static var opacity: UITransition {
        .value(\.alpha, 0)
    }

    public static func cornerRadius(_ radius: CGFloat) -> UITransition {
        .value(\.cornerRadius, radius)
    }

    public static func backgroundColor(_ color: UIColor) -> UITransition {
        .value(\.backgroundColor, color)
    }
}
