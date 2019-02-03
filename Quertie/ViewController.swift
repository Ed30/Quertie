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
        // Do any additional setup after loading the view, typically from a nib.
        
        member = Member(name: .randomName, color: .random)
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        chatService = ChatService(member: member, onReceivedMessage: {
            [weak self] message in
            self?.messages.append(message)
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToBottom(animated: true)
        })
        
        chatService.connect()
        
        
        
        //view.backgroundColor = .red
        messagesCollectionView.backgroundColor = .clear
        
        if let darkMode = isDarkModeOn {
            blurEffect = UIBlurEffect(style: darkMode ? UIBlurEffect.Style.dark : UIBlurEffect.Style.regular)
        }
        
        
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        //self.view.addSubview(blurEffectView.contentView)
        
        
//        let image = UIImage(named: "wallpaper")
//        let imgView = UIImageView(image: image)
//        imgView.center.x = self.view.frame.midX
//        imgView.center.y = self.view.frame.midY
        //imgView.addSubview(blurEffectView)
        //self.view.addSubview(imgView)
        
    
        
        let cameraView  = CameraView(frame: self.view.frame)
        cameraView.addSubview(blurEffectView)
        self.view.addSubview(cameraView)
       
        self.view.bringSubviewToFront(messagesCollectionView)

        
        }


    

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
