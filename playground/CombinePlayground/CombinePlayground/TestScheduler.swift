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
        self.now = self.now.advanced(by: stride) // move now to stride date
        var index = 0
        while index < self.scheduled.count {
            let (id, action, date) = self.scheduled[index]
            if date <= self.now {
                action()
                self.scheduled.remove(at: index)
            }
            else{
                index += 1
            }
        }
        
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
        scheduled.append((nextId(), action, self.now))
    }
    
    func schedule(
        after date: SchedulerTimeType,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        scheduled.append((nextId(), action, date))
    }
    
    func schedule(
        after date: SchedulerTimeType,
        interval: SchedulerTimeType.Stride,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) -> Cancellable {
        let id = nextId()
        func scheduledAction(for date: SchedulerTimeType) -> () -> Void {
            return { [weak self] in
                action()
                let nextDate = date.advanced(by: interval)
                self?.scheduled.append((id, scheduledAction(for: nextDate), nextDate))
            }
        }
        
        scheduled.append((id, scheduledAction(for: date), date))
        
//        (1...1_000_000).forEach { index in
//            let nextDate = date.advanced(
//                by: interval * (SchedulerTimeType.Stride(exactly: index) ?? .zero)
//            )
//            self.schedule(after: nextDate, action)
//        }
        
        return AnyCancellable {
            self.scheduled.removeAll(where: { $0.id == id})
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
