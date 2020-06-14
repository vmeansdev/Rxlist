extension Collection {

    func element(at index: Index) -> Self.Iterator.Element? {
        indices.contains(index) ? self[index] : nil
    }

}
