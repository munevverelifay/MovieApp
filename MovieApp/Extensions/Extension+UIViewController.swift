//
//  Extension+UIViewController.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 8.11.2023.
//

import UIKit

extension UIViewController {
    func showErrorAlert(for error: CustomError) {
        var title = ""
        var message = ""

        switch error {
        case .urlError:
            title = "URL Hatası"
            message = "URL oluşturulamadı."
        case .serverError:
            title = "Sunucu Hatası"
            message = "Sunucu yanıt vermedi."
        case .decodingError:
            title = "Veri Okuma Hatası"
            message = "Veri doğru bir şekilde okunamadı."
        case .networkError:
            title = "Ağ Hatası"
            message = "Ağ bağlantısı yok veya zayıf."
        case .parameterError:
            title = "Parametre Hatası"
            message = "Geçersiz parametreler."
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
