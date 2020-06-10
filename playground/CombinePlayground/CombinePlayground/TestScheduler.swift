//
//  TestScheduler.swift
//  CombinePlayground
//
//  Created by Wasin Passornpakorn on 8/6/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Combine
import Dispatch

final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    var now: SchedulerTimeType
    
    var minimumTolerance: SchedulerTimeType.Stride = 0
    
    // action: testScheduler.schedule { action }
    // date: the date that will be invoke action, see usage in advance
    private var scheduled: [(id: Int, action: () -> Void, date: SchedulerTimeType)] = []
    private var lastId = 0
    
    init(now: SchedulerTimeType) {
        self.now = now
    }
    
    func advance(by stride: SchedulerTimeType.Stride = .zero) {
        self.scheduled.sort { lhs, rhs in (lhs.date, lhs.id) < (rhs.date, rhs.id) }
        guard
            let nextDate = scheduled.first?.date,
            self.now.advanced(by: stride) >= nextDate
        else {
            self.now = self.now.advanced(by: stride)
            return
        }
        
        let nextStride = stride - self.now.distance(to: nextDate)
        self.now = nextDate
        
        // execute action first one and remove it
        while let (_, action, date) = self.scheduled.first, date == nextDate {
            self.scheduled.removeFirst()
            action()
        }
        
        //First input 10 => 9, 8, 7
        self.advance(by: nextStride)
        
//        self.now = self.now.advanced(by: stride) // move now to stride date
//        var index = 0
//        while index < self.scheduled.count {
//            let (id, action, date) = self.scheduled[index]
//            if date <= self.now {
//                action()
//                self.scheduled.remove(at: index)
//            }
//            else {
//                index += 1
//            }
//        }
        
//        for (id, action, date) in self.scheduled {
//            if date <= self.now {
//                action()
//            }
//        }
        
        self.scheduled.removeAll(where: { $0.date <= self.now })
    }
    
    func schedule(
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        self.scheduled.append((self.nextId(), action, self.now))
    }
    
    func schedule(
        after date: SchedulerTimeType,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        self.scheduled.append((self.nextId(), action, date))
    }
    
    func schedule(
        after date: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) -> Cancellable {
        let id = self.nextId()
        func scheduledAction(for date: SchedulerTimeType) -> () -> Void {
            return { [weak self] in
                let nextDate = date.advanced(by: interval)
                self?.scheduled.append((id, scheduledAction(for: nextDate), nextDate))
                action()
            }
        }
        
        self.scheduled.append((id, scheduledAction(for: date), date))
        
//        (1...1_000_000).forEach { index in
//            let nextDate = date.advanced(
//                by: interval * (SchedulerTimeType.Stride(exactly: index) ?? .zero)
//            )
//            self.schedule(after: nextDate, action)
//        }
        
        return AnyCancellable {
            self.scheduled.removeAll(where: { $0.id == id })
        }
    }
    
    private func nextId() -> Int {
        self.lastId += 1
        return self.lastId
    }
}

extension DispatchQueue {
    static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions> {
        TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
    }
}
