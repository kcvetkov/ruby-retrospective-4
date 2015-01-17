module RBFS
  class File
    attr_accessor :data

    def self.parse(string_data)
      File.new(string_data.split(':', 2)[1])
    end

    def initialize(data = nil)
      @data = data
    end

    def data_type()
      case @data
      when NilClass then :nil
      when String then :string
      when Symbol then :symbol
      when Fixnum, Float then :number
      when TrueClass, FalseClass then :boolean
      end
    end

    def serialize()
      "#{data_type()}:#{data}"
    end
  end

  class Directory
    attr_reader :files, :directories

    def self.parse(string_data)
      #DirectoryParser.parse(string_data)
    end

    def initialize()
      @files = {}
      @directories = {}
    end

    def add_file(name, file)
      @files[name] = file
    end

    def add_directory(name, directory = nil)
      unless directory.nil?
        @directories[name] = directory
      else
        @directories[name] = Directory.new
      end
    end

    def [](name)
      if @directories.has_key? name
        @directories[name]
      else
        @files[name]
      end
    end

    def serialize()
      DirectorySerializer.serialize(self)
    end
  end

  class FileSerializer
    def self.serialize(files)
      result = "#{files.count}:"
      files.each do |name, file|
        serialized = file.serialize
        result += "#{name}:#{serialized.length}:#{serialized}"
      end
      result
    end
  end

  class DirectorySerializer
    def self.serialize(dir)
      "#{FileSerializer.serialize(dir.files)}" +
      "#{serialzie_directories(dir.directories)}"
    end

    private

    def self.serialzie_directories(directories)
      # try Enumerble#each_with_object([])
      result = "#{directories.count}:"
      directories.each do |name, directory|
        dir = DirectorySerializer.serialize(directory)
        result += "#{name}:#{dir.size}:#{dir}"
      end
      result
    end
  end
end