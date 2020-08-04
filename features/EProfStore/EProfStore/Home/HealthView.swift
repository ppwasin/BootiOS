//
//  HomveView.swift
//  EProfStore
//
//  Created by Wasin Passornpakorn on 4/8/20.
//

import SwiftUI

struct HealthData<V: View>: Identifiable {
    let id = UUID()
    let title: String
    let symbol: String
    let value: String
    let unit: String
    let date: Date? = nil
    let color: Color
    let detailView: V
}

struct HealthView: View {
    var healthData: [HealthData<AnyView>] = []
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(healthData) { item in
                        GroupBox(label: Label(item.title, systemImage: item.symbol)) {
                            HealthValueView(value: item.value, unit: item.unit)
                        }
                        .groupBoxStyle(HealthGroupBoxStyle(color: item.color, destination: item.detailView, date: item.date))
                    }
                }.padding()

                VStack(spacing: 8) {
                    GroupBox(label: Label("Heart rate", systemImage: "heart.fill")) {
                        HealthValueView(value: "69", unit: "BPM")
                    }.groupBoxStyle(HealthGroupBoxStyle(color: .red, destination: Text("Heart rate")))
                    GroupBox(label: Label("Weight", systemImage: "figure.wave")) {
                        HealthValueView(value: "72.3", unit: "kg")
                    }.groupBoxStyle(HealthGroupBoxStyle(color: .purple, destination: Text("Weight")))
                    GroupBox(label: Label("Headphone noise level", systemImage: "ear")) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                (Text("\(Image(systemName: "checkmark.circle.fill"))").foregroundColor(.green) + Text(" OK")).font(.system(.headline, design: .rounded))
                                Text("7 days pressure").font(.system(.callout, design: .rounded)).foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }.groupBoxStyle(HealthGroupBoxStyle(color: .blue, destination: Text("Headphone noise level")))
                    GroupBox(label: Label("Resting heart rate", systemImage: "heart.fill")) {
                        HealthValueView(value: "52", unit: "BPM")
                    }.groupBoxStyle(HealthGroupBoxStyle(color: .red, destination: Text("Resting heart rate")))
                    GroupBox(label: Label("Sleep analysis", systemImage: "bed.double.fill")) {
                        HStack {
                            HealthValueView(value: "8", unit: "h")
                            HealthValueView(value: "37", unit: "min").padding(.leading, -140)
                        }
                    }.groupBoxStyle(HealthGroupBoxStyle(color: .orange, destination: Text("Sleep analysis")))
                    GroupBox(label: Label("Steps", systemImage: "flame.fill")) {
                        HealthValueView(value: "4019", unit: "Steps")
                    }.groupBoxStyle(HealthGroupBoxStyle(color: Color(red: 254 / 255, green: 87 / 255, blue: 45 / 255, opacity: 1), destination: Text("Steps")))
                }.padding()
            }.background(Color(.systemGroupedBackground)).edgesIgnoringSafeArea(.bottom)
                .navigationTitle("Health")
        }
    }
}

struct HealthView_Previews: PreviewProvider {
    static var previews: some View {
        HealthView(healthData: [
            HealthData(title: "Heart rate", symbol: "heart.fill", value: "69", unit: "BPM", color: .red, detailView: AnyView(Text("Heart rate"))),
            HealthData(title: "Weight", symbol: "heart.fill", value: "72.3", unit: "kg", color: .purple, detailView: AnyView(Text("Weight"))),
        ])
    }
}
