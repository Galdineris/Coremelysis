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
            if let permanentURL = persistFile(fileURL: localURL) {
                handler(.success(permanentURL))
            } else {
                handler(.failure(URLError(.cannotWriteToFile)))
            }
        }
        task.resume()
    }

    static func persistFile(fileURL: URL) -> URL? {
        let fileManager = FileManager.default
        guard
            let appSupportURL = fileManager.urls(for: .applicationSupportDirectory,
                                                 in: .userDomainMask).first
        else {
            return nil
        }
        let compiledModelName = fileURL.lastPathComponent
        let permanentURL = appSupportURL.appendingPathComponent(compiledModelName)
        return try? fileManager.replaceItemAt(permanentURL,
                                          withItemAt: fileURL)
    }

}
