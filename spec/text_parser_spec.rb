require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
class TestTextParser < MiniTest::Unit::TestCase
  
  include BioExominer

  BUF =<<TEXT

  Hello world. Test gene GEN1.X. This is with context! I don't believe this is true,
  and that you can do this. Love Ruby, love RDF. Love the combination.
TEXT

  def test_tokenize_with_context
    counts,match = TextParser::tokenize_with_context(BUF)
    assert_equal counts['world'],1
    assert_equal counts['Love'],2
    assert_equal match['world'], ['Hello world']
    assert_equal match['Love'], ['Love Ruby, love RDF', 'Love the combination']
    assert_equal match['context'], ['This is with context! I don\'t believe this is true, and that you can do this']
    assert_equal match['GEN1.X'], ['Test gene GEN1.X']
  end

end
