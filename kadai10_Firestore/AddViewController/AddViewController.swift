import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift


class AddViewController: UIViewController {
    
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var episodeTextField: UITextView!
    
    // TaskListViewControllerからコピーしたtasks
    var sentences: [Sentence] = []
    
    // FirestoreのDBのインスタンスを作成
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupepisodeTextView()
        setupNavigationBar()
    }
    
    //Firestoreに保存する関数
    func createTsakToFirestore(_ title:String){
        
        let sentnenceId = db.collection("Sentnence").document().documentID
        let sentnence = Sentnence(sentnenceId: sentnenceId, title: title, episode: episodeTextView.text, createdAt:Timestamp(), updatedAt: Timestamp())
        
        do{
            let encodedTask:[String:Any] = try Firestore.Encoder().encode(task)
            db.collection("Tasks").document(taskId).setData(encodedTask)
            tasks.append(task)
        } catch let error as NSError {
            print("エラー\(error)")
        }
        
    }
    
    
    
    // MARK: - UISetup
    /*private func setupMemoTextView() {
        memoTextView.layer.borderWidth = 1
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
        memoTextView.layer.cornerRadius = 3
    }
    
    private func setupNavigationBar() {
        title = "Add"
        let rightButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSaveButton))
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    
    // MARK: - Other Method
    @objc func tapSaveButton() {
        print("Saveボタンを押したよ！")
        
        guard let title = titleTextField.text else {
            return
        }

        // titleが空白のときのエラー処理
        if title.isEmpty {
            print(title, "👿titleが空っぽだぞ〜")
            HUD.flash(.labeledError(title: nil, subtitle: "👿 タイトルが入力されていません！！！"), delay: 1)
            // showAlert("👿 タイトルが入力されていません！！！")
            return // return を実行すると、このメソッドの処理がここで終了する。
        }

        
        self.createTsakToFirestore(title)
        HUD.flash(.success, delay: 0.3)
        navigationController?.popViewController(animated: true)
        // tasksにAddする処理（userごとにデータ登録を分ける時は、userIdで処理する）
        let task = Task(taskId: "String", title: title, memo: memoTextView.text, createdAt: Timestamp(), updatedAt: Timestamp())
        tasks.append(task)
        //UserDefaultsRepository.saveToUserDefaults(tasks)

        HUD.flash(.success, delay: 0.3)
        // 前の画面に戻る
        navigationController?.popViewController(animated: true)
    }

    #warning("アラートを表示するメソッド")
    // アラートを表示するメソッド
    func showAlert(_ text: String){
        let alertController = UIAlertController(title: "エラー", message: text , preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }*/
    
}

