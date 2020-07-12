import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    
    //sentence情報の一覧。
    var sentences: [Sentence] = []
    
    override func viewDidLoad() {
        
        if self.isLogin() == true{
                   //ログイン状態のときはスキップ
                   //ログインユーザーIDとログインユーザーのemailも取得できる
                   print("\(String(describing: Auth.auth().currentUser?.uid)):ログインユーザーのユーザーID")
                   print("\(String(describing: Auth.auth().currentUser?.email)):ログインユーザーのemail")
               } else {
                   //まだログインしていないときはログイン画面表示
                   self.presentLoginViewController()
               }
        //tableView使う時のお約束
        tableView.delegate = self
        tableView.dataSource = self
        
        //"CutomeCellの登録
        let nib = UINib(UINibName: "CutomeCell", bundle: nil)
        //tableViewに使うXibファイルの登録
        tableView.register(nib, forCellReuseIdentifier: "CutomeCell")
        setupNavigationBar()
        
    }
    
    // 画面描画のたびにtableViewを更新
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppearが呼ばれた")
        //配列を空にする
        self.sentences.removeAll()
        self.readSentencesFromFirestore()
        // UserDefaultsから読み出し
        //tasks = UserDefaultsRepository.loadFromUserDefaults()
        dump(sentences)
        //reloadTableView()
    }
    
    //Firestoreから読み込み
    func readSentencesFromFirestore(){
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
                        self.sentences.append(decodedTask)
                    } catch let error as NSError{
                        print("エラー:\(error)")
                    }
                }
                // for文を全て回し終えたらリロード
                self.reloadTableView()
            }
        }
    }
    
  //ログイン認証されているかどうかを判定する関数
  func isLogin() -> Bool{
      //ログインしているユーザーがいるかどうかを判定
      if Auth.auth().currentUser != nil {
          return true
      } else {
          return false
      }
  }
  
  func presentLoginViewController(){
      let loginVC = LoginViewController()
      loginVC.modalPresentationStyle = .fullScreen
      self.present(loginVC, animated: false, completion: nil)
  }

    
    
    
    
   // navigation barの設定
    private func setupNavigationBar() {
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddScreen))
        navigationItem.rightBarButtonItem = rightButtonItem
        //画面上部のナビゲーションバーの左側にログアウトボタンを設置し、押されたらlogOut関数が走るように設定
        let leftButtonItem = UIBarButtonItem(title: "ログアウト", style: .done, target: self, action: #selector(logOut))
        navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    //ログアウト処理
    @objc func logOut(){
        do{
        try Auth.auth().signOut()
            //ログアウトに成功したら、ログイン画面を表示
            self.presentLoginViewController()
        } catch let signOutError as NSError{
            print("サインアウトエラー:\(signOutError)")
        }
    }

    // navigation barのaddボタンをタップされたときの動作
    @objc func showAddScreen() {
        let vc = AddViewController()
        vc.sentences = sentences
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // 登録したセルを使う。 as! CustomCell としないと、UITableViewCell のままでしか使えない。
           let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
           if sentences.isEmpty == false{
               //taskの要素が存在するときにのみ下記コードが呼ばれる
           cell.titleLabel?.text = tasks[indexPath.row].title
           }
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TaskDetailViewController()
        vc.selectIndex = indexPath.row
        vc.tasks = tasks
        navigationController?.pushViewController(vc, animated: true)
    }
    
    #warning("ここにスワイプして削除する時の処理を入れる")
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Firestoreからの削除処理
        self.deleteTaskFromFirestore(indexPath)
        
        //Firestoreから削除した後に、配列からも削除する
        tasks.remove(at: indexPath.row)
        //UserDefaultsRepository.saveToUserDefaults(tasks)
        reloadTableView()
    }
    
    //Firestoreからの削除処理
    func deleteTaskFromFirestore(_ indexPath:IndexPath){
        let taskId = tasks[indexPath.row].taskId
        db.collection("Tasks").document(taskId).delete()
    }

    func reloadTableView() {
        tableView.reloadData()
    }
    
    
    
    
    
}
 
