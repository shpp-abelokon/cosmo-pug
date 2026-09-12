import SpriteKit

final class BulletNode: SKNode {
    private let velocity: CGFloat = 520

    init(isPlayer: Bool) {
        super.init()
        let color = isPlayer
            ? SKColor(red: 0.4, green: 0.95, blue: 1, alpha: 1)
            : SKColor(red: 1, green: 0.5, blue: 0.35, alpha: 1)
        let bullet = SKShapeNode(rectOf: CGSize(width: 6, height: 16), cornerRadius: 3)
        bullet.fillColor = color
        bullet.strokeColor = .clear
        addChild(bullet)

        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 6, height: 16))
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = isPlayer ? (1 << 1) : (1 << 3)
        physicsBody?.contactTestBitMask = isPlayer ? (1 << 2) : (1 << 0)
        physicsBody?.collisionBitMask = 0

        let move = SKAction.moveBy(x: 0, y: isPlayer ? 900 : -900, duration: 1.4)
        run(SKAction.sequence([move, SKAction.removeFromParent()]))
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
}
