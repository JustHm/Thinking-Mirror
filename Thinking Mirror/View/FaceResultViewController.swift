//
//  FaceResultViewController.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/23.
//

import UIKit

class FaceResultViewController: UIViewController {
    
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var resultView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var image: UIImage?
    // MARK: Networking
    private func requestAPI(image: UIImage) {
        indicator.startAnimating()
        
        APIManager.sharedObject.faceAPI(uploadImage: image, completion: { result in
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.configureLabel(result: result)
        })
    }
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else {
            resultView.image = UIImage(systemName: "x.circle.fill")
            errorAlert(message: "이미지가 없습니다..")
            return
        }
        requestAPI(image: image)
        resultView.image = image
    }
    // MARK: UI
    private func configureLabel(result: Response<FaceData>){
        if result.info.faceCount < 1 {
            errorAlert(message: "얼굴이 검출되지 않았습니다.")
            return
        }
        guard let data = result.faces.first else {
            return
        }
        
        emotionLabel.text = data.emotion.value
        ageLabel.text = data.age.value
        genderLabel.text = data.gender.value
        
        indicator.stopAnimating()
        indicator.isHidden = true
        
        emotionLabel.isHidden = false
        ageLabel.isHidden = false
        genderLabel.isHidden = false
    }
    
    private func errorAlert(message: String) { //Exception 설명 Alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
