import SpriteKit
import SwiftUI

struct ContentView: View {
    @State private var scene: GameScene = {
        let bounds = UIScreen.main.bounds
        return GameScene(size: bounds.size)
    }()

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
