import SpriteKit

final class PlayerNode: SKNode {
    var lives = 3
    var onDeath: (() -> Void)?

    private var fireCooldown: TimeInterval = 0
    private let fireInterval: TimeInterval = 0.18
    private var invulnerableUntil: TimeInterval = 0

    override init() {
        super.init()
        buildShip()
        setupPhysics()
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }

    private func buildShip() {
        let body = SKShapeNode(rectOf: CGSize(width: 44, height: 52), cornerRadius: 10)
        body.fillColor = SKColor(red: 0.95, green: 0.72, blue: 0.45, alpha: 1)
        body.strokeColor = SKColor(red: 0.55, green: 0.35, blue: 0.2, alpha: 1)
        body.lineWidth = 2
        addChild(body)

        let cockpit = SKShapeNode(circleOfRadius: 8)
        cockpit.fillColor = SKColor(red: 0.55, green: 0.85, blue: 1, alpha: 1)
        cockpit.strokeColor = .clear
        cockpit.position = CGPoint(x: 0, y: 8)
        addChild(cockpit)

        let earL = SKShapeNode(circleOfRadius: 7)
        earL.fillColor = body.fillColor
        earL.strokeColor = .clear
        earL.position = CGPoint(x: -16, y: 22)
        addChild(earL)

        let earR = SKShapeNode(circleOfRadius: 7)
        earR.fillColor = body.fillColor
        earR.strokeColor = .clear
        earR.position = CGPoint(x: 16, y: 22)
        addChild(earR)

        let flame = SKShapeNode(rectOf: CGSize(width: 10, height: 14), cornerRadius: 3)
        flame.fillColor = SKColor(red: 1, green: 0.45, blue: 0.2, alpha: 1)
        flame.strokeColor = .clear
        flame.position = CGPoint(x: 0, y: -34)
        flame.name = "flame"
        addChild(flame)
    }

    private func setupPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 36, height: 44))
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = 1 << 0
        physicsBody?.contactTestBitMask = (1 << 2)
        physicsBody?.collisionBitMask = 0
    }

    func update(delta: TimeInterval, sceneSize: CGSize) {
        animateFlame()
        fireCooldown -= delta
        if fireCooldown <= 0 {
            fireCooldown = fireInterval
            shoot(in: sceneSize)
        }
        clampToScene(size: sceneSize)
    }

    func clampToScene(size: CGSize? = nil) {
        guard let scene = scene else { return }
        let sceneSize = size ?? scene.size
        let margin: CGFloat = 36
        position.x = min(max(position.x, -sceneSize.width / 2 + margin), sceneSize.width / 2 - margin)
        position.y = min(max(position.y, -sceneSize.height / 2 + margin), sceneSize.height / 2 - margin)
    }

    private func animateFlame() {
        guard let flame = childNode(withName: "flame") else { return }
        let scale = CGFloat.random(in: 0.85...1.15)
        flame.setScale(scale)
    }

    private func shoot(in sceneSize: CGSize) {
        let bullet = BulletNode(isPlayer: true)
        bullet.position = convert(CGPoint(x: 0, y: 28), to: scene!)
        scene?.addChild(bullet)
    }

    func takeHit() {
        let now = CACurrentMediaTime()
        guard now >= invulnerableUntil else { return }
        invulnerableUntil = now + 1.2
        lives -= 1
        onDeath?()
    }
}
