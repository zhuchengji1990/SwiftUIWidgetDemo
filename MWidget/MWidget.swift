//
//  MWidget.swift
//  MWidget
//
//  Created by 沉寂 on 2020/12/18.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            if let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate){
                let entry = SimpleEntry(date: entryDate, configuration: configuration)
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}


struct MWidgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .systemSmall: SmallView(entry: entry)
        case .systemMedium: MediumView(entry: entry)
        case .systemLarge: LargeView(entry: entry)
        default: SmallView(entry: entry)
        }
    }
}

struct SmallView: View {
    var entry: Provider.Entry
    @State var progress: Double = 0.12
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(Date.zero, style: .date).bold()
                .font(.system(size: 10))
                .lineLimit(1)
            //这里有个bug，style是timer，Text的宽度就会最大化，等待苹果公司后续优化
            Text(Date.zero, style: .timer).bold()
                .font(.system(size: 28))
            
            HStack{
                CircleProgress(progress: $progress)
                
            }.frame(maxWidth: .infinity)
        }.padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MediumView: View {
    var entry: Provider.Entry
    @State var progress: Double = 0.34
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 10){
                Text(Date.zero, style: .date).bold()
                    .font(.system(size: 10))
                    .lineLimit(1)
                
                Text(Date.zero, style: .timer).bold()
                    .font(.system(size: 28))
            }
            CircleProgress(progress: $progress)
        }.padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LargeView: View {
    var entry: Provider.Entry
    @State var progress: Double = 0.56
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text(Date.zero, style: .date).bold()
                .font(.system(size: 10))
                .lineLimit(1)
            
            Text(Date.zero, style: .timer).bold()
                .font(.system(size: 28))
            
            HStack{
                CircleProgress(progress: $progress)
            }.frame(maxWidth: .infinity)
        }.padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@main
struct MWidget: Widget {
    let kind: String = "MWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}


struct MWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            MWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            MWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

extension Date{
    static var zero: Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.date(from: formatter.string(from: Date())) ?? Date()
    }
}
