//
//  MemojiView.swift
//  MemojiView
//
//  Created by SomnicsAndrew on 2023/10/13.
//
import UIKit

class MemojiView: UIImageView {
    private let memojiView = UIImageView(frame: .zero)
    private let textView = UITextView()
    private let size: Int = 300
    private let minimumTextViewSize = Double(50)
    var imageChanged: ((UIImage) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func resizeView(size: Double) {
        guard size >= 50 else {
            return
        }
        self.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        memojiView.frame = CGRect(origin: .zero, size: CGSize(width: size, height: size))
        textView.frame = CGRect(x: size - minimumTextViewSize,
                                y: size - minimumTextViewSize,
                                width: minimumTextViewSize,
                                height: minimumTextViewSize)
    }
    
    private func setupUI() {
        self.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        memojiView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        memojiView.backgroundColor = .yellow
        self.addSubview(memojiView)
        
        textView.frame = CGRect(x: size - 50, y: size - 50, width: 50, height: 50)
        textView.allowsEditingTextAttributes = true
        textView.delegate = self
        textView.tintColor = .clear
        textView.backgroundColor = .clear
        self.addSubview(textView)
    }
    
    private func getTextAttachments(from textView: UITextView) -> [NSTextAttachment] {
        var attachments: [NSTextAttachment] = []
        
        let attributedText = textView.attributedText
        attributedText?.enumerateAttribute(
            NSAttributedString.Key.attachment,
            in: NSRange(location: 0, length: attributedText?.length ?? 0),
            options: [])
        { (value, range, stop) in
            if let attachment = value as? NSTextAttachment {
                attachments.append(attachment)
            }
        }
        return attachments
    }
}

extension MemojiView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let attachments = getTextAttachments(from: textView)
        for attachment in attachments {
            if let image = attachment.image {
                // Do something with the image
                print("got image!!")
                imageChanged?(image)
                DispatchQueue.main.async {
                    self.memojiView.image = image
                }
            }
        }
        DispatchQueue.main.async {
            textView.text = ""
        }
    }
}
