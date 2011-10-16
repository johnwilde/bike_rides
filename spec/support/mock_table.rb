class MockTable
  attr_reader :id
  def initialize(id)
    @id=id
  end
  def select(args)
    if args.eql?("geometry")
      YAML::load_file(File.join(File.dirname(__FILE__),'geo.yml'))
    elsif args.eql?("description")
      YAML::load_file(File.join(File.dirname(__FILE__),'description.yml'))
    else
      raise "Invalid argument to MockTable::select"
    end
  end

end
