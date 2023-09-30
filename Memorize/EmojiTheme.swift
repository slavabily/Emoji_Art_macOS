//
//  EmojiTheme.swift
//  Memorize
//
//  Created by slava bily on 23.08.2023.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let memorize = UTType(exportedAs: "com.slavabily-me.com.Memorize")
}

class EmojiTheme: ReferenceFileDocument {
    
    static var readableContentTypes: [UTType] {
        [.memorize]
    }
    
    func snapshot(contentType: UTType) throws -> Data {
        try JSONEncoder().encode(themes)
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
         FileWrapper(regularFileWithContents: snapshot)
    }
    
    typealias Themes = [Theme]
     
    required init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            themes = try JSONDecoder().decode(Themes.self, from: data)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
     
    @Published var themes = [Theme]() {
        didSet {
 
        }
    }
    
    init() {
        if themes.isEmpty {
            insertTheme(named: "Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶", color: .red)
            insertTheme(named: "Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎", color: .green)
            insertTheme(named: "Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪", color: .blue)
            insertTheme(named: "Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧", color: .yellow)
        }
    }
    
    func insertTheme(named name: String, emojis: String? = nil, color: Theme.ThemeColor, at index: Int = 0) {
        let unique = (themes.max(by: { $0.id < $1.id })?.id ?? 0) + 1
        let theme = Theme(name: name, emojis: emojis ?? "", color: color, id: unique)
        let safeIndex = min(max(index, 0), themes.count)
        themes.insert(theme, at: safeIndex)
    }
    
    // MARK: - Undo
    
    private func undoablyPerform(_ action: String, with undoManager: UndoManager? = nil, doit: () -> Void) {
        let oldEmojiThemes = themes
        doit()
        undoManager?.registerUndo(withTarget: self, handler: { myself in
            myself.undoablyPerform(action, with: undoManager) {
                myself.themes = oldEmojiThemes
            }
        })
        undoManager?.setActionName(action)
    }
    
    // MARK: - Intent(s)
    
    func deleteTheme(at indexSet: IndexSet, undoWith undoManager: UndoManager? = nil) {
        undoablyPerform("Remove theme", with: undoManager) {
            themes.remove(atOffsets: indexSet)
        }
    }
    
    func moveTheme(from indexSet: IndexSet, to newOffset: Int, undoWith undoManager: UndoManager? = nil) {
        undoablyPerform("Move theme", with: undoManager) {
            themes.move(fromOffsets: indexSet, toOffset: newOffset)
        }
    }
    
    func addNewTheme(undoWith undoManager: UndoManager? = nil) {
        undoablyPerform("Add new theme", with: undoManager) {
            insertTheme(named: "New", emojis: "😀😁😅🥲😇😉🥰", color: .blue, at: 0)
        }
    }
}
