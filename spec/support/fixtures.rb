fixtures_dir = File.expand_path('../../fixtures', __FILE__)

RSpec.configuration.include Module.new {
  define_method(:fixtures_dir) do
    fixtures_dir
  end

  define_method(:fixture_path) do |filename|
    File.join(fixtures_dir, filename)
  end
}
