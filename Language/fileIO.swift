import Foundation

func read(_ title: String) -> [[String]]{
    let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(title)
    var lines: [[String]] = []
    do {
        let fileHandle = try FileHandle(forReadingFrom: fileURL)
        
        var fileContent = ""

        let data = fileHandle.readDataToEndOfFile()
        if let content = String(data: data, encoding: .utf8) {
            fileContent = content
        }
        fileHandle.closeFile()
        
        let filter = fileContent.contains("\r\n") ? "\r\n" : "\n"
        
        lines = fileContent.split(separator: filter).map{$0.split(separator: " ").map{String($0)}}
        

    } catch {
        print(error)
    }
    return lines
}

func write(_ title: String, _ data: String){
    let currentFileURL = URL(fileURLWithPath: #file)
    let directoryURL = currentFileURL.deletingLastPathComponent()
    let fileURL = directoryURL.appendingPathComponent(title)

    do {
        try data.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
        print(error)
    }
}
