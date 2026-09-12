import SpriteKit

final class EnemyNode: SKNode {
    var onKilled: (() -> Void)?

    private var health = 2
    private let descendSpeed: CGFloat

    override init() {
        descendSpeed = CGFloat.random(in: 120...200)
        super.init()
        name = "enemy"
        buildAppearance()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }

    private func buildAppearance() {
        let shell = SKShapeNode(rectOf: CGSize(width: 40, height: 36), cornerRadius: 8)
        shell.fillColor = SKColor(red: 0.55, green: 0.35, blue: 0.85, alpha: 1)
        shell.strokeColor = SKColor(red: 0.35, green: 0.2, blue: 0.55, alpha: 1)
        shell.lineWidth = 2
        addChild(shell)

        let eye = SKShapeNode(circleOfRadius: 6)
        eye.fillColor = SKColor(red: 1, green: 0.35, blue: 0.45, alpha: 1)
        eye.strokeColor = .clear
        eye.position = CGPoint(x: 0, y: 4)
        addChild(eye)
    }

    private func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 34, height: 30))
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = 1 << 2
        physicsBody?.contactTestBitMask = (1 << 1) | (1 << 0)
        physicsBody?.collisionBitMask = 0
    }

    func update(delta: TimeInterval, sceneHeight: CGFloat) {
        position.y -= descendSpeed * CGFloat(delta)
        if position.y < -sceneHeight / 2 - 60 {
            removeFromParent()
        }
    }

    func takeDamage(force: Bool = false) {
        if force {
            health = 0
        } else {
            health -= 1
        }
        if health <= 0 {
            onKilled?()
            run(SKAction.sequence([
                SKAction.group([
                    SKAction.scale(to: 1.4, duration: 0.08),
                    SKAction.fadeOut(withDuration: 0.08)
                ]),
                SKAction.removeFromParent()
            ]))
        } else {
            run(SKAction.sequence([
                SKAction.fadeAlpha(to: 0.5, duration: 0.05),
                SKAction.fadeAlpha(to: 1, duration: 0.05)
            ]))
        }
    }
}
