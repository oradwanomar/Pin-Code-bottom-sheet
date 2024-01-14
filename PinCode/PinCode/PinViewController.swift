//
//  PinViewController.swift
//  PinCode
//
//  Created by Omar Radwan on 09/01/2024.
//

import UIKit

class PinViewController: UIViewController {

    //MARK: Properties
//    var pinCodeList : [Int] = []
    var pinCode: String = ""
    var pinCodeDelegate : PinCodeDelegate?
    var pinCodeIcon: [UIView] = []
    var count: Int = 0
    var pinCodeModel: PINCodeModel?
    var viewStatus: PINCodeStatus?
    
    /// Maximum alpha for dimmed view
    private let maxDimmedAlpha: CGFloat = 0.5
    /// Minimum drag vertically that enable bottom sheet to dismiss
    private let minDismissiblePanHeight: CGFloat = 150
    
    //MARK: Outlets
    @IBOutlet var pinCodeButtons: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var numberOfDigitsLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var hoverView: UIView!{
        didSet{
            hoverView.layer.cornerRadius = 2
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        containerView.layer.cornerRadius = 16
        pinCodeModel = setUpPINCodeModel(status: viewStatus ?? .WalletPINCode)
        setUpView(pinCodeModel: pinCodeModel ?? PINCodeModel())
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dimmedView.alpha = 0
        containerView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        hoverView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.containerView.transform = .identity
            self?.hoverView.transform = .identity
        }
        /// Add more animation duration for smoothness
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }

    @IBAction func numPressed(_ sender: UIButton) {
        switch sender.tag{
        case 0:
            updatePinCode(num: "0")
            print("0")
        case 1:
            updatePinCode(num: "1")
            print("1")
        case 2:
            updatePinCode(num: "2")
            print("2")
        case 3:
            updatePinCode(num: "3")
            print("3")
        case 4:
            updatePinCode(num: "4")
            print("4")
        case 5:
            updatePinCode(num: "5")
            print("5")
        case 6:
            updatePinCode(num: "6")
            print("6")
        case 7:
            updatePinCode(num: "7")
            print("7")
        case 8:
            updatePinCode(num: "8")
            print("8")
        case 9:
            updatePinCode(num: "9")
            print("9")
        case -1:
            updatePinCode(num: "-1")
            print("Delete Element")
            
        default:
            print("default")
        }
    }
    
}
extension PinViewController: NewPinCodeViewProtocol{
    func showAndHideLoading(isLoading: Bool) {
//        loader.isHidden = isLoading
    }
    
    func showAndHideError(onCompletion: () -> Void) {
        if viewStatus == PINCodeStatus.ConfirmCardPINCode{
            
        }
    }
    
    func setUpPINCodeModel(status: PINCodeStatus) -> PINCodeModel{
        switch status{
        case .WalletPINCode:
            return PINCodeModel(title: "Type your wallet PIN code", pinCodelength: 6, isShowForgetPin: false, isShowError: true)
        case .CardPINCode:
            return PINCodeModel(title: "Set your new 4-digit Card PIN code", pinCodelength: 4, isShowForgetPin: true, isShowError: true)
        case .ConfirmCardPINCode:
            return PINCodeModel(title: "Confirm your new 4-digit Card PIN code", pinCodelength: 4, isShowForgetPin: true, isShowError: false)
        }
    }
    
    func setUpView(pinCodeModel: PINCodeModel){
        for button in pinCodeButtons {
            button.layer.cornerRadius = (UIScreen.main.bounds.size.height * 0.09) / 2
            button.titleLabel?.font = UIFont(name: "System", size: 16)
        }
        loader.isHidden = true
        errorButton.isHidden = pinCodeModel.isShowForgetPin ?? false
        numberOfDigitsLabel.text = pinCodeModel.title
        setUpSubviews(pinCodeLength: pinCodeModel.pinCodelength ?? 0)
        stackView.axis  =  NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 10.0
        
        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func updatePinCode(num: String){
        if num != "-1"{
            pinCodeIcon[pinCode.count].tintColor = UIColor(cgColor: CGColor(red: 0, green: 124, blue: 146, alpha: 1))
            pinCode.append(num)
            print("\(num) " + " \(pinCode)")
            
            if (pinCode.count) == (pinCodeModel?.pinCodelength ?? 0){
//                loader.color = .red
//                loader.isHidden = false
//                loader.startAnimating()
                pinCodeIcon.forEach{element in
                    element.tintColor = .red
                }
                for button in pinCodeButtons {
                    button.isEnabled = false
                }
                errorLabel.isHidden = pinCodeModel?.isShowError ?? false
                _ = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false) { timer in
                    self.dismiss(animated: true, completion: {
                        self.pinCodeDelegate?.didEnterWalletPinCode(pinCode: self.pinCode)
                    })
                }
            }
        }else{
            if pinCode.count != 0{
                pinCode.removeLast()
                print(pinCode)
                pinCodeIcon[pinCode.count].tintColor = .gray
            }
        }
       
    }
    
    func setUpSubviews(pinCodeLength: Int){
        for _ in 1...pinCodeLength {
            let imageView = UIImageView(image: UIImage(systemName: "circle.fill"))
            imageView.tintColor = .gray
            pinCodeIcon.append(imageView)
            stackView.addArrangedSubview(imageView)
            stackView.addSubview(imageView)
        }
    }
    
}

extension PinViewController {
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDimmedView))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        containerView.addGestureRecognizer(panGesture)
    }

    @objc private func handleTapDimmedView() {
        dismissBottomSheet()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        // get drag direction
        let isDraggingDown = translation.y > 0
        guard isDraggingDown else { return }
        
        let pannedHeight = translation.y
        let currentY = self.view.frame.height - self.containerView.frame.height
        // handle gesture state
        switch gesture.state {
        case .changed:
            // This state will occur when user is dragging
            self.containerView.frame.origin.y = currentY + pannedHeight
            self.hoverView.frame.origin.y = currentY + pannedHeight - 14
        case .ended:
            // When user stop dragging
            // if fulfil the condition dismiss it, else move to original position
            if pannedHeight >= minDismissiblePanHeight {
                dismissBottomSheet()
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.containerView.frame.origin.y = currentY
                    self.hoverView.frame.origin.y = currentY - 14
                }
            }
        default:
            break
        }
    }
    func dismissBottomSheet() {
        UIView.animate(withDuration: 0.25, animations: {  [weak self] in
            guard let self = self else { return }
            self.dimmedView.alpha = 0
            self.containerView.frame.origin.y = self.view.frame.height
            self.hoverView.frame.origin.y = self.view.frame.height
        }, completion: {  [weak self] _ in
            self?.dismiss(animated: false)
        })
    }
}

protocol PinCodeDelegate {
    func didEnterWalletPinCode(pinCode:String)
}
protocol NewPinCodeViewProtocol{
    func showAndHideLoading(isLoading: Bool)
    func showAndHideError(onCompletion: () -> Void)
    func setUpPINCodeModel(status: PINCodeStatus) -> PINCodeModel
    func updatePinCode(num: String)
}
enum PINCodeStatus{
    case WalletPINCode
    case CardPINCode
    case ConfirmCardPINCode
}
struct PINCodeModel{
    var title: String?
    var pinCodelength: Int?
    var isShowForgetPin: Bool?
    var isShowError: Bool?
}
