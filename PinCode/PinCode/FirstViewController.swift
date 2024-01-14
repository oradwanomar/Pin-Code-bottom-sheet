//
//  FirstViewController.swift
//  PinCode
//
//  Created by Omar Radwan on 09/01/2024.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func enterPinCode(_ sender: UIButton) {
        presentPinCodeViewController(status: PINCodeStatus.ConfirmCardPINCode)
    }
    
}
extension FirstViewController: PinCodeDelegate{
    func didEnterWalletPinCode(pinCode: String) {
        print("The Pin Code is: \(pinCode)")
    }

    func presentPinCodeViewController(status: PINCodeStatus) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
        vc.viewStatus = status
        vc.pinCodeDelegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
}


