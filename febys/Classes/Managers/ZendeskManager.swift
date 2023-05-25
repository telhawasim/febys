//
//  ZendeskManager.swift
//  febys
//
//  Created by Faisal Shahzad on 23/05/2022.
//

import Foundation
import UIKit

import ZendeskCoreSDK
import SupportProvidersSDK
import SDKConfigurations
import SupportSDK


// Theme
import CommonUISDK

// ViewController and engines
import MessagingSDK
import MessagingAPI

// Chat Engine, API and models
import ChatSDK
import ChatProvidersSDK

// Answer Engine, API and models
import AnswerBotSDK
import AnswerBotProvidersSDK


class ZendeskManager: NSObject, JWTAuthenticator {
    static var shared = ZendeskManager()
    
    static var themeColor: UIColor? {
        didSet {
            guard let themeColor = themeColor else { return }
            CommonTheme.currentTheme.primaryColor = themeColor
        }
    }
    
    let accountKey = ConfigurationManager.shared.infoForKey(.zendeskAccountKey) ?? ""
    let appId = ConfigurationManager.shared.infoForKey(.zendeskAppId) ?? ""
    let clientKey = ConfigurationManager.shared.infoForKey(.zendeskClientKey) ?? ""
    let zendeskUrl = ConfigurationManager.shared.infoForKey(.zendeskUrl) ?? ""
    
    var authToken: String = "" {
        didSet {
            guard !authToken.isEmpty else {
                resetVisitorIdentity()
                return
            }
            Chat.instance?.setIdentity(authenticator: self)
        }
    }
    
    // MARK: Configurations
    var messagingConfiguration: MessagingConfiguration {
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "Alicia"
        messagingConfiguration.isMultilineResponseOptionsEnabled = true
        return messagingConfiguration
    }
    
    var chatConfiguration: ChatConfiguration {
        let formConfiguration = ChatFormConfiguration(name: .optional, email: .optional, phoneNumber: .hidden, department: .hidden)
        
        let chatConfiguration = ChatConfiguration()
        chatConfiguration.preChatFormConfiguration = formConfiguration
        chatConfiguration.chatMenuActions = [.emailTranscript, .endChat]
        chatConfiguration.isAgentAvailabilityEnabled = false
        return chatConfiguration
    }
    
    var chatAPIConfig: ChatAPIConfiguration {
        let chatAPIConfig = ChatAPIConfiguration()
        chatAPIConfig.tags = ["iOS"]
        return chatAPIConfig
    }
    
    // MARK: Chat
    func initialize() {
        ZendeskManager.themeColor = .febysRed()
        setChatLogging()
        Zendesk.initialize(appId: appId, clientId: clientKey, zendeskUrl: zendeskUrl)
        createIdentity()
        Chat.initialize(accountKey: accountKey)
        Support.initialize(withZendesk: Zendesk.instance)
        AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
        
//        CommonTheme.currentTheme.primaryColor = themeColor

//        let navBarAppearance = UINavigationBar.appearance()
//        navBarAppearance.barTintColor = .febysRed()
//        navBarAppearance.tintColor = .white
//        navBarAppearance.titleTextAttributes = [
//                NSAttributedString.Key.foregroundColor: UIColor.white,
//                NSAttributedString.Key.font: UIFont(name: "Avenir", size: 30)!]
        
    }
    
    func setChatLogging() {
        CoreLogger.enabled = true
        CoreLogger.logLevel = .debug
    }
    
    func resetVisitorIdentity() {
        Chat.instance?.resetIdentity(nil)
    }
    
    func getToken(_ completion: @escaping (String?, Error?) -> Void) {
        completion(authToken, nil)
    }
    
    // MARK: View Controller
    func buildMessagingViewController() throws -> UIViewController {
        Chat.instance?.configuration = chatAPIConfig
        return try Messaging.instance.buildUI(engines: self.engines, configs: [messagingConfiguration, chatConfiguration])
    }
//    CommonTheme.currentTheme.primaryColor = .orange

    
    func createIdentity() {
        if let userInfo = UserInfo.fetch(),
           let consumerInfo = userInfo.consumerInfo {
            let fullName = "\(consumerInfo.first_name!) \(consumerInfo.last_name!)"
            let email = consumerInfo.email!
            let identity = Identity.createAnonymous(name: fullName, email: email)
            Zendesk.instance?.setIdentity(identity)
        } else {
            let identity = Identity.createAnonymous()
            Zendesk.instance?.setIdentity(identity)
        }
    }
    
    func startConversation(_ viewController: UIViewController) {
        do {
            let controller = try ZendeskManager.shared.buildMessagingViewController()
            controller.navigationController?.navigationBar.isHidden = true
            controller.modalPresentationStyle = .fullScreen
            viewController.present(controller, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
}


// MARK: Engines
extension ZendeskManager {

    var engines: [Engine] {
        let engineTypes:[Engine.Type] = [AnswerBotEngine.self, SupportEngine.self, ChatEngine.self]
        return engines(from: engineTypes)
    }

    func engines(from engineTypes: [Engine.Type]) -> [Engine] {
        engineTypes.compactMap { type -> Engine? in
            switch type {
            case is ChatEngine.Type:
                return try? ChatEngine.engine()
            case is SupportEngine.Type:
                return try? SupportEngine.engine()
            case is AnswerBotEngine.Type:
                return try? AnswerBotEngine.engine()
            default:
                fatalError("Unhandled engine of type: \(type)")
            }
        }
    }
}
