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
    private let button = UIButton()
    private let editImageView = UIImageView()
    private let size = Double(300)
    private let minimumTextViewSize = Double(50)
    private let editIconSize = Double(50)
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
        editImageView.frame = CGRect(x: size - editIconSize,
                                y: size - editIconSize,
                                width: editIconSize,
                                height: editIconSize)
    }
    
    private func setupUI() {
        self.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
        memojiView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        memojiView.backgroundColor = .yellow
        self.addSubview(memojiView)
        
        textView.frame = CGRect(x: size - minimumTextViewSize,
                                y: size - minimumTextViewSize,
                                width: minimumTextViewSize,
                                height: minimumTextViewSize)
        textView.allowsEditingTextAttributes = true
        textView.delegate = self
        textView.tintColor = .clear
        textView.backgroundColor = .clear
        self.addSubview(textView)
        
        let edgeInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        editImageView.image = UIImage(systemName: "pencil")?.withInset(edgeInset)
        editImageView.contentMode = .scaleAspectFit
        editImageView.frame = CGRect(x: size - editIconSize, 
                                     y: size - editIconSize,
                                     width: editIconSize,
                                     height: editIconSize)
        editImageView.backgroundColor = .systemPink
        editImageView.layer.cornerRadius = 25
        self.addSubview(editImageView)
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

    private func bounceImageView(view: UIImageView) {
        // Initial scale down to simulate a 'drop' from original size
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        // Animate to slightly larger than original size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6.0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { finished in
            // Animate back to original size
            UIView.animate(withDuration: 0.3) {
                view.transform = CGAffineTransform.identity
            }
        })
    }
}

extension MemojiView: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        bounceImageView(view: self.editImageView)
        return true
    }

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

// Ref: https://stackoverflow.com/questions/32304349/insets-to-uiimageview
extension UIImage {
    func withInset(_ insets: UIEdgeInsets) -> UIImage? {
        let cgSize = CGSize(width: self.size.width + insets.left * self.scale + insets.right * self.scale,
                            height: self.size.height + insets.top * self.scale + insets.bottom * self.scale)
        UIGraphicsBeginImageContextWithOptions(cgSize, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        let origin = CGPoint(x: insets.left * self.scale, y: insets.top * self.scale)
        self.draw(at: origin)
        return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
    }
}
