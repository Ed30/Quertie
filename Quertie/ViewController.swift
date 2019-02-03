//
//  ViewController.swift
//  Quertie
//
//  Created by Edward Theodor on 02/02/2019.
//  Copyright © 2019 Edward Theodor. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import AVFoundation

class ViewController: MessagesViewController  {

    
    
    var messages : [Message] = []
    var member : Member!
    

    @IBOutlet weak var blurrinessSlider: UISlider!
    
    var chatService : ChatService!
    var captureSession : AVCaptureSession?
    var blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
    var blurEffectView : UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: Selector(("refreshGUI:")), name:NSNotification.Name(rawValue: "refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshGUI) , name: NSNotification.Name("refresh"), object: nil)
        setupChatView()
        refreshGUI(nil)
        
        }
    
    
    
    
    //Private functions
    @objc private func refreshGUI(_ notification: NSNotification?) {
        
        let darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        blurEffect = UIBlurEffect(style: darkMode ? UIBlurEffect.Style.dark : UIBlurEffect.Style.regular)
        setupCameraView()
        
        if let controller = self.navigationController {
            let navBar = controller.navigationBar
            
            if darkMode {
                navBar.barStyle = .blackTranslucent
                navBar.tintColor = .orange
            } else {
                navBar.barStyle = .default
                navBar.tintColor = UIColor(red: 0, green: 122/255, blue: 1.0, alpha: 1.0)
            }
            
        }
        
    }
    
    private func setupChatView() {
        
        member = Member(name: .randomName, color: .random)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.backgroundColor = .clear
        
        chatService = ChatService(member: member, onReceivedMessage: {
            [weak self] message in
            self?.messages.append(message)
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToBottom(animated: true)
        })
        
        chatService.connect()
        
    }
    
    
    
    private func setupCameraView() {
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        let cameraView  = CameraView(frame: self.view.frame)
        cameraView.addSubview(blurEffectView)
        self.view.addSubview(cameraView)
        
        self.view.bringSubviewToFront(messagesCollectionView)
    }


    

    //Outlet functions
    @IBAction func changeBlurriness(_ sender: Any) {
        blurEffectView.alpha = CGFloat(blurrinessSlider.value)
    }
    
}






extension ViewController : MessagesDataSource {
    
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 12
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
    
}

extension ViewController : MessagesLayoutDelegate {
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
}


extension ViewController : MessagesDisplayDelegate {
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
        
        
    }
}

extension ViewController : MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        chatService.sendMessage(text)
        inputBar.inputTextView.text = ""
        
//        let newMessage = Message(
//            member: member,
//            text: text,
//            messageId: UUID().uuidString)
//
//        messages.append(newMessage)
//        inputBar.inputTextView.text = ""
//        messagesCollectionView.reloadData()
//        messagesCollectionView.scrollToBottom(animated: true)
    }
}
