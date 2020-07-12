//作成日・更新日・IDなどをDBに保存する
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//プロパティにtitleとepisodeを持つ
class Sentence: Codable {
    
    //今回はsentence単位で1つのDocumentとし、Idを持たせた
    var sentenceId: String
    var title: String
    var episode: String?
    
    //「Timestamp」はFirebaseのデフォルト機能。取得日時などがわかる
    //サーバーへの書き込み日時処理（後で並び替えの時にも役立つ）
    //createdAtで作成日取得
    var createdAt:Timestamp
    //updatedAtで更新日取得
    var updatedAt:Timestamp
    
    //イニシャライズの使い方
    //let sentence = Sentence(sentence: "プログラミング")
    init(sentenceId:String, title: String, episode: String = "", createdAt:Timestamp, updatedAt:Timestamp) {
        self.sentenceId = sentenceId
        self.title = title
        self.episode = episode
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    
    
}
