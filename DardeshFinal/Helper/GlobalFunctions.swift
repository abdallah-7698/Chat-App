//
//  GlobalFunctions.swift
//  DardeshFinal
//
//  Created by MacOS on 02/02/2022.
//

import Foundation
import UIKit
import AVFoundation

func fileNameFrom (fileURL : String)->String{
    let name = fileURL.components(separatedBy: "_").last
    let name1 = name?.components(separatedBy: "?").first
    let name2 = name1?.components(separatedBy: ".").first
    return name2!
}

func videoThumbnail(videoURL: URL) -> UIImage {
    do {
        let asset = AVURLAsset(url: videoURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return UIImage(named: "photoPlaceholder")!
    }
}
