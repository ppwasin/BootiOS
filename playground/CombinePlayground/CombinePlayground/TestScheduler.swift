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
    
    private var scheduled: [(action: () -> Void, date: SchedulerTimeType)] = []
    
    init(now: SchedulerTimeType) {
        self.now = now
    }
    
    func advanced(by stride: SchedulerTimeType.Stride = .zero) {
        self.now = self.now.advanced(by: stride) //move now to stride date
        for (action, date) in self.scheduled {
            if date <= self.now {
                action()
            }
        }
        self.scheduled.removeAll(where: { $0.date <= self.now })
    }
    
    func schedule(
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        self.scheduled.append((action, self.now))
    }
    
    func schedule(
        after date: SchedulerTimeType,
        tolerance _: SchedulerTimeType.Stride,
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        self.scheduled.append((action, date))
    }
    
    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        return AnyCancellable {}
    }
}

extension DispatchQueue {
    static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions> {
        TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
    }
}
