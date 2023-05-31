require "./filemanager"

class PlayManager
    def initialize(filename)
        @filename = filename
        @questions_list = FileManager.read_file(@filename)
    end

    def start()
        puts "Start a Family Feud game"
        
        for question in @questions_list
            puts question.to_s()
        end
    end
end
