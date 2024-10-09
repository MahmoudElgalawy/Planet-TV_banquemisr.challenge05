//
//  MoviesVideoModel.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 07/10/2024.
//

import Foundation

struct MovieVideosResponse: Decodable {
    let results: [MovieVideo]
}

struct MovieVideo: Decodable {
    let id: String          // معرّف الفيديو
    let key: String         // معرّف الفيديو على YouTube أو Vimeo
    let name: String        // اسم الفيديو
    let site: String        // موقع الفيديو مثل YouTube أو Vimeo
    let type: String        // نوع الفيديو (Trailer, Teaser, إلخ)
    let size: Int           // حجم الفيديو (مثل 720 أو 1080)
    let official: Bool      // إذا كان الفيديو رسمي أم لا
    let publishedAt: String // تاريخ نشر الفيديو
    
    // خاصية لتحويل تاريخ النشر إلى Date إذا لزم الأمر
    var publishedDate: Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: publishedAt)
    }
}
