//
//  SigninRequestVC.swift
//  EveraveUpdate
//
//  Created by Mac on 6/29/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import UIKit

class SigninRequestVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func okBtnClicked(_ sender: Any) {
        self.gotoVC(VCs.LOGINAV)
    }
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
