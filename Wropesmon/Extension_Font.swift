import Foundation
import SwiftUI

public enum AntonStyle {
    case display, h1, h2, h3
    case body, subheadline, footnote, caption, caption2
    case tabBarLabel
}

private enum AntonFontConst {
    static let name = "AntonSC-Regular"
}

extension AntonStyle {
    fileprivate var size: CGFloat {
        switch self {
        case .display: return 34
        case .h1: return 28
        case .h2: return 22
        case .h3: return 20
        case .body: return 17
        case .subheadline: return 15
        case .footnote: return 13
        case .caption: return 12
        case .caption2: return 11
        case .tabBarLabel: return 11
        }
    }
    fileprivate var relativeTo: Font.TextStyle {
        switch self {
        case .display: return .largeTitle
        case .h1: return .title
        case .h2: return .title2
        case .h3: return .title3
        case .body: return .body
        case .subheadline: return .subheadline
        case .footnote: return .footnote
        case .caption: return .caption
        case .caption2: return .caption2
        case .tabBarLabel: return .caption2
        }
    }
}

public extension Font {
    static func anton(_ style: AntonStyle) -> Font {
        if #available(iOS 14.0, *) {
            return .custom(AntonFontConst.name, size: style.size, relativeTo: style.relativeTo)
        } else {
            return .custom(AntonFontConst.name, size: style.size)
        }
    }

    static func antonFixed(_ style: AntonStyle) -> Font {
        .custom(AntonFontConst.name, size: style.size)
    }

    static func anton(size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        if #available(iOS 14.0, *) {
            return .custom(AntonFontConst.name, size: size, relativeTo: textStyle)
        } else {
            return .custom(AntonFontConst.name, size: size)
        }
    }

    static var antonTabLabel: Font { .anton(.tabBarLabel) }
    static var antonTabLabelFixed: Font { .antonFixed(.tabBarLabel) }
}
