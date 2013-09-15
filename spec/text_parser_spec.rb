require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
class TestTextParser < MiniTest::Test
  
  include BioExominer

  BUF =<<TEXT

  Hello world. Test gene GEN1.X. This is with context! I don't believe this is true,
  and that you can do this. Love Ruby, love RDF. Love the combination.
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token GEN2.X out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
  Fish the token out of a very long sentence
TEXT

  def test_tokenize_with_context
    counts,match = TextParser::tokenize_with_context(BUF)
    assert_equal counts['world'],1
    assert_equal counts['Love'],2
    assert_equal match['world'], ['Hello world']
    assert_equal match['Love'], ['Love Ruby, love RDF', 'Love the combination']
    assert_equal match['context'], ['This is with context! I don\'t believe this is true, and that you can do this']
    assert_equal match['GEN1.X'], ['Test gene GEN1.X']
    assert_equal match['GEN2.X'], ['Fish the token out of a very long sentence Fish the token GEN2.X out of a very long sentence Fish the token out of a']
  end

  BUF2 =<<TEXT2
  valid token figure S11 table XX p53
  Invalid MD, and RD Jester, Wikkel W, Wokkel WOS 
TEXT2

  def test_valid_tokens 
    match = TextParser::tokenize(BUF2)
    assert match['token']
    assert !match['S11']
    assert !match['XX']
    assert !match['Wokkel']
    assert match['p53']
    assert match['WOS']
    assert !match['MD']
    assert !match['Invalid']
    assert !match['RD']
    assert !match['Jester']
    assert !match['Wikkel']
    assert !match['W']
  end
end
