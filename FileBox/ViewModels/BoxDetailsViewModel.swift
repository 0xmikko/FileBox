//
//  BoxDetailsViewModel.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 29.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Foundation

protocol BoxDetailsViewModelDelegate {
    func updateName(_ name: String)
    func updateContent(_ content: String)
    func updateIPFSHash(_ hash: String)
    func updatePrefs(_ newPrefs: [BoxPref])
    func openFileIn(_ url: URL)
}

class BoxDetailsViewModel {
    var delegate: BoxDetailsViewModelDelegate?
    var boxService: BoxService
    var box: Box?

    init() {
        boxService = BoxService()
    }

    func loadDetails(id: String) {
        boxService.getBox(id: id) { box in
            print(box)

            self.delegate?.updateName(box.name)
            self.delegate?.updateContent(box.content)
            self.delegate?.updateIPFSHash(box.ipfsHash ?? "Uploading to IPFS...")

            var newPrefs: [BoxPref] = []

            let date = Date(timeIntervalSince1970: TimeInterval(box.createdAt))

            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd.MM.yyyy"

            newPrefs.append(BoxPref(title: "Created", value: String(dateFormatterGet.string(from: date))))
            newPrefs.append(BoxPref(title: "Opened", value: String(box.opened)))
            newPrefs.append(BoxPref(title: "Downloaded", value: String(box.downloaded)))

            self.delegate?.updatePrefs(newPrefs)
        }
    }

    func downloadFile(id: String) {
        boxService.downloadFromBox(id: id) { url in
            if let url = url {
                self.delegate?.openFileIn(url)
            }
        }
    }
}
