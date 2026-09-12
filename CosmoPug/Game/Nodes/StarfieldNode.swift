import SpriteKit

final class StarfieldNode: SKNode {
    init(size: CGSize) {
        super.init()
        zPosition = -10
        for layer in 0..<3 {
            let count = 24 + layer * 12
            let speed = 40 + CGFloat(layer) * 35
            for _ in 0..<count {
                let star = SKShapeNode(circleOfRadius: CGFloat(1 + layer))
                star.fillColor = SKColor(white: 0.7 + CGFloat(layer) * 0.1, alpha: 1)
                star.strokeColor = .clear
                star.position = CGPoint(
                    x: CGFloat.random(in: -size.width / 2...size.width / 2),
                    y: CGFloat.random(in: -size.height / 2...size.height / 2)
                )
                addChild(star)
                scroll(star: star, speed: speed, height: size.height)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }

    private func scroll(star: SKNode, speed: CGFloat, height: CGFloat) {
        let travel = height + 40
        let duration = TimeInterval(travel / speed)
        let moveDown = SKAction.moveBy(x: 0, y: -travel, duration: duration)
        let reset = SKAction.run { [weak star] in
            star?.position.y = height / 2 + 20
        }
        star.run(SKAction.repeatForever(SKAction.sequence([moveDown, reset])))
    }
}
