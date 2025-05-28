import Foundation
import SwiftData

@Model
final class Script {
    var contentType: ContentType
    var writingMode: WritingMode
    var tone: Tone
    var format: Format
    var mainTheme: String
    var keywords: String
    var summary: String
    var duration: Int
    var createdAt: Date
    var generatedContent: String?
    
    init(
        contentType: ContentType = .video,
        writingMode: WritingMode = .guided,
        tone: Tone = .casual,
        format: Format = .story,
        mainTheme: String = "",
        keywords: String = "",
        summary: String = "",
        duration: Int = 5,
        createdAt: Date = Date(),
        generatedContent: String? = nil
    ) {
        self.contentType = contentType
        self.writingMode = writingMode
        self.tone = tone
        self.format = format
        self.mainTheme = mainTheme
        self.keywords = keywords
        self.summary = summary
        self.duration = duration
        self.createdAt = createdAt
        self.generatedContent = generatedContent
    }
}

enum ContentType: String, Codable {
    case video = "Vídeo"
    case presentation = "Apresentação"
}

enum WritingMode: String, Codable {
    case guided = "Escrita Guiada"
    case ai = "Auto IA"
}

enum Tone: String, Codable {
    case formal = "Formal"
    case casual = "Casual"
    case technical = "Técnico"
    case humorous = "Humorístico"
    case inspirational = "Inspiracional"
}

enum Format: String, Codable {
    case story = "Narrativa"
    case bulletPoints = "Tópicos"
    case dialogue = "Diálogo"
    case tutorial = "Tutorial"
} 