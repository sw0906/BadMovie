//
//  DataStack+Observing.swift
//  CoreStore
//
//  Copyright © 2015 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import CoreData
#if USE_FRAMEWORKS
    import GCDKit
#endif


// MARK: - DataStack

@available(OSX, unavailable)
public extension DataStack {
    
    /**
     Creates a `ObjectMonitor` for the specified `NSManagedObject`. Multiple `ObjectObserver`s may then register themselves to be notified when changes are made to the `NSManagedObject`.
     
     - parameter object: the `NSManagedObject` to observe changes from
     - returns: a `ObjectMonitor` that monitors changes to `object`
     */
    @warn_unused_result
    public func monitorObject<T: NSManagedObject>(object: T) -> ObjectMonitor<T> {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to observe objects from \(typeName(self)) outside the main thread."
        )
        
        return ObjectMonitor(
            dataStack: self,
            object: object
        )
    }
    
    /**
     Creates a `ListMonitor` for a list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: a `ListMonitor` instance that monitors changes to the list
     */
    @warn_unused_result
    public func monitorList<T: NSManagedObject>(from: From<T>, _ fetchClauses: FetchClause...) -> ListMonitor<T> {
        
        return self.monitorList(from, fetchClauses)
    }
    
    /**
     Creates a `ListMonitor` for a list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: a `ListMonitor` instance that monitors changes to the list
     */
    @warn_unused_result
    public func monitorList<T: NSManagedObject>(from: From<T>, _ fetchClauses: [FetchClause]) -> ListMonitor<T> {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to observe objects from \(typeName(self)) outside the main thread."
        )
        CoreStore.assert(
            fetchClauses.filter { $0 is OrderBy }.count > 0,
            "A ListMonitor requires an OrderBy clause."
        )
        
        return ListMonitor(
            dataStack: self,
            from: from,
            sectionBy: nil,
            fetchClauses: fetchClauses
        )
    }
    
    /**
     Asynchronously creates a `ListMonitor` for a list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list. Since `NSFetchedResultsController` greedily locks the persistent store on initial fetch, you may prefer this method instead of the synchronous counterpart to avoid deadlocks while background updates/saves are being executed.
     
     - parameter createAsynchronously: the closure that receives the created `ListMonitor` instance
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     */
    public func monitorList<T: NSManagedObject>(createAsynchronously createAsynchronously: (ListMonitor<T>) -> Void, _ from: From<T>, _ fetchClauses: FetchClause...) {
        
        self.monitorList(createAsynchronously: createAsynchronously, from, fetchClauses)
    }
    
    /**
     Asynchronously creates a `ListMonitor` for a list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list. Since `NSFetchedResultsController` greedily locks the persistent store on initial fetch, you may prefer this method instead of the synchronous counterpart to avoid deadlocks while background updates/saves are being executed.
     
     - parameter createAsynchronously: the closure that receives the created `ListMonitor` instance
     - parameter from: a `From` clause indicating the entity type
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     */
    public func monitorList<T: NSManagedObject>(createAsynchronously createAsynchronously: (ListMonitor<T>) -> Void, _ from: From<T>, _ fetchClauses: [FetchClause])  {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to observe objects from \(typeName(self)) outside the main thread."
        )
        CoreStore.assert(
            fetchClauses.filter { $0 is OrderBy }.count > 0,
            "A ListMonitor requires an OrderBy clause."
        )
        
        _ = ListMonitor(
            dataStack: self,
            from: from,
            sectionBy: nil,
            fetchClauses: fetchClauses,
            createAsynchronously: createAsynchronously
        )
    }
    
    /**
     Creates a `ListMonitor` for a sectioned list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter sectionBy: a `SectionBy` clause indicating the keyPath for the attribute to use when sorting the list into sections.
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: a `ListMonitor` instance that monitors changes to the list
     */
    @warn_unused_result
    public func monitorSectionedList<T: NSManagedObject>(from: From<T>, _ sectionBy: SectionBy, _ fetchClauses: FetchClause...) -> ListMonitor<T> {
        
        return self.monitorSectionedList(from, sectionBy, fetchClauses)
    }
    
    /**
     Creates a `ListMonitor` for a sectioned list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list.
     
     - parameter from: a `From` clause indicating the entity type
     - parameter sectionBy: a `SectionBy` clause indicating the keyPath for the attribute to use when sorting the list into sections.
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     - returns: a `ListMonitor` instance that monitors changes to the list
     */
    @warn_unused_result
    public func monitorSectionedList<T: NSManagedObject>(from: From<T>, _ sectionBy: SectionBy, _ fetchClauses: [FetchClause]) -> ListMonitor<T> {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to observe objects from \(typeName(self)) outside the main thread."
        )
        CoreStore.assert(
            fetchClauses.filter { $0 is OrderBy }.count > 0,
            "A ListMonitor requires an OrderBy clause."
        )
        
        return ListMonitor(
            dataStack: self,
            from: from,
            sectionBy: sectionBy,
            fetchClauses: fetchClauses
        )
    }
    
    /**
     Asynchronously creates a `ListMonitor` for a sectioned list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list. Since `NSFetchedResultsController` greedily locks the persistent store on initial fetch, you may prefer this method instead of the synchronous counterpart to avoid deadlocks while background updates/saves are being executed.
     
     - parameter createAsynchronously: the closure that receives the created `ListMonitor` instance
     - parameter from: a `From` clause indicating the entity type
     - parameter sectionBy: a `SectionBy` clause indicating the keyPath for the attribute to use when sorting the list into sections.
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     */
    public func monitorSectionedList<T: NSManagedObject>(createAsynchronously createAsynchronously: (ListMonitor<T>) -> Void, _ from: From<T>, _ sectionBy: SectionBy, _ fetchClauses: FetchClause...) {
        
        self.monitorSectionedList(createAsynchronously: createAsynchronously, from, sectionBy, fetchClauses)
    }
    
    /**
     Asynchronously creates a `ListMonitor` for a sectioned list of `NSManagedObject`s that satisfy the specified fetch clauses. Multiple `ListObserver`s may then register themselves to be notified when changes are made to the list. Since `NSFetchedResultsController` greedily locks the persistent store on initial fetch, you may prefer this method instead of the synchronous counterpart to avoid deadlocks while background updates/saves are being executed.
     
     - parameter createAsynchronously: the closure that receives the created `ListMonitor` instance
     - parameter from: a `From` clause indicating the entity type
     - parameter sectionBy: a `SectionBy` clause indicating the keyPath for the attribute to use when sorting the list into sections.
     - parameter fetchClauses: a series of `FetchClause` instances for fetching the object list. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
     */
    public func monitorSectionedList<T: NSManagedObject>(createAsynchronously createAsynchronously: (ListMonitor<T>) -> Void, _ from: From<T>, _ sectionBy: SectionBy, _ fetchClauses: [FetchClause]) {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to observe objects from \(typeName(self)) outside the main thread."
        )
        CoreStore.assert(
            fetchClauses.filter { $0 is OrderBy }.count > 0,
            "A ListMonitor requires an OrderBy clause."
        )
        
        _ = ListMonitor(
            dataStack: self,
            from: from,
            sectionBy: sectionBy,
            fetchClauses: fetchClauses,
            createAsynchronously: createAsynchronously
        )
    }
}
