//
//  ViewController.swift
//  MemojiView
//
//  Created by SomnicsAndrew on 2023/10/13.
//

import UIKit

class ViewController: UIViewController {
    private let memojiView = MemojiView(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 300)))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        memojiView.backgroundColor = .yellow
        self.view.addSubview(memojiView)
        memojiView.imageChanged = { image in
            print("got it")
            self.startResizeImageViewAnimation(imageView: self.memojiView)
        }
    }

    private func startResizeImageViewAnimation(imageView: UIImageView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3.0,
                           delay: 0.0,
                           options: [.curveLinear, .repeat, .autoreverse],
                           animations: { () -> Void in
                self.memojiView.resizeView(size: 50)
            }, completion: { (finished: Bool) -> Void in
                
            })
        }
    }
}
