

import Foundation

class QnAThread : Codable {
    let chat : [ChatModel]?
    var upVotes : [String]?
    var downVotes : [String]?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case chat = "chat"
        case upVotes = "up_votes"
        case downVotes = "down_votes"
        case id = "_id"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chat = try values.decodeIfPresent([ChatModel].self, forKey: .chat)
        upVotes = try values.decodeIfPresent([String].self, forKey: .upVotes)
        downVotes = try values.decodeIfPresent([String].self, forKey: .downVotes)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}

class ChatModel : Codable {
    var sender : Sender?
    var message : String?
    var from : String?
    var sentTime : String?
    var id : String?
    
    enum CodingKeys: String, CodingKey {

        case sender = "sender"
        case message = "message"
        case from = "from"
        case sentTime = "sent_time"
        case id = "_id"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sender = try values.decodeIfPresent(Sender.self, forKey: .sender)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        sentTime = try values.decodeIfPresent(String.self, forKey: .sentTime)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }

}

class Sender : Codable {
    var id : String?
    var name : String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
