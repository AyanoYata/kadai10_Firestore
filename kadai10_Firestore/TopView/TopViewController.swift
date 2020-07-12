import UIKit

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    func presentLoginViewController(){
            //2秒後にLoginViewControllerへと画面遷移
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
           let vc = LoginViewController()
            self.navigationController?.pushViewController(vc, animated: true)
      }
    }
    
    
    
    
}
