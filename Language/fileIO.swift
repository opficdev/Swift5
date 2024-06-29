import Foundation

class fstream{
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
        
        let FM = FileManager.default
       if !FM.fileExists(atPath: fileURL.path) {
           FM.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
       }

        guard let fileHandle = try? FileHandle(forUpdating: fileURL),
              let attributes = try? FileManager.default.attributesOfItem(atPath: decodedPath),
              let fileSize = attributes[.size] as? Int else {
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

    func read(_ bytes: Int) -> String? {
        guard let pointer = mappedPointer else { return nil }
        let remainingBytes = fileSize - currentOffset
        let bytesToRead = min(bytes, remainingBytes)

        guard bytesToRead > 0 else { return nil }

        let data = Data(bytes: pointer.advanced(by: currentOffset), count: bytesToRead)
        currentOffset += bytesToRead
        return String(data: data, encoding: .utf8)
    }
    
    func read() -> String? {
        guard let pointer = mappedPointer else { return nil }
        return String(data: Data(bytes: pointer.advanced(by: 0), count: fileSize), encoding: .utf8)
    }
    
    func seek(to offset: Int) {
        currentOffset = min(max(0, offset), fileSize)
    }

    var isEOF: Bool {
        return currentOffset >= fileSize
    }

    func readLine() -> String? {
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
    
    func write(_ data: Any){
        do {
            let data = String(describing: data)
            try data.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Something wrong data!!")
        }
    }
}
