import Combine
import Dispatch
import Foundation

//Just(1)
//.debounce(for: <#T##SchedulerTimeIntervalConvertible & Comparable & SignedNumeric#>, scheduler: )

var cancellable: Set<AnyCancellable> = []

DispatchQueue.main.schedule{
    print("DispatchQueue")
}

//DispatchQueue.main.asyncAfter(deadline: .now() + 1){
//
//}
DispatchQueue.main.schedule(after: .init(.now() + 1)){
    print("DispatchQueue", "delayed")
}
DispatchQueue.main.schedule(after: .init(.now() + 1), interval: 1){
    print("DispatchQueue", "timer")
}.store(in: &cancellable)


//RunLoop
RunLoop.main.schedule{
    print("Runloop")
}
RunLoop.main.schedule(after: .init(Date() + 1)){
    print("Runloop", "delayed")
}
RunLoop.main.schedule(after: .init(Date() + 1), interval: 1){
    print("Runloop", "timer")
}.store(in: &cancellable)

//OperationQuque
OperationQueue.main.schedule{
    print("OperationQueue")
}
OperationQueue.main.schedule(after: .init(Date() + 1)){
    print("OperationQueue", "delayed")
}
OperationQueue.main.schedule(after: .init(Date() + 1), interval: 1){
    print("OperationQueue", "timer")
}.store(in: &cancellable)
