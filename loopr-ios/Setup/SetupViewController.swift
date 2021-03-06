//
//  SetupViewController.swift
//  loopr-ios
//
//  Created by Matthew Cox on 2/4/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {

    @IBOutlet weak var unlockWalletButton: UIButton!
    @IBOutlet weak var generateWalletButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        unlockWalletButton.backgroundColor = UIColor.clear
        unlockWalletButton.titleColor = UIColor.black
        unlockWalletButton.layer.cornerRadius = 23
        unlockWalletButton.layer.borderWidth = 1
        unlockWalletButton.layer.borderColor = UIColor.black.cgColor
        unlockWalletButton.title = NSLocalizedString("Unlock Wallet", comment: "")
        unlockWalletButton.titleLabel?.font = UIFont(name: FontConfigManager.shared.getBold(), size: 17.0)
        
        generateWalletButton.backgroundColor = UIColor.black
        generateWalletButton.layer.cornerRadius = 23
        generateWalletButton.title = NSLocalizedString("Generate Wallet", comment: "")
        generateWalletButton.titleLabel?.font = UIFont(name: FontConfigManager.shared.getBold(), size: 17.0)

        let skipButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(self.skipButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = skipButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unlockWalletButtonPressed(_ sender: Any) {
        let viewController = UnlockWalletSwipeViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func generateWalletButtonPressed(_ sender: Any) {
        let viewController = GenerateWalletViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func skipButtonPressed(_ sender: Any) {
        if SetupDataManager.shared.hasPresented {
            self.dismiss(animated: true, completion: {
                
            })
        } else {
            SetupDataManager.shared.hasPresented = true
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            
            // TODO: improve the animation between two view controllers.
            UIView.transition(with: appDelegate!.window!, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                appDelegate?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
            }, completion: nil)
        }
    }

}
