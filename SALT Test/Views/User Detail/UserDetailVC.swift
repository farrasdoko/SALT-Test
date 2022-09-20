//
//  UserDetailVC.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import UIKit

class UserDetailVC: UIViewController {

    @IBOutlet weak var avatarImgView: UIImageView!
    @IBOutlet weak var fullNameTxt: UILabel!
    @IBOutlet weak var emailTxt: UILabel!
    
    var viewModel: UserDetailVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearAllData()
        
        let client = HTTPClientHelper()
        let helper = UserDetailHelper(client: client)
        let vm = UserDetailVM(helper: helper)
        self.viewModel = vm
        
        viewModel?.getUser() { [weak self] res in
            guard let self = self else {return}
            
            switch res {
            case .success(let data):
                self.fullNameTxt.text = "\(data.firstName) \(data.lastName)"
                self.emailTxt.text = data.email
                if let imageData = try? Data(contentsOf: URL(string: data.avatar)!) {
                    self.avatarImgView.image = UIImage(data: imageData)
                }
            case .failed(let msg):
                self.showAlert(msg: msg)
            case .otherError:
                self.showAlert(msg: "Unknown error occured. Please try again later")
            }
        }
    }
    
    private func clearAllData() {
        fullNameTxt.text = ""
        emailTxt.text = ""
    }
    
    private func showAlert(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

}
