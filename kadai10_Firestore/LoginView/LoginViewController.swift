import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passworedTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    ////新規ボタン
    @IBAction func tapSignUpButton(_ sender: Any) {
        // emailSignUp は nil の可能性があるため、guard letでアンラップする
            guard let email = emailTextField.text, let password = passworedTextField.text else { return }
            //　新規登録処理
            self.emailSignUp(email: email, password: password)
            print("登録成功！")
        }
        
    
    @IBAction func tapLoginButton(_ sender: Any) {
        //ログインボタン
        guard let email = emailTextField.text, let password = passworedTextField.text else { return }
            //　新規登録処理
            self.emailLogin(email: email, password: password)
        }

        //新規登録の処理
        func emailSignUp(email: String, password: String){
            Auth.auth().createUser(withEmail: email, password: password){ (result,error) in
                if (error as NSError?) != nil{
                    
                } else {
                    self.presentViewController()
                }
            }
        }
        
        //ログインの処理
        func emailLogin(email: String, password: String){
            Auth.auth().signIn(withEmail: email, password: password){ (result,error) in
                if (error as NSError?) != nil{
                    
                } else {
                    self.presentViewController()
                }
            }
            
        }
        //成功した時の画面遷移処理
        func presentViewController(){
            self.dismiss(animated: true, completion: nil)
        }
    
    // 画面描画のたびにtableViewを更新
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           print("viewWillAppearが呼ばれた")
           //配列を空にする
           self.sentence.removeAll()
           self.readSentencesFromFirestore()
           // UserDefaultsから読み出し
           //tasks = UserDefaultsRepository.loadFromUserDefaults()
           dump(sentence)
       }
    
    
    
    
       //Firestoreから読み込み
          func readTasksFromFirestore(){
              //作成日時の降順に並べ替えて取得する
              db.collection("Sentences").order(by: "createdAt", descending: true).getDocuments { (querySnapShot, err) in
                  if let err = err{
                      //エラー時
                      print("エラー\(err)")
                  } else {
                      //データ取得に成功
                      //取得したDocument群の1つ1つのDocumentについて処理をする
                      for document in querySnapShot!.documents{
                          //各DocumentからはDocumentIDとその中身のdataを取得できる
                          print("\(document.documentID) => \(document.data())")
                          //型をTask型に変換
                          do {
                              let decodedTask = try Firestore.Decoder().decode(Sentence.self, from: document.data())
                              //変換に成功
                              self.tasks.append(decodedTask)
                          } catch let error as NSError{
                              print("エラー:\(error)")
                          }
                      }
                      // for文を全て回し終えたらリロード
                      self.reloadTableView()
                  }
              }
          }
    
    
    
    
    
    
    
    }


    
    
    
    
    
    
    
    
    
    
    
    
    
    //　↓ FBログインにトライするが失敗 ↓
    /*@IBAction func fbAction(_ sender: Any) {
        let loginManeger = LoginManager
        loginManeger.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
        if let error = error {
            print("ログインできてないよ")
            return
        }
        
            guard let accessToken = AccessToken.current else{
                print("アクセストークン取得できてないよ")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential, conmpletion: { (user, error) in
                if let error = error {
                    print("ログインエラー")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizeDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(OKAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }else{
                    self.currentUserName()
                }
            })
        }
    }
    
    func currentUserName() {
        if let currentUser = Auth.auth() .currentUser {
            self.btn_sign_out.isHidden = false
            lb_login_Status.text = "YOU ARE LOGIN AS - " + (currentUser.displayName ?? "DISPLAY NAME FOUND")
        }
    }*/
    
    
    
    

