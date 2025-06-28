//
//  FileManager.swift
//  Financial Statements Go
//
//  Created by Banghua Zhao on 6/25/20.
//  Copyright © 2020 Banghua Zhao. All rights reserved.
//

import UIKit

let myFileManager = FileManager.default

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func getCacheDirectory() -> URL {
    let paths = myFileManager.urls(for: .cachesDirectory, in: .userDomainMask)
    let cachesDirectory = paths[0]
    return cachesDirectory
}

func getCacheDirectorySize() -> String {
    let cachePathURL = myFileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    // check if the url is a directory
    if (try? cachePathURL.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true {
        var folderSize = 0
        folderSize += sizeOfFolder(getCacheFolderPath().path)
        folderSize += sizeOfFolder(getCompanyLogoCachePath().path)
        let byteCountFormatter = ByteCountFormatter()
        switch folderSize {
        case 0 ..< 1024:
            byteCountFormatter.allowedUnits = .useBytes
        case 1024 ..< 1024 * 1024:
            byteCountFormatter.allowedUnits = .useKB
        case 1024 * 1024 ..< 1024 * 1024 * 1024:
            byteCountFormatter.allowedUnits = .useMB
        default:
            byteCountFormatter.allowedUnits = .useGB
        }

        byteCountFormatter.countStyle = .file
        let sizeToDisplay = byteCountFormatter.string(for: folderSize) ?? ""
        return sizeToDisplay
    }
    return "0"
}

func sizeOfFolder(_ folderPath: String) -> Int {
    do {
        let contents = try myFileManager.contentsOfDirectory(atPath: folderPath)
        var folderSize: Int = 0
        for content in contents {
            do {
                let fullContentPath = folderPath + "/" + content
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: fullContentPath)
                folderSize += fileAttributes[FileAttributeKey.size] as? Int ?? 0
            } catch _ {
                continue
            }
        }
        return folderSize
    } catch let error {
        print(error.localizedDescription)
        return 0
    }
}

func clearCacheOfLocal() {
    do {
        try FileManager.default.removeItem(at: getCacheFolderPath())
        try FileManager.default.removeItem(at: getCompanyLogoCachePath())
    } catch let error {
        print(error)
    }
}

// MARK: - getCacheFolderPath

func getCacheFolderPath() -> URL {
    let cachePath = getCacheDirectory().appendingPathComponent("com.Cache.default")

    if !myFileManager.fileExists(atPath: cachePath.path) {
        do {
            try myFileManager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
        }
    }
    return cachePath
}

// MARK: company logo related

func getCompanyLogoCachePath() -> URL {
    let cachePath = getCacheDirectory().appendingPathComponent("com.onevcat.Kingfisher.ImageCache.default")

    if !myFileManager.fileExists(atPath: cachePath.path) {
        do {
            try myFileManager.createDirectory(at: cachePath, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error)
        }
    }
    return cachePath
}
