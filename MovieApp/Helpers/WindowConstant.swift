//
//  WindowConstant.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import UIKit

struct WindowConstant {
    private static let window = UIApplication.shared.connectedScenes.first as? UIWindowScene
    static var getTopPadding: CGFloat {
        return window?.windows.first?.safeAreaInsets.top ?? 0
    }
    static var getBottomPadding: CGFloat {
        return window?.windows.first?.safeAreaInsets.bottom ?? 0
    }
}
