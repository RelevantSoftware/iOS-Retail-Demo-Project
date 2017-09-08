//
//  ListType.swift
//

typealias AnyType = Initializable.Type

protocol ContainerType {
    func elementType() -> AnyType
}

extension Array: ContainerType {
    func elementType() -> AnyType {
        return (Element.self as! Initializable.Type)
    }
}