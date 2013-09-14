# require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
# gem "minitest"
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# require 'rspec'

require 'rubygems'
gem 'minitest' # ensures you're using the gem, and not the built in MT
require 'minitest/autorun'

require 'bio-exominer'

require 'minitest/autorun'

class TestRDF < MiniTest::Unit::TestCase
  
  include BioExominer

  def test_uri_escape
    assert_equal !RDF::escape("")
  end

  def test_uri_validator
    # invalid
    assert !RDF::valid_uri?("use`quote")
    # assert !RDF::valid_uri?("use%7quote")

    # valid
    assert RDF::valid_uri?("use%07quote")

  end

  def test_make_identifier
    assert_equal RDF::make_identifier("AA"), "AA"
    assert_equal RDF::make_identifier("use:colon:"), "use_colon_"
    assert_equal RDF::make_identifier("use|pipe"), "use_pipe"
  end

end
