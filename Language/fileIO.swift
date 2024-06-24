import Foundation

class fstream {
    private var fileHandle: FileHandle? = nil
    private var buffer: Data
    private let bufferSize: Int
    private let fileURL: URL
    private let mode: String
    
    init?(_ fileName: String, _ mode: String, bufferSize: Int = 4096) {
        if mode != "r" && mode != "w"{
            print("Wrong mode")
            return nil
        }
        self.fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(fileName)
        
        do {
            if mode == "r"{
                self.fileHandle = try FileHandle(forReadingFrom: self.fileURL)
            }
            else{
                self.fileHandle = FileHandle() //dummy
            }
        } catch {
            return nil
        }
        self.mode = mode
        self.buffer = Data(capacity: bufferSize)
        self.bufferSize = bufferSize
     }
    deinit {
        if fileHandle != nil{
            fileHandle!.closeFile()
        }
    }
    
    
    func readLine() -> String? {
        guard self.mode == "r" else {
            print("This function can use read mode only.")
            return nil
        }
        var line = Data()
        var byte: UInt8 = 0
        
        while true {
            if buffer.isEmpty {
                buffer = fileHandle!.readData(ofLength: bufferSize)
                if buffer.isEmpty {
                    return line.isEmpty ? nil : String(data: line, encoding: .utf8)!
                }
            }

            byte = buffer.removeFirst()
            
            if byte == 10{ // 10: \n
                return String(data: line, encoding: .utf8)!
            }
            
            if byte != 13{ //13: \r
                line.append(byte)
            }
        }
    }
    
    func read() -> [[String]]?{
        guard self.mode == "r" else {
            print("This function can use read mode only.")
            return nil
        }
        
        var lines: [[String]] = []
        do {
            let fileHandle = try FileHandle(forReadingFrom: fileURL)
            
            var fileContent = ""

            let data = fileHandle.readDataToEndOfFile()
            if let content = String(data: data, encoding: .utf8) {
                fileContent = content
            }
            
            let filter = fileContent.contains("\r\n") ? "\r\n" : "\n"
            
            lines = fileContent.split(separator: filter).map{$0.split(separator: " ").map{String($0)}}
            

        } catch {
            print(error)
        }
        return lines
    }
    
    func write(_ data: Any){
        guard self.mode == "w" else {
            print("This function can use write mode only.")
            return
        }
       
        do {
            let data = String(describing: data)
            try data.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Something wrong write data!!")
        }
    }
}
