//
//  MemorizeApp.swift
//  Memorize
//
//  Created by slava bily on 16.07.2022.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    var body: some Scene {
        DocumentGroup(newDocument: { EmojiTheme() }) { config in
            if UIDevice.current.userInterfaceIdiom == .pad {
                Text("Emoji Memory Game")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.red)
            }
            ThemeChooserView(emojiTheme: config.document)
        }
    }
}
