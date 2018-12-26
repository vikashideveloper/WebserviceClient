//
//  Download.swift
//  VideoApp
//
//  Created by Vikash on 12/11/18.
//  Copyright © 2018 Vikash. All rights reserved.

// Download task using URLSession. Without using any third party like Alamofire.

import Foundation


class Download: NSObject {
    var downloadTask: URLSessionDownloadTask?
    
    typealias ProgressBlock = ((Float) -> Void)
    typealias DownloadFinishBlock = ((URL?) -> Void)
    
    var progressBlock: ProgressBlock?
    var downloadFinishBlock: DownloadFinishBlock?
    
    var url: URL?
    
    func startFrom(url: URL, progress: @escaping ProgressBlock, completion: @escaping DownloadFinishBlock) {
        
        self.url = url
        
        let downloadRequest = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        
        downloadTask = session.downloadTask(with: downloadRequest)
        downloadTask?.resume()
        self.progressBlock = progress
        self.downloadFinishBlock = completion
    }
    
    func cancel() {
        downloadTask?.cancel()
    }
}


extension Download: URLSessionDownloadDelegate {
   
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let fileName = url?.lastPathComponent ?? "tempfile"
        let savePath = DocumentDirectoryPath() + "/\(fileName)"
        try? FileManager.default.moveItem(atPath: location.path, toPath: savePath)
        self.downloadFinishBlock?(URL(fileURLWithPath: savePath))
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        progressBlock?(progress)
    }
}


func DocumentDirectoryPath() -> String {
   let docuementDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
    return docuementDirectoryPath
}
