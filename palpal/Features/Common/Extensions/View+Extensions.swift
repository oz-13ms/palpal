import SwiftUI

public extension View {
    func background(color: Color) -> some View {
        background(color.edgesIgnoringSafeArea(.all))
    }
    
    func supportsLongPress(longPressAction: @escaping () -> ()) -> some View {
        modifier(SupportsLongPressModifier(longPressAction: longPressAction))
    }
}
