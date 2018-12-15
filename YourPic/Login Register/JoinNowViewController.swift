
import Foundation
import UIKit

class JoinNowViewController: UIViewController {
    
     @IBOutlet var btnJoinNow :UIButton?
    // MARK: - UIViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let  btnJoinHeight = (btnJoinNow?.frame.height)
        {
            btnJoinNow?.layer.cornerRadius = btnJoinHeight/2
            btnJoinNow?.layer.borderWidth = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

