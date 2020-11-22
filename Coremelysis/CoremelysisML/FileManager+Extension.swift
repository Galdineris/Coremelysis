//
//  Networking.swift
//  CoremelysisML
//
//  Created by Rafael Galdino on 08/11/20.
//  Copyright © 2020 Rafael Galdino. All rights reserved.
//

import Foundation

extension FileManager {
    static func downloadFile(from url: URL, completionHandler handler: @escaping (Result<URL, Error>) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (localURL, _, error) in
            guard let localURL = localURL else {
                if let error = error {
                    handler(.failure(error))
                }
                return
            }
            handler(.success(localURL))

        }
        task.resume()
    }

    static func persistFile(fileURL: URL) -> String? {
        let fileManager = FileManager.default
        guard
            let appSupportURL = fileManager.urls(for: .applicationSupportDirectory,
                                                 in: .userDomainMask).first
        else {
            return nil
        }
        let compiledModelName = fileURL.lastPathComponent
        let permanentURL = appSupportURL.appendingPathComponent(compiledModelName)
        do {
            try fileManager.moveItem(at: fileURL, to: permanentURL)
            return compiledModelName
        } catch {
            return nil
        }
    }

    static func appSupportFileURL(for fileNamed: String) -> URL? {
        let fileManager = FileManager.default
        guard let appSupportDirectory = try? fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else { return nil }
        let permanentURL = appSupportDirectory.appendingPathComponent(fileNamed)
        return permanentURL
    }
}
