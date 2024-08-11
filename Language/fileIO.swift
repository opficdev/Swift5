import Foundation

///A class used to read files using fileHandle.
class FileReader{
    private let fileHandle: FileHandle
    private let fileURL: URL
    private let fileSize: Int
    private let pageSize: Int
    private var mappedPointer: UnsafeMutableRawPointer?
    private var currentOffset: Int = 0
    
    init?(_ fileName: String, _ path: String = #file) {
        self.fileURL = URL(fileURLWithPath: path).deletingLastPathComponent().appendingPathComponent(fileName)

        guard let decodedPath = fileURL.path.removingPercentEncoding else {
            return nil
        }

        guard let fileHandle = try? FileHandle(forReadingFrom: self.fileURL),
              let attributes = try? FileManager.default.attributesOfItem(atPath: decodedPath),
              let fileSize = attributes[.size] as? Int else {
            print("File: \"\(fileName)\" is not Exist!")
            return nil
        }

        self.fileHandle = fileHandle
        self.fileSize = fileSize
        self.pageSize = Int(Darwin.getpagesize())

        mapMemory()
    }

    deinit {
        unmapMemory()
        try? fileHandle.close()
    }

    private func mapMemory() {
        let fileDescriptor = CInt(fileHandle.fileDescriptor)
        mappedPointer = mmap(nil, fileSize, PROT_READ, MAP_PRIVATE, fileDescriptor, 0)
    }

    private func unmapMemory() {
        if let pointer = mappedPointer {
            munmap(pointer, fileSize)
        }
    }
    
    private func seek(to offset: Int) {
        currentOffset = min(max(0, offset), fileSize)
    }
    
    private func readLineHelper() -> String?{
        guard let pointer = mappedPointer, !isEOF else { return nil }

        var lineEnd = currentOffset
        var count13 = 0 //\r의 갯수
        while lineEnd < fileSize {
            let byte = pointer.load(fromByteOffset: lineEnd, as: UInt8.self)
            if byte == 10 { // ASCII code for newline
                break
            }
            if byte == 13{
                count13 += 1
            }
            lineEnd += 1
        }

        let lineLength = lineEnd - currentOffset - count13
        let line = String(bytes: UnsafeRawBufferPointer(start: pointer.advanced(by: currentOffset), count: lineLength), encoding: .utf8)

        currentOffset = min(lineEnd + 1, fileSize) // Move past the newline
        return line
    }
    
    ///Get current EOF or not.
    var isEOF: Bool {
        return currentOffset >= fileSize
    }

    ///Read n bytes of file.
    func read(_ bytes: Int) -> String? {
        guard let pointer = mappedPointer else { return nil }
        let remainingBytes = fileSize - currentOffset
        let bytesToRead = min(bytes, remainingBytes)

        guard bytesToRead > 0 else { return nil }

        let data = Data(bytes: pointer.advanced(by: currentOffset), count: bytesToRead)
        currentOffset += bytesToRead
        return String(data: data, encoding: .utf8)
    }
    
    ///Read all file.
    func read() -> String? {
        guard let pointer = mappedPointer else { return nil }
        return String(data: Data(bytes: pointer.advanced(by: 0), count: fileSize), encoding: .utf8)
    }
    
    ///Read 1 line of file.
    func readLine(readAll: Bool = false) -> String? { //readAll = true: 아무 내용없는 줄도 내용 있다고 판별
        var line: String?
        
        if let initialLine = readLineHelper() {
            line = initialLine
            
            if !readAll && line == ""{  
                while let nextLine = readLineHelper(){
                    line = nextLine
                    if line != ""{
                        break
                    }
                }
            }
        }
        return line
    }
}

///A class used to write file using String.
class FileWriter{
    private let fileURL: URL
    init(_ fileName: String, _ path: String = #file){
        self.fileURL = URL(fileURLWithPath: path).deletingLastPathComponent().appendingPathComponent(fileName)
    }
    
    ///Write a date to file.
    func write(_ data: Any){
        do {
            let data = String(describing: data)
            try data.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Wrong Input data!!")
        }
    }
}
