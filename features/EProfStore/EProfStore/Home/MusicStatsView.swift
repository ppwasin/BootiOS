//
//  MusicStatsView.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 4/8/20.
//

import SwiftUI

struct Row: Identifiable, Hashable {
    var id = UUID()
    var label: String
    var image: String
    var value: String
    var unit: String
}

struct MusicStatsView: View {
    var columns = [
        GridItem(.adaptive(minimum: 150, maximum: 300), spacing: 8)
    ]

    var array: [Row] = [
        Row(label: "Songs played", image: "music.quarternote.3", value: "1031", unit: "Songs"),
        Row(label: "Songs loved", image: "heart.fill", value: "59", unit: "Songs"),
        Row(label: "Plays", image: "play.fill", value: "3619", unit: "Times"),
        Row(label: "Time played", image: "stopwatch", value: "165:14", unit: "Songs"),
        Row(label: "Recently played", image: "timer", value: "134", unit: "Songs"),
        Row(label: "Skips", image: "forward.fill", value: "481", unit: ""),
        Row(label: "Downloads", image: "icloud.and.arrow.down", value: "1031", unit: "Songs"),
        Row(label: "Explicit", image: "e.square.fill", value: "293", unit: "Songs"),
        Row(label: "Genres", image: "guitars.fill", value: "7", unit: "Genres")
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(array) { row in
                    GroupBox(label: Label(row.label, systemImage: row.image)) {
                        HealthValueView(value: row.value, unit: row.unit)
                    }.groupBoxStyle(HealthGroupBoxStyle(color: .pink, destination: EmptyView()))
                }
            }.padding(.top).padding(.horizontal)
        }.background(Color(.systemGroupedBackground))
    }
}

struct MusicStatsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MusicStatsView()
        }
    }
}
