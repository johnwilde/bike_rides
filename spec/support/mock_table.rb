class MockTable
  attr_reader :id
  def initialize(id, geo_file, desc_file)
    @id=id
    @geo = geo_file
    @description = desc_file
  end
  def select(args)
    if args.eql?("geometry")
      YAML::load_file(File.join(File.dirname(__FILE__), @geo))
    elsif args.eql?("description")
      # example data
      return [{:description=>nil}, {:description=>nil}] if @description.empty?
      YAML::load_file(File.join(File.dirname(__FILE__), @description))
    else
      raise "Invalid argument to MockTable::select"
    end
  end

end
