//
//  MailComposerViewController.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 21/09/2022.
//

import MessageUI

class MailComposerViewController: MFMailComposeViewController {
    init(recepients: [String], subject: String = "", message: String = "", isHTML: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        setToRecipients(recepients)
        setSubject(subject)
        setMessageBody(message, isHTML: isHTML)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not benn implemented")
    }
}
