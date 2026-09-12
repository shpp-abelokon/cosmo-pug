import SpriteKit

final class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: PlayerNode!
    private var lastUpdateTime: TimeInterval = 0
    private var spawnAccumulator: TimeInterval = 0
    private var score = 0
    private var isGameOver = false

    private let scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let livesLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
    private let gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")

    private enum PhysicsCategory {
        static let player: UInt32 = 1 << 0
        static let playerBullet: UInt32 = 1 << 1
        static let enemy: UInt32 = 1 << 2
        static let enemyBullet: UInt32 = 1 << 3
    }

    override func didMove(to view: SKView) {
        backgroundColor = SKColor(red: 0.04, green: 0.05, blue: 0.12, alpha: 1)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        addChild(StarfieldNode(size: size))
        setupHUD()
        setupPlayer()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        layoutHUD()
        player?.clampToScene()
    }

    private func setupHUD() {
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        livesLabel.fontSize = 22
        livesLabel.fontColor = SKColor(red: 1, green: 0.75, blue: 0.4, alpha: 1)
        livesLabel.horizontalAlignmentMode = .right
        addChild(livesLabel)

        gameOverLabel.text = "Tap to fly again"
        gameOverLabel.fontSize = 20
        gameOverLabel.fontColor = .white
        gameOverLabel.alpha = 0
        gameOverLabel.numberOfLines = 2
        gameOverLabel.preferredMaxLayoutWidth = size.width * 0.8
        addChild(gameOverLabel)

        updateHUD()
        layoutHUD()
    }

    private func layoutHUD() {
        let top = size.height / 2 - 48
        scoreLabel.position = CGPoint(x: -size.width / 2 + 20, y: top)
        livesLabel.position = CGPoint(x: size.width / 2 - 20, y: top)
        gameOverLabel.position = CGPoint(x: 0, y: -40)
    }

    private func setupPlayer() {
        player = PlayerNode()
        player.position = CGPoint(x: 0, y: -size.height * 0.35)
        player.onDeath = { [weak self] in
            self?.handlePlayerHit()
        }
        addChild(player)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            restart()
            return
        }
        guard let touch = touches.first else { return }
        movePlayer(to: touch.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isGameOver, let touch = touches.first else { return }
        movePlayer(to: touch.location(in: self))
    }

    private func movePlayer(to location: CGPoint) {
        let margin: CGFloat = 36
        let x = min(max(location.x, -size.width / 2 + margin), size.width / 2 - margin)
        let y = min(max(location.y, -size.height / 2 + margin), size.height / 2 - margin)
        player.position = CGPoint(x: x, y: y)
    }

    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        let delta = min(currentTime - lastUpdateTime, 1.0 / 30.0)
        lastUpdateTime = currentTime

        guard !isGameOver else { return }

        player.update(delta: delta, sceneSize: size)

        spawnAccumulator += delta
        let spawnInterval = max(0.45, 1.2 - Double(score) * 0.008)
        if spawnAccumulator >= spawnInterval {
            spawnAccumulator = 0
            spawnEnemy()
        }

        enumerateChildNodes(withName: "enemy") { node, _ in
            guard let enemy = node as? EnemyNode else { return }
            enemy.update(delta: delta, sceneHeight: self.size.height)
        }
    }

    private func spawnEnemy() {
        let enemy = EnemyNode()
        let xRange = size.width * 0.42
        enemy.position = CGPoint(
            x: CGFloat.random(in: -xRange...xRange),
            y: size.height / 2 + 40
        )
        enemy.onKilled = { [weak self] in
            self?.addScore(100)
        }
        addChild(enemy)
    }

    private func addScore(_ points: Int) {
        score += points
        updateHUD()
    }

    private func updateHUD() {
        scoreLabel.text = "Score: \(score)"
        livesLabel.text = "Lives: \(player.lives)"
    }

    private func handlePlayerHit() {
        updateHUD()
        if player.lives <= 0 {
            triggerGameOver()
        } else {
            player.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 0.3, duration: 0.08),
                SKAction.fadeAlpha(to: 1, duration: 0.12)
            ]))
        }
    }

    private func triggerGameOver() {
        isGameOver = true
        player.isPaused = true
        gameOverLabel.run(SKAction.fadeIn(withDuration: 0.3))
    }

    private func restart() {
        removeAllChildren()
        isGameOver = false
        score = 0
        spawnAccumulator = 0
        lastUpdateTime = 0
        gameOverLabel.alpha = 0
        addChild(StarfieldNode(size: size))
        setupHUD()
        setupPlayer()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB
        resolve(contact: a, other: b)
        resolve(contact: b, other: a)
    }

    private func resolve(contact body: SKPhysicsBody, other: SKPhysicsBody) {
        let mask = body.categoryBitMask
        let otherMask = other.categoryBitMask

        if mask == PhysicsCategory.playerBullet && otherMask == PhysicsCategory.enemy {
            (body.node as? BulletNode)?.removeFromParent()
            (other.node as? EnemyNode)?.takeDamage()
        } else if mask == PhysicsCategory.player && otherMask == PhysicsCategory.enemy {
            if let enemy = other.node as? EnemyNode {
                enemy.takeDamage(force: true)
                player.takeHit()
            }
        }
    }
}
