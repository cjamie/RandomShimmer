
import SwiftUI

extension Color {
    func darker(by percentage: CGFloat = 30.0) -> Color {
        return self.adjust(by: -abs(percentage))
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return Color(
            red: Double(max(red + percentage / 100, 0.0)),
            green: Double(max(green + percentage / 100, 0.0)),
            blue: Double(max(blue + percentage / 100, 0.0)),
            opacity: Double(alpha)
        )
    }
}
