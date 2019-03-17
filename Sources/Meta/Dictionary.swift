// Internal extension for 'Swift.Dictionary'

extension Dictionary {

    internal func formEncodedString() -> String {
        var result = ""
        for item in self {
            let key = String(describing: item.key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            guard !key.isEmpty else {
                continue
            }
            if let values = item.value as? [Any] {
                for value in values {
                    let value = String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    if let value = value, value.count > 0 {
                        result.append("\(key)=\(value)&")
                    }
                    else {
                        result.append("\(key)&")
                    }
                }
            }
            else {
                let value = String(describing: item.value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let value = value, !value.isEmpty {
                    result.append("\(key)=\(value)&")
                }
                else {
                    result.append("\(key)&")
                }
            }
        }
        while result.last == "&" {
            result.removeLast()
        }
        return result
    }
}
