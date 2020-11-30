//
//  URLDetailsViewController.swift
//  ImageLoadingProject
//
//  Created by Teacher on 16.11.2020.
//

import UIKit
import WebKit

class URLDetailsViewController: UIViewController, URLSessionDownloadDelegate {
    var pageUrl: URL?
    private var largeImage: UIImage?
    
    @IBOutlet private var scrollView: UIView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true
        loadURL()
       
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let data = try! Data(contentsOf: location)
        DispatchQueue.main.sync {
        largeImage = UIImage(data: data)
        let imageView = UIImageView(image: largeImage)
            imageView.frame = CGRect(x: 0, y: 0, width: scrollView.bounds.width, height: (scrollView.bounds.width * largeImage!.size.height / largeImage!.size.width))
        scrollView.addSubview(imageView)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.sync {
            progressView.isHidden = false
            progressView.progress = Float(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
            if totalBytesWritten == totalBytesExpectedToWrite{
                progressView.isHidden = true
            }
        }
    }
    
   

    

    private func loadURL() {
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        guard self.pageUrl != nil else { return }
        let dataTask2 = urlSession.downloadTask(with: self.pageUrl!)
        dataTask2.resume()
    }

}
